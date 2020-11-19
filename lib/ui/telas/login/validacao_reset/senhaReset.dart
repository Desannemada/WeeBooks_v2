import 'dart:async';

import 'package:flutter/material.dart';
import 'package:weebooks2/services/auth.dart';
import 'package:weebooks2/ui/shared/defaultScaffold.dart';
import 'package:weebooks2/ui/shared/loading.dart';
import 'package:weebooks2/values/values.dart';

class SenhaReset extends StatefulWidget {
  @override
  _SenhaResetState createState() => _SenhaResetState();
}

class _SenhaResetState extends State<SenhaReset> {
  final AuthService _auth = AuthService();
  bool isLoading = false;
  Map message = {'msg': "Enviar email"};

  TextEditingController _controller;
  final FocusNode _emailFocus = new FocusNode();
  Color currentColor = Colors.white;

  @override
  void initState() {
    _controller = new TextEditingController(text: "");
    _emailFocus.addListener(_onFocusChange);
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onFocusChange() {
    setState(() {
      currentColor = _emailFocus.hasFocus ? primaryCyan : Colors.white;
    });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultScaffold(
      backgroundColor: secondaryPink,
      body: Container(
        height: double.infinity,
        width: double.infinity,
        child: ListView(
          shrinkWrap: true,
          children: [
            Container(
              width: double.infinity,
              height: 200,
              color: Colors.red,
              child: Image.asset(
                "assets/background.webp",
                fit: BoxFit.fitWidth,
                alignment: Alignment.bottomCenter,
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 16, horizontal: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    "Resetar senha",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 15),
                  Text(
                    "Digite seu e-mail e lhe enviaremos um link para resetar sua senha.",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                  ),
                  SizedBox(height: 20),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 30),
                    child: TextFormField(
                      controller: _controller,
                      focusNode: _emailFocus,
                      decoration: InputDecoration(
                        prefixIcon: Icon(
                          Icons.person_outline,
                          color: currentColor,
                          size: 28,
                        ),
                        labelText: "Email",
                        labelStyle: TextStyle(
                          color: currentColor,
                          fontSize: 18,
                        ),
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.white,
                          ),
                        ),
                      ),
                      style: TextStyle(
                          height: 1.4, color: Colors.white, fontSize: 18),
                      onFieldSubmitted: (value) {
                        FocusScope.of(context).unfocus();
                      },
                    ),
                  ),
                  SizedBox(height: 30),
                  Container(
                    height: 45,
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(horizontal: 30),
                    child: RaisedButton(
                      color: primaryCyan,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(40),
                      ),
                      child: !isLoading
                          ? Text(
                              message['msg'],
                              style: TextStyle(
                                fontSize: DEFAULT_BUTTON_TEXT_SIZE,
                                color: Colors.white,
                                fontWeight: FontWeight.normal,
                              ),
                            )
                          : Loading(opacity: false, size: 20),
                      onPressed: () async {
                        if (_controller.text.isNotEmpty) {
                          setState(() => isLoading = true);
                          bool res =
                              await _auth.resetPassword(_controller.text);
                          if (res) {
                            setState(() {
                              message['msg'] = "Email enviado!";
                            });
                          } else {
                            setState(() {
                              message['msg'] = "Ocorreu um erro :(";
                            });
                          }
                          setState(() => isLoading = false);
                          Timer(Duration(seconds: 3), () {
                            setState(() {
                              message['msg'] = "Enviar novamente";
                            });
                          });
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// isPressed
//                       ? Container(
//                           alignment: Alignment.center,
//                           child: !isLoading
//                               ? Container(
//                                   margin: EdgeInsets.only(
//                                       bottom: 30, left: 30, right: 30),
//                                   padding: EdgeInsets.all(8),
//                                   decoration: BoxDecoration(
//                                     color: Colors.white,
//                                     borderRadius: BorderRadius.circular(7),
//                                   ),
//                                   child: Text(
//                                     message['msg'],
//                                     textAlign: TextAlign.justify,
//                                     style: TextStyle(
//                                       color: message['color'],
//                                       fontSize: 14,
//                                     ),
//                                   ),
//                                 )
//                               : Loading(
//                                   opacity: false,
//                                 ),
//                         )
//                       : Container(),
