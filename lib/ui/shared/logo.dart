import 'package:flutter/material.dart';
import 'package:weebooks2/values/values.dart';

class Logo extends StatelessWidget {
  Logo({
    @required this.fontSize,
  });

  final double fontSize;

  @override
  Widget build(BuildContext context) {
    return Text(
      "WeeBooks",
      style: TextStyle(
        color: Colors.white,
        fontSize: fontSize,
        fontFamily: WEEBOOKS_LOGO_FONT,
      ),
    );
  }
}
