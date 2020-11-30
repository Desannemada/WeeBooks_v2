import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weebooks2/_view_models/home_view_model.dart';
import 'package:weebooks2/ui/shared/Logo.dart';

class DefaultScaffold extends StatelessWidget {
  DefaultScaffold({
    this.titulo,
    @required this.body,
    this.backgroundColor,
    this.actions,
    this.bottomNavigationBar,
    this.leading = false,
    this.floatingActionButton,
    this.leadingWidget,
  });

  final String titulo;
  final Widget body;
  final Color backgroundColor;
  final List<Widget> actions;
  final Widget bottomNavigationBar;
  final bool leading;
  final Widget floatingActionButton;
  final Widget leadingWidget;

  @override
  Widget build(BuildContext context) {
    final hModel = Provider.of<HomeViewModel>(context);
    return Scaffold(
      backgroundColor: backgroundColor != null ? backgroundColor : Colors.white,
      // resizeToAvoidBottomPadding: false,
      appBar: AppBar(
        leading: leading
            ? IconButton(
                icon: Icon(Icons.arrow_back),
                onPressed: () => leadingWidget == null
                    ? Navigator.of(context).pop()
                    : hModel.setBibliotecaWidget(leadingWidget),
              )
            : null,
        centerTitle: true,
        title: titulo != null
            ? Text(
                titulo,
                style: TextStyle(fontSize: 18),
              )
            : Logo(fontSize: 30),
        actions: actions,
      ),
      body: body,
      bottomNavigationBar: bottomNavigationBar,
      floatingActionButton: floatingActionButton,
    );
  }
}
