import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:weebooks2/models/ebook.dart';
import 'package:weebooks2/models/livro.dart';
import 'package:weebooks2/models/meta.dart';
import 'package:weebooks2/models/estatisticas.dart';
import 'package:weebooks2/services/database.dart';
import 'package:intl/intl.dart';

class UserViewModel with ChangeNotifier {
  List<Livro> _userRecentes = [];
  List<Livro> get userRecentes => _userRecentes;

  Estatisticas _userPaginasLidas;
  Estatisticas get userPaginasLidas => _userPaginasLidas;

  Estatisticas _userTotalLidos;
  Estatisticas get userTotalLidos => _userTotalLidos;

  Metas _userMetas;
  Metas get userMetas => _userMetas;

  List<Livro> _buscasRecentes = [];
  List<Livro> get buscasRecentes => _buscasRecentes;

  Map<String, dynamic> _userCategorias = {};
  Map<String, dynamic> get userCategorias => _userCategorias;

  Map<String, dynamic> _userCategoriasE = {};
  Map<String, dynamic> get userCategoriasE => _userCategoriasE;

  List<Livro> _userLivros = [];
  List<Livro> get userLivros => _userLivros;

  List<Ebook> _userEbooks = [];
  List<Ebook> get userEbooks => _userEbooks;

  UserViewModel() {
    print("----------Starting UserViewModel------------");
  }

  Future<Metas> checkMetas(Metas metas) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String aux = prefs.getString('data');
    DateFormat formatter = DateFormat('yyyy-MM-dd');
    if (aux == null) {
      aux = formatter.format(DateTime.now());
      await prefs.setString('data', aux);
    }

    DateTime data = DateTime.parse(aux);
    DateTime now = DateTime.now();

    if (aux != formatter.format(now)) {
      // print("Setting Data...");
      await prefs.setString('data', formatter.format(now));
    }

    bool hasChanged = false;
    if (data.day != now.day) {
      metas.metaDiaria.metaAtual = 0;
      hasChanged = true;
    }
    if (data.month != now.month) {
      metas.metaMensal.metaAtual = 0;
      hasChanged = true;
    }
    if (data.year != now.year) {
      metas.metaAnual.metaAtual = 0;
      hasChanged = true;
    }
    if (hasChanged) {
      final DatabaseService _data = DatabaseService();
      await _data.atualizarMeta(metas);
    }
    // print(metas.toJson().toString());
    return metas;
  }

  Future<bool> getUserData({type}) async {
    List userData = await DatabaseService().getStarted();
    if (userData != null) {
      if (type == 3) {
        _userMetas = await checkMetas(userData[3]);
      } else if (type == 4) {
        _buscasRecentes = userData[4];
      } else {
        _userRecentes = userData[0];
        _userPaginasLidas = userData[1];
        _userTotalLidos = userData[2];
        _userMetas = await checkMetas(userData[3]);
        _buscasRecentes = userData[4];
        _userCategorias = userData[5];
        _userLivros = userData[6];
        _userEbooks = userData[7];
        _userCategoriasE = userData[8];
      }

      notifyListeners();
      return true;
    }
  }
}
