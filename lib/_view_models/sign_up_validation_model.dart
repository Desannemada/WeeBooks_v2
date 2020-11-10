import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';

class SignUpValidationItem {
  final String value;
  final String error;

  SignUpValidationItem(this.value, this.error);
}

class SignUpValidationModel with ChangeNotifier {
  List<SignUpValidationItem> _suvi = [
    SignUpValidationItem(null, null),
    SignUpValidationItem(null, null),
    SignUpValidationItem(null, null),
    SignUpValidationItem(null, null),
  ];

  //Getter
  List<SignUpValidationItem> get suvi => _suvi;
  bool get isValid {
    for (var i = 0; i < _suvi.length; i++) {
      if (_suvi[i].value == null) {
        _suvi[i] = SignUpValidationItem(null, "Campo vazio");
      }
    }
    notifyListeners();

    if (_suvi[0].value != null &&
        _suvi[1].value != null &&
        _suvi[2].value != null &&
        _suvi[3].value != null) {
      print("Cadastro validado!");
      return true;
    } else {
      print("Cadastro não validado!");
      return false;
    }
  }

  //validate password
  // bool validarSenha(String senha) {
  //   String formato =
  //       r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$';
  //   RegExp regExp = new RegExp(formato);
  //   return regExp.hasMatch(senha);
  // }

  //Setter
  void updateItem(String value, int index) {
    if (value == "") {
      suvi[index] = SignUpValidationItem(null, "Campo vazio");
    } else {
      switch (index) {
        case 0:
          {
            if (EmailValidator.validate(value)) {
              suvi[0] = SignUpValidationItem(value, null);
            } else {
              suvi[0] = SignUpValidationItem(null, "Formato inválido");
            }
          }
          break;
        case 1:
          {
            suvi[1] = SignUpValidationItem(value, null);
          }
          break;
        case 2:
          {
            if (value.length < 8) {
              suvi[2] = SignUpValidationItem(null, "Mínimo de 8 caracteres");
            } else if (!value.contains(new RegExp(r'[A-Z]'))) {
              suvi[2] = SignUpValidationItem(
                  null, "A senha deve conter ao menos uma letra maiúscula");
            } else if (!value.contains(new RegExp(r'[0-9]'))) {
              suvi[2] = SignUpValidationItem(
                  null, "A senha deve conter ao menos um número");
            } else if (!value.contains(new RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) {
              suvi[2] = SignUpValidationItem(
                  null, "A senha deve conter ao menos um caractere especial");
            } else if (!value.contains(new RegExp(r'[a-z]'))) {
              suvi[2] = SignUpValidationItem(
                  null, "A senha deve conter ao menos uma letra minúscula");
            } else {
              suvi[2] = SignUpValidationItem(value, null);
            }
          }
          break;
        case 3:
          {
            if (value == suvi[2].value) {
              suvi[3] = SignUpValidationItem(value, null);
            } else {
              suvi[3] =
                  SignUpValidationItem(null, "As senhas não correspondem");
            }
          }
          break;
      }
    }

    notifyListeners();
  }

  //Clean
  void cleanValidation() {
    _suvi = [
      SignUpValidationItem(null, null),
      SignUpValidationItem(null, null),
      SignUpValidationItem(null, null),
      SignUpValidationItem(null, null),
    ];
    notifyListeners();
  }
}
