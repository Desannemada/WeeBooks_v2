import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:weebooks2/models/livro.dart';
import 'package:weebooks2/models/meta.dart';
import 'package:weebooks2/models/estatisticas.dart';
import 'package:weebooks2/services/auth.dart';
import 'package:weebooks2/ui/telas/biblioteca/widgets/status.dart';

class DatabaseService {
  // coleção de usernames
  final CollectionReference usernameCollection =
      FirebaseFirestore.instance.collection('usernames');

  Future<bool> validateUsername(String username) async {
    DocumentSnapshot isValid = await usernameCollection.doc(username).get();
    return isValid.exists ? false : true;
  }

  Future<bool> createUsername(String username) async {
    bool resultado;
    await usernameCollection
        .doc(username)
        .set({})
        .then((value) => resultado = true)
        .catchError((error) => resultado = false);
    return resultado;
  }

  //coleção de usuarios
  final CollectionReference userCollection =
      FirebaseFirestore.instance.collection('usuarios');

  Future<dynamic> addBook(Livro livro) async {
    DocumentReference userDatabase =
        (userCollection.doc(AuthService().getUserInfo().uid));

    return await userDatabase.get().then((value) {
      List livros = [];
      bool livroExiste = false;
      try {
        livros = value.get(FieldPath(['biblioteca', 'livros']));
        if (livros.isNotEmpty) {
          int index = livros.indexWhere((element) => element['id'] == livro.id);
          if (index != -1) {
            livroExiste = true;
            livros[index] = livro.toJson();
          }
        }
      } catch (e) {
        print('ADD_BOOK: LIVROS - ' + e.toString());
      }

      List recentes = [];
      try {
        recentes = value.get(FieldPath(['biblioteca', 'recentes']));
        for (var rec in recentes) {
          if (rec['id'] == livro.id) {
            recentes.remove(rec);
            break;
          }
        }
        if (recentes.length == 10) {
          recentes = recentes.sublist(1);
        }
        recentes.add(livro.toJson());
      } catch (e) {
        print('ADD_BOOK: RECENTES - ' + e.toString());
      }

      Map categorias = {};
      try {
        categorias = value.get(FieldPath(['biblioteca', 'categorias']))[0];
      } catch (e) {
        print('ADD_BOOK: CATEGORIAS - ' + e.toString());
      }
      List<String> emptyCategories = [];
      categorias.forEach((key, value) {
        value.remove(livro.id);
        if (value.isEmpty) emptyCategories.add(key);
      });
      for (var key in emptyCategories) {
        categorias.remove(key);
      }
      for (var sts in livro.status) {
        if (categorias.containsKey(sts.categoria)) {
          categorias[sts.categoria].add(livro.id);
        } else {
          categorias[sts.categoria] = [livro.id];
        }
      }

      if (!livroExiste) {
        return userDatabase.set({
          'biblioteca': {
            'livros': FieldValue.arrayUnion([livro.toJson()]),
            'recentes': recentes.isEmpty
                ? FieldValue.arrayUnion([livro.toJson()])
                : recentes,
            'categorias': [categorias],
          },
          'paginasLidas': {'livros': FieldValue.increment(livro.pageCount)},
          'numeroLidos': {'livros': FieldValue.increment(1)},
        }, SetOptions(merge: true)).then((value) {
          print("Livro, recente, pags, numLidos adicionados!");
          return true;
        }).catchError((e) {
          print("ADD_BOOK: ADD NEW BOOK - " + e.toString());
          return false;
        });
      } else {
        return userDatabase.set({
          'biblioteca': {
            'livros': livros.isEmpty
                ? FieldValue.arrayUnion([livro.toJson()])
                : livros,
            'categorias': [categorias],
            'recentes': recentes.isEmpty
                ? FieldValue.arrayUnion([livro.toJson()])
                : recentes
          }
        }, SetOptions(merge: true)).then((value) {
          print("Livro, recente adicionados!");

          return true;
        }).catchError((e) {
          // throw e;
          print("ADD_BOOK: ADD EXISTING BOOK - " + e.toString());
          return false;
        });
      }
    });
  }

  Future<List<Livro>> getBooks() async {
    List<Livro> livros = [];
    await userCollection
        .doc(AuthService().getUserInfo().uid)
        .get()
        .then((value) {
      var listaLivros = value.get(FieldPath(['biblioteca', 'livros']));
      for (var livro in listaLivros) {
        livros.add(
          Livro.fromJson(livro),
        );
      }
    });
    return livros;
  }

  Future<Livro> getBookById(String id) async {
    return await userCollection
        .doc(AuthService().getUserInfo().uid)
        .get()
        .then((value) {
      List listaLivros = value.get(FieldPath(['biblioteca', 'livros']));
      for (var livro in listaLivros) {
        Livro aux = Livro.fromJson(livro);
        if (aux.id == id) {
          return aux;
        }
      }
      return null;
    }).catchError((error) {
      print('GET BOOK BY ID: ' + error.toString());
      return null;
    });
  }

