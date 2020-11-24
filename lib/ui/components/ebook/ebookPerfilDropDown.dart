import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weebooks2/_view_models/home_view_model.dart';
import 'package:weebooks2/_view_models/user_view_model.dart';
import 'package:weebooks2/values/values.dart';

class EbookPerfilDropDown extends StatefulWidget {
  EbookPerfilDropDown({@required this.controller});

  final TextEditingController controller;

  @override
  _EbookPerfilDropDownState createState() => _EbookPerfilDropDownState();
}

class _EbookPerfilDropDownState extends State<EbookPerfilDropDown> {
  List<String> defaultOptions = [
    'Nenhum',
    'Lendo',
    'Já Li',
    'Quero Ler',
  ];

  @override
  Widget build(BuildContext context) {
    final uModel = Provider.of<UserViewModel>(context);
    final hModel = Provider.of<HomeViewModel>(context);

    List<String> options = [];

    // options.addAll(defaultOptions);
    for (var dOption in defaultOptions) {
      bool add = true;
      for (var st in hModel.currentEbook.status) {
        if (st.categoria == dOption) {
          add = false;
          break;
        }
      }
      if (add) {
        options.add(dOption);
      }
    }
    uModel.userCategoriasE.forEach((key, value) {
      if (!options.contains(key) && !defaultOptions.contains(key)) {
        options.add(key);
      }
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
