import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weebooks2/_view_models/user_view_model.dart';
import 'package:weebooks2/services/database.dart';
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
          begin: 60,
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
          begin: 60,
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
        widthB = Tween<double>(begin: 60, end: double.infinity).animate(
          CurvedAnimation(
            parent: controller,
            curve: Interval(
              0.0,
              1.0,
              curve: Curves.ease,
            ),
          ),
        ),
        heightB = Tween<double>(begin: 60, end: double.infinity).animate(
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
          begin: const EdgeInsets.all(5),
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
  final Animation<double> widthB;
  final Animation<double> heightB;
  final Animation<EdgeInsets> padding;
  final Animation<ShapeBorder> shape;
  final EdgeInsets edgeInsets;
  final String title;
  final dynamic onPressed;

  final DatabaseService _data = DatabaseService();

  Widget _buildAnimation(BuildContext context, Widget child) {
    final uModel = Provider.of<UserViewModel>(context);
    bool isDialog = onPressed.runtimeType == DefaultDialog;

    Map<String, Function> methods = {
      'limparRecentes': () async {
        await _data.clearBuscasRecentes();
        await uModel.getUserData();
      }
    };

    return Container(
      padding: padding.value,
      width: widthB.value,
      height: heightB.value,
      child: Align(
        alignment: Alignment.bottomRight,
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
              ? methods[onPressed]
              : () {
                  showDialog(context: context, builder: (context) => onPressed);
                },
        ),
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
