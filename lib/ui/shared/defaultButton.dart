import 'package:flutter/material.dart';

class DefaultButton extends StatelessWidget {
  DefaultButton({
    @required this.label,
    this.textStyle = const TextStyle(),
    this.color = const Color(0xFFE0E0E0),
    this.radius = 5,
    this.onPressed,
    this.replace,
  });

  final String label;
  final TextStyle textStyle;
  final Color color;
  final double radius;
  final Function onPressed;
  final Widget replace;

  final TextStyle defaultTS =
      TextStyle(color: Colors.black, fontFamily: 'Roboto', fontSize: 16);

  @override
  Widget build(BuildContext context) {
    return RaisedButton(
      child: replace == null
          ? Text(label, style: defaultTS.merge(textStyle))
          : replace,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(radius),
      ),
      color: color,
      onPressed: onPressed,
    );
  }
}
