import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:weebooks2/models/livro.dart';
import 'package:weebooks2/ui/shared/defaultDialog.dart';
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
    [
      ["", ""],
      [() {}, () {}]
    ],
    [],
    [
      ["", ""],
      [() {}, () {}]
    ],
    [
      ["", ""],
      [() {}, () {}]
    ]
  ];

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

  List<Livro> recentSearchs = [];
}
