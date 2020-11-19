import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weebooks2/_view_models/user_view_model.dart';
import 'package:weebooks2/values/values.dart';

class LivroPerfilDropDown extends StatefulWidget {
  LivroPerfilDropDown({@required this.controller});

  final TextEditingController controller;

  @override
  _LivroPerfilDropDownState createState() => _LivroPerfilDropDownState();
}

class _LivroPerfilDropDownState extends State<LivroPerfilDropDown> {
  List<String> defaultOptions = [
    'Nenhum',
    'Possuo',
    'Já Li',
    'Quero Ler',
    'Abandonado',
    'Emprestado',
  ];

  @override
  Widget build(BuildContext context) {
    final uModel = Provider.of<UserViewModel>(context);

    List<String> options = [];
    options.addAll(defaultOptions);
    uModel.userCategorias.forEach((key, value) {
      if (!options.contains(key)) options.add(key);
    });
    options.add('Nova Categoria');

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        color: Colors.grey[100],
      ),
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: DropdownButtonHideUnderline(
        child: DropdownButton(
          onChanged: (newValue) {
            setState(() {
              widget.controller.text = newValue;
            });
          },
          icon: Icon(Icons.keyboard_arrow_down),
          iconSize: 30,
          value: widget.controller.text,
          items: List.generate(
            options.length,
            (index) => DropdownMenuItem(
              value: options[index],
              child: Text(
                options[index],
                style: TextStyle(
                  color: defaultOptions.contains(options[index])
                      ? primaryCyan
                      : secondaryPink,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
