import 'package:flutter/material.dart';
import 'package:weebooks2/models/livro.dart';
import 'package:weebooks2/models/meta.dart';
import 'package:weebooks2/models/estatisticas.dart';
import 'package:weebooks2/services/database.dart';

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

  List<String> _userCategorias = [];
  List<String> get userCategorias => _userCategorias;

  UserViewModel() {
    print("----------Starting UserViewModel------------");
  }

  Future<bool> getUserData({type}) async {
    List userData = await DatabaseService().getStarted();
    if (userData != null) {
      if (type == 3) {
        _userMetas = userData[3];
      } else if (type == 4) {
        _buscasRecentes = userData[4];
      } else {
        _userRecentes = userData[0];
        _userPaginasLidas = userData[1];
        _userTotalLidos = userData[2];
        _userMetas = userData[3];
        _buscasRecentes = userData[4];
        _userCategorias = userData[5];
      }

      notifyListeners();
      return true;
    }
  }
}
