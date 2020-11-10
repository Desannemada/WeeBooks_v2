import 'package:flutter/material.dart';
import 'package:translator/translator.dart';

class LoginViewModel with ChangeNotifier {
  final translator = GoogleTranslator();

  void fieldFocusChange(
      BuildContext context, FocusNode currentFocus, FocusNode nextFocus) {
    currentFocus.unfocus();
    FocusScope.of(context).requestFocus(nextFocus);
  }

  Future<String> traduzir(String texto) async {
    return (await translator.translate(texto, from: 'en', to: 'pt')).text;
  }
}
