import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weebooks2/_view_models/sign_in_validation_model.dart';
import 'package:weebooks2/_view_models/sign_up_validation_model.dart';
import 'package:weebooks2/ui/telas/login/signIn.dart';
import 'package:weebooks2/ui/telas/login/signUp.dart';
import 'package:weebooks2/values/values.dart';

class BotaoMenuInicial extends StatelessWidget {
  const BotaoMenuInicial({
    @required this.text,
    @required this.color,
    @required this.id,
  });

  final String text;
  final int id;
  final Color color;

  @override
  Widget build(BuildContext context) {
    var sivmodel = Provider.of<SignInValidationModel>(context);
    var suvmodel = Provider.of<SignUpValidationModel>(context);

    return Container(
      height: 50,
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 30),
      child: RaisedButton(
        color: color,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(40),
        ),
        child: Text(
          text,
          style: TextStyle(
            fontSize: DEFAULT_BUTTON_TEXT_SIZE,
            color: Colors.white,
            fontWeight: FontWeight.normal,
          ),
        ),
        onPressed: () {
          if (id == 0) {
            sivmodel.cleanValidation();
          } else {
            suvmodel.cleanValidation();
          }
          return Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => id == 0 ? SignIn() : SignUp(),
            ),
          );
        },
      ),
    );
  }
}
