import 'dart:async';

import 'package:flutter/material.dart';
import 'package:weebooks2/services/auth.dart';
import 'package:weebooks2/ui/shared/loading.dart';
import 'package:weebooks2/values/values.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

    Timer(
      Duration(seconds: 4),
      () => Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) {
            return Authenticate();
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: secondaryPink,
      child: Column(
        children: [
          Image.asset(
            "assets/background.webp",
            fit: BoxFit.contain,
            height: 372,
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
                        color: Colors.white,
                        fontSize: 18,
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
            child: Loading(opacity: false),
          ),
        ],
      ),
    );
    // return FutureBuilder<bool>(
    //   future: userModel.getUserData(),
    //   builder: (context, snapshot) {
    //     Widget widget;
    //     if (snapshot.hasData) {
    //       widget = Authenticate();
    //     } else if (snapshot.hasError) {
    //       print('Erro!');
    //     } else {
    //       widget = Scaffold(
    //         body: Container(
    //           color: secondaryPink,
    //           child: Column(
    //             children: [
    //               Image.asset(
    //                 "assets/background.webp",
    //                 fit: BoxFit.contain,
    //                 height: 372,
    //               ),
    //               Expanded(
    //                 flex: 1,
    //                 child: Align(
    //                   alignment: Alignment.bottomCenter,
    //                   child: RichText(
    //                     textAlign: TextAlign.center,
    //                     text: TextSpan(
    //                       children: [
    //                         TextSpan(
    //                           text: "Bem-vindo ao",
    //                           style: TextStyle(
    //                             color: Colors.white,
    //                             fontSize: 18,
    //                           ),
    //                         ),
    //                         TextSpan(
    //                           text: "\nWeeBooks",
    //                           style: TextStyle(
    //                             fontFamily: "Beautiful-Maples",
    //                             color: Colors.white,
    //                             fontSize: 48,
    //                             letterSpacing: 2,
    //                           ),
    //                         ),
    //                       ],
    //                     ),
    //                   ),
    //                 ),
    //               ),
    //               Expanded(
    //                 flex: 2,
    //                 child: Loading(opacity: false),
    //               ),
    //             ],
    //           ),
    //         ),
    //       );
    //     }
    //     return widget;
    //   },
    // );
  }
}
