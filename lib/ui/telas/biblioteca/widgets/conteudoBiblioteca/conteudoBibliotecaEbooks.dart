import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weebooks2/_view_models/home_view_model.dart';
import 'package:weebooks2/_view_models/user_view_model.dart';
import 'package:weebooks2/models/ebook.dart';
import 'package:weebooks2/ui/components/ebook/ebookWidget.dart';
import 'package:weebooks2/ui/telas/biblioteca/biblioteca.dart';
import 'package:weebooks2/values/values.dart';

class ConteudoBibliotecaEbooks extends StatefulWidget {
  ConteudoBibliotecaEbooks({@required this.categorias});

  final Map categorias;

  @override
  _ConteudoBibliotecaEbooksState createState() =>
      _ConteudoBibliotecaEbooksState();
}

class _ConteudoBibliotecaEbooksState extends State<ConteudoBibliotecaEbooks> {
  List<List<dynamic>> defaultCategorias = [
    ['Lendo', false],
    ['Quero Ler', false],
    ['Já Li', false],
  ];

  List<List<dynamic>> customCategorias = [];
  List<String> filtros;
  List<String> options = [
    "Recentes",
    "Antigos",
    "Ordem Crescente",
    "Ordem decrescente"
  ];
  String value = "Recentes";

  void updateCategorias(categorias) {
    List<List<dynamic>> cCategorias = [];
    categorias.forEach(
      (key, value) {
        bool add = true;
        for (var item in defaultCategorias) {
          if (item[0] == key) {
            add = false;
            break;
          }
        }
        if (add) {
          List check = [false, -1];
          for (var i = 0; i < customCategorias.length; i++) {
            if (customCategorias[i][0] == key) {
              check = [true, i];
            }
          }
          if (check[0]) {
            cCategorias.add([key, customCategorias[check[1]][1]]);
          } else {
            cCategorias.add([key, false]);
          }
        }
      },
    );
    setState(() {
      customCategorias = cCategorias;
    });
  }

  @override
  void initState() {
    super.initState();
    filtros = [];
    updateCategorias(widget.categorias);
    widget.categorias.forEach(
      (key, value) {
        bool add = true;
        for (var item in defaultCategorias) {
          if (item[0] == key) {
            add = false;
            break;
          }
        }
        if (add) {
          customCategorias.add([key, false]);
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final hModel = Provider.of<HomeViewModel>(context);
    final uModel = Provider.of<UserViewModel>(context);

    updateCategorias(uModel.userCategoriasE);
    List<Ebook> ebooksFiltrados = [];
    if (filtros.isEmpty) {
      ebooksFiltrados = uModel.userEbooks;
    } else {
      for (var ebook in uModel.userEbooks) {
        ebook.status.forEach((element) {
          if (filtros.contains(element.categoria) &&
              !ebooksFiltrados.contains(ebook)) {
            ebooksFiltrados.add(ebook);
          }
        });
      }
    }
    if (value == options[0]) {
      ebooksFiltrados = ebooksFiltrados.reversed.toList();
    } else if (value == options[2]) {
      ebooksFiltrados.sort((a, b) => a.title.compareTo(b.title));
    } else if (value == options[3]) {
      ebooksFiltrados.sort((a, b) => b.title.compareTo(a.title));
    }

    return WillPopScope(
      onWillPop: () {
        hModel.setBibliotecaWidget(Biblioteca());
      },
      child: Column(
        children: [
          Container(
            width: double.infinity,
            margin: EdgeInsets.only(top: 8, bottom: 8),
            height: 25,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: defaultCategorias.length,
              padding: EdgeInsets.symmetric(horizontal: 10),
              separatorBuilder: (context, index) => SizedBox(width: 8),
              itemBuilder: (context, index) => FlatButton(
                onPressed: () {
                  setState(() {
                    defaultCategorias[index][1] = !defaultCategorias[index][1];
                    if (!filtros.contains(defaultCategorias[index][0])) {
                      filtros.add(defaultCategorias[index][0]);
                    } else {
                      filtros.remove(defaultCategorias[index][0]);
                    }
                  });
                },
                padding: EdgeInsets.symmetric(horizontal: 10),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                  side: BorderSide(color: primaryCyan),
                ),
                color: defaultCategorias[index][1]
                    ? secondaryPink
                    : Colors.grey[100],
                child: Text(
                  defaultCategorias[index][0],
                  style: TextStyle(
                    fontSize: 12,
                    color: defaultCategorias[index][1]
                        ? Colors.white
                        : Colors.black,
                  ),
                ),
              ),
            ),
          ),
          Divider(height: 0),
          customCategorias.isNotEmpty
              ? Container(
                  width: double.infinity,
                  margin: EdgeInsets.only(top: 8, bottom: 8),
                  height: 25,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: customCategorias.length,
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    separatorBuilder: (context, index) => SizedBox(width: 8),
                    itemBuilder: (context, index) => FlatButton(
                      onPressed: () {
                        setState(() {
                          customCategorias[index][1] =
                              !customCategorias[index][1];
                          if (!filtros.contains(customCategorias[index][0])) {
                            filtros.add(customCategorias[index][0]);
                          } else {
                            filtros.remove(customCategorias[index][0]);
                          }
                        });
                      },
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                        side: BorderSide(color: primaryCyan),
                      ),
                      color: customCategorias[index][1]
                          ? secondaryPink
                          : Colors.grey[100],
                      child: Text(
                        customCategorias[index][0],
                        style: TextStyle(
                          fontSize: 12,
                          color: customCategorias[index][1]
                              ? Colors.white
                              : Colors.black,
                        ),
                      ),
                    ),
                  ),
                )
              : Container(),
          customCategorias.isEmpty ? Container() : Divider(height: 0),
          Container(
            alignment: Alignment.center,
            width: double.infinity,
            padding: EdgeInsets.symmetric(horizontal: 10),
            child: DropdownButton(
              onChanged: (newValue) {
                setState(() {
                  value = newValue;
                });
              },
              icon: Icon(Icons.keyboard_arrow_down),
              value: value,
              items: List.generate(
                options.length,
                (index) => DropdownMenuItem(
                  value: options[index],
                  child: Container(
                    width: MediaQuery.of(context).size.width - 55,
                    child: Text(
                      options[index],
                      style: TextStyle(
                        color: primaryCyan,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: ebooksFiltrados.isNotEmpty
                ? ListView.separated(
                    shrinkWrap: true,
                    itemCount: ebooksFiltrados.length,
                    separatorBuilder: (context, index) => Divider(
                      color: Colors.grey[400],
                      indent: 20,
                      endIndent: 20,
                      height: 2,
                    ),
                    itemBuilder: (context, index) =>
                        EbookWidget(ebook: ebooksFiltrados[index]),
                  )
                : Center(
                    child: Text("Sem ebooks nesta categoria."),
                  ),
          ),
        ],
      ),
    );
  }
}
