import 'package:flutter/material.dart';
import 'package:weebooks2/ui/shared/defaultDialog.dart';
import 'package:weebooks2/values/values.dart';

class HomeButtonAnimation extends StatelessWidget {
  HomeButtonAnimation({
    Key key,
    @required this.controller,
    @required this.edgeInsets,
    @required this.title,
    @required this.onPressed,
  })  : width = Tween<double>(
          begin: AppBar().preferredSize.height + 10,
          end: 110,
        ).animate(
          CurvedAnimation(
            parent: controller,
            curve: Interval(
              0.0,
              1.0,
              curve: Curves.ease,
            ),
          ),
        ),
        height = Tween<double>(
          begin: AppBar().preferredSize.height + 10,
          end: 40,
        ).animate(
          CurvedAnimation(
            parent: controller,
            curve: Interval(
              0.0,
              1.0,
              curve: Curves.ease,
            ),
          ),
        ),
        padding = EdgeInsetsTween(
          begin: const EdgeInsets.only(bottom: 0.0, right: 0.0, left: 0.0),
          end: edgeInsets,
        ).animate(
          CurvedAnimation(
            parent: controller,
            curve: Interval(
              0.0,
              1.0,
              curve: Curves.ease,
            ),
          ),
        ),
        shape = ShapeBorderTween(
          begin: CircleBorder(),
          end:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(34.5)),
        ).animate(
          CurvedAnimation(
            parent: controller,
            curve: Interval(
              0.0,
              1.0,
              curve: Curves.ease,
            ),
          ),
        ),
        super(key: key);

  final Animation<double> controller;
  final Animation<double> width;
  final Animation<double> height;
  final Animation<EdgeInsets> padding;
  final Animation<ShapeBorder> shape;
  final EdgeInsets edgeInsets;
  final String title;
  final dynamic onPressed;

  Widget _buildAnimation(BuildContext context, Widget child) {
    bool isDialog = onPressed.runtimeType == DefaultDialog;

    return Container(
      padding: padding.value,
      alignment: Alignment.bottomCenter,
      child: RaisedButton(
        shape: shape.value,
        color: secondaryPink,
        child: Container(
          width: width.value,
          height: height.value,
          alignment: Alignment.center,
          child: Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.white),
          ),
        ),
        onPressed: !isDialog
            ? onPressed
            : () => showDialog(context: context, child: onPressed),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      builder: _buildAnimation,
      animation: controller,
    );
  }
}
