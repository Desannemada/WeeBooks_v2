import 'package:flutter/material.dart';
import 'package:weebooks2/values/values.dart';
import 'package:intl/intl.dart';

class LivroPerfilTextField extends StatefulWidget {
  LivroPerfilTextField({
    @required TextEditingController controller,
    @required this.id,
  }) : _controller = controller;

  final TextEditingController _controller;
  final int id;

  @override
  _LivroPerfilTextFieldState createState() => _LivroPerfilTextFieldState();
}

class _LivroPerfilTextFieldState extends State<LivroPerfilTextField> {
  final InputBorder ib = OutlineInputBorder(
    borderRadius: BorderRadius.all(
      Radius.circular(5),
    ),
    borderSide: BorderSide(color: Colors.grey[100]),
  );

  @override
  Widget build(BuildContext context) {
    List options = [
      [
        EdgeInsets.only(top: 15),
        false,
        TextAlign.start,
        'Inserir Categoria',
        false,
        false
      ],
      [EdgeInsets.zero, true, TextAlign.center, '', true, true],
      [
        EdgeInsets.only(top: 15),
        false,
        TextAlign.start,
        'Para quem',
        false,
        false
      ],
    ];

    return Padding(
      padding: options[widget.id][0],
      child: TextField(
        controller: widget._controller,
        cursorColor: primaryCyan,
        style: TextStyle(height: 1.5, fontSize: 17),
        readOnly: options[widget.id][1],
        textAlign: options[widget.id][2],
        decoration: InputDecoration(
          contentPadding: EdgeInsets.symmetric(horizontal: 20),
          enabledBorder: ib,
          focusedBorder: ib,
          fillColor: Colors.grey[100],
          filled: true,
          hintText: options[widget.id][3],
          hintStyle: TextStyle(color: Colors.grey[400]),
          prefix: options[widget.id][4]
              ? Text(
                  'Data: ',
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                )
              : null,
          suffixIcon: options[widget.id][5]
              ? IconButton(
                  icon: Icon(Icons.date_range, color: primaryCyan),
                  onPressed: () async {
                    DateTime now = DateTime.now();
                    DateTime data = await showDatePicker(
                      context: context,
                      initialDate: now,
                      firstDate: DateTime(now.year - 80),
                      lastDate: DateTime(now.year + 10),
                      builder: (context, child) {
                        return Theme(
                          data: ThemeData.light().copyWith(
                            colorScheme:
                                ColorScheme.light(primary: primaryCyan),
                            buttonTheme: ButtonThemeData(
                              textTheme: ButtonTextTheme.primary,
                            ),
                          ),
                          child: child,
                        );
                      },
                    );
                    if (data != null) {
                      setState(() {
                        widget._controller.text =
                            DateFormat('yMd', 'pt_BR').format(data);
                      });
                    }
                  },
                )
              : null,
        ),
      ),
    );
  }
}
