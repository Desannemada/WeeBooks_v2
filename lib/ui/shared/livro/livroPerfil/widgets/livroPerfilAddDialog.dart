import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weebooks2/_view_models/user_view_model.dart';
import 'package:weebooks2/models/livro.dart';
import 'package:weebooks2/models/status.dart';
import 'package:weebooks2/ui/shared/livro/livroPerfil/widgets/livroStatus.dart';
import 'package:weebooks2/values/values.dart';

class LivroPerfilAddDialog extends StatelessWidget {
  LivroPerfilAddDialog({@required this.livro});

  final Livro livro;

  @override
  Widget build(BuildContext context) {
    List<Status> status = livro.status;

    status = [
      Status(
          title: 'Emprestado para Anne',
          date: '14/02/2018',
          categoria: 'Emprestado'),
      Status(title: 'Possuo', date: '15/08/2019', categoria: 'Possuo'),
      Status(title: 'Já Li', date: '15/08/2019', categoria: 'Já Li'),
    ];
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Container(
        padding: EdgeInsets.all(20),
        width: double.infinity,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Center(
              child: Text(
                'Status',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Divider(height: 20),
            status.isNotEmpty
                ? Column(
                    children: [
                      LivroPerfilStatus(status: status, type: 1),
                      Divider(height: 30),
                    ],
                  )
                : Container(),
            LivroPerfilDropDown(),
          ],
        ),
      ),
    );
  }
}

class LivroPerfilDropDown extends StatefulWidget {
  @override
  _LivroPerfilDropDownState createState() => _LivroPerfilDropDownState();
}

class _LivroPerfilDropDownState extends State<LivroPerfilDropDown> {
  List<String> defaultOptions = [
    'Possuo',
    'Já Li',
    'Quero Ler',
    'Abandonado',
    'Emprestado',
  ];
  String currentValue = 'Possuo';

  @override
  Widget build(BuildContext context) {
    final uModel = Provider.of<UserViewModel>(context);

    List<String> options = [];
    options.addAll(defaultOptions);
    options.addAll(
        uModel.userCategorias.where((element) => !options.contains(element)));
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
              currentValue = newValue;
            });
          },
          icon: Icon(Icons.keyboard_arrow_down),
          iconSize: 30,
          value: currentValue,
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
