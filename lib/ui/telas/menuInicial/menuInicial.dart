import 'package:flutter/material.dart';
import 'package:weebooks2/ui/telas/menuInicial/widgets/botaoMenuInicial.dart';
import 'package:weebooks2/values/values.dart';

class MenuInicial extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: secondaryPink,
        child: Column(
          children: [
            Image.asset(
              "assets/background.webp",
              fit: BoxFit.contain,
            ),
            Expanded(
              flex: 1,
              child: Align(
                alignment: Alignment.bottomCenter,
                child: RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: "Bem-vindo ao",
                        style: TextStyle(
                          fontFamily: "Merriweather",
                          color: Colors.white,
                          fontSize: 16,
                        ),
                      ),
                      TextSpan(
                        text: "\nWeeBooks",
                        style: TextStyle(
                          fontFamily: "Beautiful-Maples",
                          color: Colors.white,
                          fontSize: 48,
                          letterSpacing: 2,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 2,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  BotaoMenuInicial(text: "Entrar", color: primaryCyan, id: 0),
                  SizedBox(height: 20),
                  BotaoMenuInicial(
                      text: "Criar Conta", color: shadeGrey1, id: 1),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
