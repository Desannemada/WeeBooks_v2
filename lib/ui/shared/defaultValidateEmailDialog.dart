import 'package:flutter/material.dart';
import 'package:weebooks2/services/auth.dart';
import 'package:weebooks2/ui/shared/defaultButton.dart';
import 'package:weebooks2/ui/shared/defaultMessageDialog.dart';
import 'package:weebooks2/ui/shared/loading.dart';
import 'package:weebooks2/values/values.dart';

class DefaultValidateEmailDialog extends StatefulWidget {
  DefaultValidateEmailDialog({
    @required this.title,
    @required this.onPressed,
  });

  final String title;
  final Function onPressed;

  @override
  _DefaultValidateEmailDialogState createState() =>
      _DefaultValidateEmailDialogState();
}

class _DefaultValidateEmailDialogState
    extends State<DefaultValidateEmailDialog> {
  final AuthService _auth = AuthService();

  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SimpleDialog(
          title: Container(
            padding: EdgeInsets.all(15),
            child: Text(
              widget.title,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 18, color: Colors.black),
            ),
          ),
          contentPadding: EdgeInsets.zero,
          children: [
            Padding(
              padding: EdgeInsets.only(bottom: 10, right: 20, left: 20),
              child: DefaultButton(
                color: primaryCyan,
                textStyle: TextStyle(color: Colors.white),
                label: 'Enviar email',
                onPressed: () async {
                  setState(() => isLoading = true);
                  bool res = await _auth.sendEmailVerification();
                  String message;
                  if (res) {
                    message = "Email enviado!";
                  } else {
                    message = "Ocorreu um erro, tente novamente mais tarde!";
                  }
                  setState(() => isLoading = false);
                  showDialog(
                    context: context,
                    builder: (context) => DefaultMessageDialog(
                      title: message,
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                  );
                },
              ),
            ),
            Padding(
              padding: EdgeInsets.only(bottom: 20, right: 20, left: 20),
              child: DefaultButton(
                label: 'OK',
                onPressed: widget.onPressed,
              ),
            ),
          ],
        ),
        isLoading
            ? Loading(
                size: 40,
              )
            : Container()
      ],
    );
  }
}
