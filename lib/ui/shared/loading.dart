import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class Loading extends StatelessWidget {
  Loading({this.opacity = true, this.color = Colors.white, this.size = 50.0});

  final bool opacity;
  final Color color;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black.withOpacity(opacity ? 0.5 : 0.0),
      alignment: Alignment.center,
      child: SpinKitFadingCube(
        color: color,
        size: size,
      ),
    );
  }
}
