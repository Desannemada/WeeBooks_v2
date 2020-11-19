import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:weebooks2/models/meta.dart';

class MetaLeituraEditarIndividual extends StatefulWidget {
  MetaLeituraEditarIndividual({
    @required this.controller,
    @required this.controllerDB,
    @required this.title,
    @required this.color,
    @required this.meta,
  });

  final TextEditingController controller;
  final TextEditingController controllerDB;
  final String title;
  final Color color;
  final Meta meta;

  @override
  _MetaLeituraEditarIndividualState createState() =>
      _MetaLeituraEditarIndividualState();
}

class _MetaLeituraEditarIndividualState
    extends State<MetaLeituraEditarIndividual> {
  final List<String> modos = ["minutos", "horas", "páginas", "livros"];

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: 70,
          child: Text(
            widget.title,
            style: TextStyle(fontSize: 18),
          ),
        ),
        Container(
          width: 100,
          height: 40,
          padding: EdgeInsets.symmetric(horizontal: 10),
          child: TextField(
            decoration: InputDecoration(
              contentPadding: EdgeInsets.zero,
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(20),
                ),
                borderSide: BorderSide(
                  color: widget.color,
                  width: 2,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(20),
                ),
                borderSide: BorderSide(
                  color: widget.color,
                  width: 2,
                ),
              ),
            ),
            cursorColor: widget.color,
            keyboardType: TextInputType.number,
            inputFormatters: [WhitelistingTextInputFormatter.digitsOnly],
            controller: widget.controller,
            textAlign: TextAlign.center,
          ),
        ),
        DropdownButton(
          onChanged: (newValue) {
            setState(() {
              widget.controllerDB.text = modos.indexOf(newValue).toString();
            });
          },
          value: modos[int.parse(widget.controllerDB.text)],
          items: List.generate(
            modos.length,
            (index) => DropdownMenuItem(
              value: modos[index],
              child: Text(modos[index]),
            ),
          ),
        ),
      ],
    );
  }
}
