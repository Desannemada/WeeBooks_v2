import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weebooks2/_view_models/login_model.dart';
import 'package:weebooks2/_view_models/sign_in_validation_model.dart';
import 'package:weebooks2/_view_models/sign_up_validation_model.dart';
import 'package:weebooks2/values/values.dart';

class TemplateTextField extends StatefulWidget {
  TemplateTextField({
    @required this.id,
    @required this.titulo,
    @required this.icon,
    @required this.controller,
    @required this.focusNode,
  });

  final int id;
  final String titulo;
  final IconData icon;
  final TextEditingController controller;
  final List<FocusNode> focusNode;

  @override
  _TemplateTextFieldState createState() => _TemplateTextFieldState();
}

class _TemplateTextFieldState extends State<TemplateTextField> {
  Color currentColor = Colors.white;

  @override
  void initState() {
    super.initState();
    widget.focusNode[0].addListener(_onFocusChange);
  }

  void _onFocusChange() {
    setState(() {
      currentColor = widget.focusNode[0].hasFocus ? primaryCyan : Colors.white;
    });
  }

  @override
  Widget build(BuildContext context) {
    var menuViewModel = Provider.of<LoginViewModel>(context);
    var sivmodel = Provider.of<SignInValidationModel>(context);
    var sovmodel = Provider.of<SignUpValidationModel>(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        TextFormField(
          controller: widget.controller,
          focusNode: widget.focusNode[0],
          decoration: InputDecoration(
            prefixIcon: Icon(
              widget.icon,
              color: currentColor,
              size: 30,
            ),
            labelText: widget.titulo,
            errorText: widget.id < 2
                ? sivmodel.sivi[widget.id].error
                : sovmodel.suvi[widget.id - 2].error,
            labelStyle: TextStyle(
              color: currentColor,
              fontSize: 20,
            ),
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(
                color: Colors.white,
              ),
            ),
          ),
          style: TextStyle(height: 1.5, color: Colors.white, fontSize: 20),
          obscureText: ["Senha", "Confirmar Senha"].contains(widget.titulo)
              ? true
              : false,
          onChanged: (String value) => widget.id < 2
              ? sivmodel.updateItem(value, widget.id)
              : sovmodel.updateItem(value, widget.id - 2),
          onFieldSubmitted: (value) {
            if (widget.focusNode[1] != null) {
              menuViewModel.fieldFocusChange(
                  context, widget.focusNode[0], widget.focusNode[1]);
            } else {
              FocusScope.of(context).unfocus();
            }
          },
        ),
      ],
    );
  }
}
