import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:weebooks2/models/livro.dart';
import 'package:weebooks2/models/ebook.dart';
import 'package:weebooks2/models/status.dart';
import 'package:weebooks2/services/database.dart';
import 'package:weebooks2/ui/shared/defaultDialog.dart';
import 'package:weebooks2/ui/telas/biblioteca/biblioteca.dart';
import 'package:weebooks2/ui/telas/biblioteca/widgets/metaLeitura/widgets/metaLeituraAtualizar.dart';
import 'package:weebooks2/ui/telas/biblioteca/widgets/metaLeitura/widgets/metaLeituraEditar.dart';

class HomeViewModel with ChangeNotifier {
  List botaoPrincipalOpcoes = [
    [
      ["Atualizar Meta", "Editar Metas"],
      [
        DefaultDialog(child: MetaLeituraAtualizar()),
        DefaultDialog(child: MetaLeituraEditar())
      ]
    ],
    // [
    //   ["", ""],
    //   [() {}, () {}]
    // ],
    // [],
    [
      ["Limpar Recentes"],
      ["limparRecentes"]
    ],
    // [
    //   ["", ""],
    //   [() {}, () {}]
    // ]
  ];

  Widget _bibliotecaWidget = Biblioteca();
  Widget get bibliotecaWidget => _bibliotecaWidget;

  void setBibliotecaWidget(Widget widget) {
    _bibliotecaWidget = widget;
    if (bibliotecaWidget is Biblioteca) {
      displayFloatingButton = true;
    } else {
      displayFloatingButton = false;
    }
    notifyListeners();
  }

  bool displayFloatingButton = true;

  //--------------------------------------------------------------------------------------------------------------------
  bool buttonPressed = false;

  void updateButtonPressed(List<AnimationController> controllers, {value}) {
    if (value == false) {
      buttonPressed = value;
      reverseAnimation(controllers);
    } else {
      buttonPressed = !buttonPressed;
      if (buttonPressed) {
        playAnimation(controllers);
      } else {
        reverseAnimation(controllers);
      }
    }
    notifyListeners();
  }

  Future<void> playAnimation(List<AnimationController> _controllers) async {
    try {
      await _controllers[0].forward().orCancel;
      await _controllers[1].forward().orCancel;
      await _controllers[2].forward().orCancel;
    } on TickerCanceled {
      // the animation got canceled, probably because we were disposed
    }
  }

  Future<void> reverseAnimation(List<AnimationController> _controllers) async {
    try {
      await _controllers[0].reverse().orCancel;
      await _controllers[1].reverse().orCancel;
      await _controllers[2].reverse().orCancel;
    } on TickerCanceled {
      // the animation got canceled, probably because we were disposed
    }
  }

  //----------------------------------------------------------------------------------------------------------------------

  String formatNumber(int number) {
    return NumberFormat.compactCurrency(decimalDigits: 0, symbol: '')
        .format(number);
  }

  String formatNumber2(int number) {
    return NumberFormat.currency(decimalDigits: 0, symbol: '', locale: 'pt-br')
        .format(number);
  }

  String getDate() {
    DateTime now = DateTime.now();
    return DateFormat('yMMMMd', 'pt_BR').format(now);
  }

  Future<dynamic> checkBook(livro) async {
    final DatabaseService _data = DatabaseService();
    Livro res = await _data.getBookById(livro.id);
    if (res != null) {
      return res.status;
    }
    return null;
  }

  Future<Ebook> checkEbook(String name) async {
    final DatabaseService _data = DatabaseService();
    Ebook res = await _data.getEbookByName(name);
    if (res != null) {
      currentEbook = res;
      notifyListeners();
      return res;
    }
    return null;
  }

  List ultimaQuery = ["", []];
  void setUltimaQuery(String query, List results) {
    ultimaQuery = [query, results];
    notifyListeners();
  }

  Livro currentLivro;
  void setCurrentLivro(Livro livro) {
    currentLivro = livro;
    excludedStatus = [];
    for (var _ in livro.status) {
      excludedStatus.add(false);
    }
    notifyListeners();
  }

  Ebook currentEbook;
  void setCurrentEbook(Ebook ebook) {
    currentEbook = ebook;
    notifyListeners();
  }

  List<bool> excludedStatus = [];
  void setExcludedStatus(int index) {
    excludedStatus[index] = !excludedStatus[index];
    notifyListeners();
  }

  List<bool> excludedStatusE = [];
  void setExcludedStatusE(int index) {
    excludedStatusE[index] = !excludedStatusE[index];
    notifyListeners();
  }

  void updateCurrentLivroStatus(List<Status> listStatus, bool haveNewStatus) {
    print("addCurrentLivroStatus");
    List<Status> newListStatus = [];
    if (haveNewStatus) {
      newListStatus.add(listStatus.last);
      listStatus = listStatus.sublist(0, listStatus.length - 1);
    }
    for (var i = 0; i < listStatus.length; i++) {
      if (!excludedStatus[i]) {
        newListStatus.add(listStatus[i]);
      }
    }

    currentLivro.status = newListStatus;
    excludedStatus = [];
    newListStatus.forEach((element) => excludedStatus.add(false));
    notifyListeners();
  }

  void updateCurrentEbookStatus(List<Status> listStatus, bool haveNewStatus) {
    print("addCurrentEbookStatus");
    List<Status> newListStatus = [];
    if (haveNewStatus) {
      newListStatus.add(listStatus.last);
      listStatus = listStatus.sublist(0, listStatus.length - 1);
    }
    for (var i = 0; i < listStatus.length; i++) {
      if (!excludedStatus[i]) {
        newListStatus.add(listStatus[i]);
      }
    }

    currentEbook.status = newListStatus;
    excludedStatusE = [];
    newListStatus.forEach((element) => excludedStatusE.add(false));
    notifyListeners();
  }
}