  Future<dynamic> getStarted() async {
    bool docExists = await userCollection
        .doc(AuthService().getUserInfo().uid)
        .get()
        .then((value) => value.exists);

    List userInfo = [
      <Livro>[],
      Estatisticas(livros: 0, fics: 0, ebooks: 0),
      Estatisticas(livros: 0, fics: 0, ebooks: 0),
      Metas(
        metaAnual: MetaAnual(metaAtual: 0, metaDefinida: 0, tipo: -1),
        metaDiaria: MetaDiaria(metaAtual: 0, metaDefinida: 0, tipo: -1),
        metaMensal: MetaMensal(metaAtual: 0, metaDefinida: 0, tipo: -1),
      ),
      <Livro>[],
      <String, dynamic>{},
    ];

    List<dynamic> keys = [
      ['biblioteca', 'recentes'], // 0
      'paginasLidas', // 1
      'numeroLidos', // 2
      'metas', // 3
      'buscasRecentes', // 4
      ['biblioteca', 'categorias'] // 5
    ];

    if (docExists) {
      await userCollection
          .doc(AuthService().getUserInfo().uid)
          .get()
          .then((value) {
        Map<String, dynamic> data = value.data();
        List<bool> checked = checkKeys(data, keys);
        if (checked[0]) {
          for (var livro in (data[keys[0][0]][keys[0][1]])) {
            userInfo[0].add(
              Livro.fromJson(livro),
            );
          }
        }
        if (checked[1]) {
          userInfo[1] = Estatisticas.fromJson(data[keys[1]]);
        }
        if (checked[2]) {
          userInfo[2] = Estatisticas.fromJson(data[keys[2]]);
        }
        if (checked[3]) {
          userInfo[3] = Metas.fromJson(data[keys[3]]);
        }
        if (checked[4]) {
          for (var livro in data[keys[4]]) {
            userInfo[4].add(
              Livro.fromJson(livro),
            );
          }
        }
        if (checked[5]) {
          userInfo[5] = data[keys[5][0]][keys[5][1]][0];
        }
      }).catchError((error) {
        print('GET STARTED: ' + error.toString());
        return null;
      });
    }
    // print(userInfo);
    return userInfo;
  }

  Future<dynamic> atualizarMeta(Metas metas) async {
    DocumentReference userDatabase =
        (userCollection.doc(AuthService().getUserInfo().uid));

    return await userDatabase
        .set({'metas': metas.toJson()}, SetOptions(merge: true)).then((value) {
      print("Meta Editada");
      return true;
    }).catchError((error) {
      print("ATUALIZAR_META: " + error.toString());
      return false;
    });
  }

  Future<bool> atualizarBuscasRecentes(Livro livro) async {
    DocumentReference userDatabase =
        (userCollection.doc(AuthService().getUserInfo().uid));

    await userDatabase.get().then((value) {
      List buscasRecentes = [];
      Map<String, dynamic> tempLivro = livro.toJson();
      try {
        buscasRecentes = value.get(FieldPath(['buscasRecentes']));
        for (var busca in buscasRecentes) {
          if (busca['id'] == livro.id) {
            buscasRecentes.remove(busca);
            break;
          }
        }
        if (buscasRecentes.length == 10) {
          buscasRecentes = buscasRecentes.sublist(1);
        }
        buscasRecentes.add(tempLivro);
      } catch (e) {
        print('ATUALIZAR_BUSCAS_RECENTES_checkRecentes: ' + e.toString());
      }
      userDatabase.set({
        'buscasRecentes': buscasRecentes.isEmpty
            ? FieldValue.arrayUnion([tempLivro])
            : buscasRecentes
      }, SetOptions(merge: true)).then((value) {
        print("BuscasRecentes Atualizada");
        return true;
      }).catchError((e) {
        print('ATUALIZAR_BUSCAS_RECENTES: ' + e.toString());
        return false;
      });
    });
  }
}

Future<dynamic> atualizarStatusCategoria() async {}

//-------------------------------------------------------------------------------

bool checkKey(Map<String, dynamic> map, String key, {secondKey}) {
  if (secondKey == null) {
    return map.containsKey(key);
  } else {
    bool aux = map.containsKey(key);
    return aux ? map[key].containsKey(secondKey) : aux;
  }
}

List<bool> checkKeys(Map<String, dynamic> map, List<dynamic> keys) {
  List<bool> keysChecked = [];

  for (var key in keys) {
    if (key is List) {
      keysChecked.add(checkKey(map, key[0], secondKey: key[1]));
    } else {
      keysChecked.add(checkKey(map, key));
    }
  }
  return keysChecked;
}
