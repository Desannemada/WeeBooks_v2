import 'package:flutter/material.dart';

class DefaultDialog extends StatelessWidget {
  DefaultDialog({@required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return child;
  }
}
