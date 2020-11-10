import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weebooks2/_view_models/user_view_model.dart';
import 'package:weebooks2/ui/shared/defaultButton.dart';

class DefaultMessageDialog extends StatelessWidget {
  DefaultMessageDialog({
    @required this.title,
    @required this.onPressed,
  });

  final String title;
  final Function onPressed;

  @override
  Widget build(BuildContext context) {
    final userModel = Provider.of<UserViewModel>(context);

    return SimpleDialog(
      title: Container(
        padding: EdgeInsets.all(20),
        child: Text(
          title,
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 18, color: Colors.black),
        ),
      ),
      contentPadding: EdgeInsets.zero,
      children: [
        Center(
          child: Padding(
            padding: EdgeInsets.only(bottom: 20),
            child: DefaultButton(
              label: 'OK',
              onPressed: onPressed,
            ),
          ),
        ),
      ],
    );
  }
}
