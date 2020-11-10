import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';

class SignInValidationItem {
  final String value;
  final String error;

  SignInValidationItem(this.value, this.error);
}

class SignInValidationModel with ChangeNotifier {
  List<SignInValidationItem> _sivi = [
    SignInValidationItem(null, null),
    SignInValidationItem(null, null),
  ];

  //Getter
  List<SignInValidationItem> get sivi => _sivi;
  bool get isValid {
    for (var i = 0; i < _sivi.length; i++) {
      if (_sivi[i].value == null) {
        _sivi[i] = SignInValidationItem(null, "Campo vazio");
      }
    }
    notifyListeners();
    if (_sivi[0].value != null && _sivi[1].value != null) {
      print("Login validado!");
      return true;
    } else {
      print("Login não validado!");
      return false;
    }
  }

  //Setter
  void updateItem(String value, int index) {
    if (value == "") {
      sivi[index] = SignInValidationItem(null, "Campo vazio");
    } else {
      switch (index) {
        case 0:
          {
            if (EmailValidator.validate(value)) {
              sivi[0] = SignInValidationItem(value, null);
            } else {
              sivi[0] = SignInValidationItem(null, "Formato inválido");
            }
          }
          break;
        case 1:
          {
            if (value != "") {
              sivi[1] = SignInValidationItem(value, null);
            }
          }
          break;
      }
    }

    notifyListeners();
  }

  //Clean
  void cleanValidation() {
    _sivi = [
      SignInValidationItem(null, null),
      SignInValidationItem(null, null),
    ];
    notifyListeners();
  }
}
