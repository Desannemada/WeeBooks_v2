import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:weebooks2/models/ebook.dart';
import 'package:weebooks2/models/livro.dart';
import 'package:weebooks2/models/meta.dart';
import 'package:weebooks2/models/estatisticas.dart';
import 'package:weebooks2/services/auth.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

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
        // bool isEmpty = (livro.status == []);
        int pageCount = 0;
        int increment = 0;
        List remove = [];
        for (var item in livros) {
          List list = item['status'];
          if (list.isEmpty) {
            remove.add(item);
            recentes.removeWhere((element) => element['id'] == item['id']);
            pageCount = -item['pageCount'];
            increment = -1;
          }
        }
        for (var item in remove) {
          livros.remove(item);
        }

        return userDatabase.set({
          'biblioteca': {
            'livros': livros,
            'categorias': [categorias],
            'recentes': recentes,
          },
          'paginasLidas': {'livros': FieldValue.increment(pageCount)},
          'numeroLidos': {'livros': FieldValue.increment(increment)},
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

  Future<dynamic> addEbook(Ebook ebook, File file) async {
    DocumentReference userDatabase =
        (userCollection.doc(AuthService().getUserInfo().uid));

    return await userDatabase.get().then((value) async {
      List ebooks = [];
      bool ebookExiste = false;
      try {
        ebooks = value.get(FieldPath(['biblioteca', 'ebooks']));
        if (ebooks.isNotEmpty) {
          int index =
              ebooks.indexWhere((element) => element['title'] == ebook.title);
          if (index != -1) {
            ebookExiste = true;
            ebooks[index] = ebook.toJson();
          }
        }
      } catch (e) {
        print('ADD_EBOOK: EBOOKS - ' + e.toString());
      }

      Map categorias = {};
      try {
        categorias = value.get(FieldPath(['biblioteca', 'categoriasE']))[0];
      } catch (e) {
        print('ADD_EBOOK: CATEGORIAS - ' + e.toString());
      }
      List<String> emptyCategories = [];
      categorias.forEach((key, value) {
        value.remove(ebook.title);
        if (value.isEmpty) emptyCategories.add(key);
      });
      for (var key in emptyCategories) {
        categorias.remove(key);
      }
      for (var sts in ebook.status) {
        if (categorias.containsKey(sts.categoria)) {
          categorias[sts.categoria].add(ebook.title);
        } else {
          categorias[sts.categoria] = [ebook.title];
        }
      }
      print(categorias);

      if (!ebookExiste) {
        print("N EXISTE");
        try {
          await firebase_storage.FirebaseStorage.instance
              .ref(ebook.path)
              .putFile(file);
        } catch (e) {
          print('ADD_EBOOK_FIREBASE_STORAGE: ' + e.toString());
          return false;
        }
      }

      if (!ebookExiste) {
        return userDatabase.set({
          'biblioteca': {
            'ebooks': FieldValue.arrayUnion([ebook.toJson()]),
            'categoriasE': [categorias],
          },
          'paginasLidas': {'ebooks': FieldValue.increment(ebook.pageCount)},
          'numeroLidos': {'ebooks': FieldValue.increment(1)},
        }, SetOptions(merge: true)).then((value) {
          print("Ebook, pags, numLidos, categorias adicionados!");
          return true;
        }).catchError((e) {
          print("ADD_EBOOK: ADD NEW EBOOK - " + e.toString());
          return false;
        });
      } else {
        int pageCount = 0;
        int increment = 0;
        List remove = [];
        for (var item in ebooks) {
          List list = item['status'];
          if (list.isEmpty) {
            remove.add(item);
            pageCount = -item['pageCount'];
            increment = -1;
          }
        }
        for (var item in remove) {
          ebooks.remove(item);
        }

        return userDatabase.set({
          'biblioteca': {
            'ebooks': ebooks,
            'categoriasE': [categorias],
          },
          'paginasLidas': {'ebooks': FieldValue.increment(pageCount)},
          'numeroLidos': {'ebooks': FieldValue.increment(increment)},
        }, SetOptions(merge: true)).then((value) {
          print("Ebook, categorias adicionados!");

          return true;
        }).catchError((e) {
          // throw e;
          print("ADD_EBOOK: ADD EXISTING EBOOK - " + e.toString());
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

  Future<Ebook> getEbookByName(String name) async {
    return await userCollection
        .doc(AuthService().getUserInfo().uid)
        .get()
        .then((value) {
      List listaEbooks = value.get(FieldPath(['biblioteca', 'ebooks']));
      for (var ebook in listaEbooks) {
        Ebook aux = Ebook.fromJson(ebook);
        if (aux.title == name) {
          return aux;
        }
      }
      return null;
    }).catchError((error) {
      print('GET EBOOK BY NAME: ' + error.toString());
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
      <Livro>[],
      <Ebook>[],
      <String, dynamic>{},
    ];

    List<dynamic> keys = [
      ['biblioteca', 'recentes'], // 0
      'paginasLidas', // 1
      'numeroLidos', // 2
      'metas', // 3
      'buscasRecentes', // 4
      ['biblioteca', 'categorias'], // 5
      ['biblioteca', 'livros'], // 6
      ['biblioteca', 'ebooks'], // 7
      ['biblioteca', 'categoriasE'] // 8
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
        if (checked[6]) {
          for (var livro in (data[keys[6][0]][keys[6][1]])) {
            userInfo[6].add(
              Livro.fromJson(livro),
            );
          }
        }
        if (checked[7]) {
          for (var ebook in (data[keys[7][0]][keys[7][1]])) {
            userInfo[7].add(
              Ebook.fromJson(ebook),
            );
          }
        }
        if (checked[8]) {
          userInfo[8] = data[keys[8][0]][keys[8][1]][0];
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

  Future<bool> clearBuscasRecentes() async {
    DocumentReference userDatabase =
        (userCollection.doc(AuthService().getUserInfo().uid));

    return await userDatabase
        .set({'buscasRecentes': []}, SetOptions(merge: true)).then((value) {
      print("Buscas Recentes Excluidas");
      return true;
    }).catchError((error) {
      print("CLEAR_BUSCAS_RECENTES: " + error.toString());
      return false;
    });
  }

  Future<bool> atualizarEbookMarkings(Ebook ebook) async {
    DocumentReference userDatabase =
        (userCollection.doc(AuthService().getUserInfo().uid));
    // print(ebook.markings);
    List aux = await userCollection
        .doc(AuthService().getUserInfo().uid)
        .get()
        .then((value) {
      List listaEbooks = value.get(FieldPath(['biblioteca', 'ebooks']));
      for (var i = 0; i < listaEbooks.length; i++) {
        Ebook aux = Ebook.fromJson(listaEbooks[i]);
        if (aux.title == ebook.title) {
          aux.markings = ebook.markings;
          aux.markings.sort();
          listaEbooks[i] = aux.toJson();
          return listaEbooks;
        }
      }
      return null;
    }).catchError((error) {
      print('ATUALIZAR_EBOOK_MARKING_EBOOK_BY_NAME: ' + error.toString());
      return null;
    });

    if (aux != null) {
      return await userDatabase.set({
        'biblioteca': {
          'ebooks': aux,
        }
      }, SetOptions(merge: true)).then((value) {
        print("Ebook Marking Editado");
        return true;
      }).catchError((error) {
        print("ATUALIZAR_EBOOK_MARKING: " + error.toString());
        return false;
      });
    }
    return false;
  }
}

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
