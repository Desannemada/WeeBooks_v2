import 'package:flutter/material.dart';
import 'package:weebooks2/ui/shared/Logo.dart';
import 'package:weebooks2/values/values.dart';

class DefaultScaffold extends StatelessWidget {
  DefaultScaffold({
    this.titulo,
    @required this.body,
    this.backgroundColor,
    this.actions,
    this.bottomNavigationBar,
    this.leading = false,
    this.floatingActionButton,
  });

  final String titulo;
  final Widget body;
  final Color backgroundColor;
  final List<Widget> actions;
  final Widget bottomNavigationBar;
  final bool leading;
  final Widget floatingActionButton;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor != null ? backgroundColor : Colors.white,
      appBar: AppBar(
        leading: leading
            ? IconButton(
                icon: Icon(Icons.arrow_back),
                onPressed: () => Navigator.of(context).pop(),
              )
            : null,
        centerTitle: true,
        title: Logo(fontSize: 30),
        actions: actions,
      ),
      body: body,
      bottomNavigationBar: bottomNavigationBar,
      floatingActionButton: floatingActionButton,
    );
  }
}
