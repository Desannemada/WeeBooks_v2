import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weebooks2/_view_models/home_view_model.dart';
import 'package:weebooks2/_view_models/user_view_model.dart';
import 'package:weebooks2/models/livro.dart';
import 'package:weebooks2/models/status.dart';
import 'package:weebooks2/services/database.dart';
import 'package:weebooks2/ui/components/livro/livroPerfil/livroCover.dart';
import 'package:weebooks2/ui/shared/loading.dart';
import 'package:weebooks2/values/values.dart';

import 'livroPerfil.dart';

class LivroWidget extends StatefulWidget {
  LivroWidget({@required this.livro, this.showStatus = false});

  final Livro livro;
  final bool showStatus;

  @override
  _LivroWidgetState createState() => _LivroWidgetState();
}

class _LivroWidgetState extends State<LivroWidget> {
  final DatabaseService _data = DatabaseService();

  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    final uModel = Provider.of<UserViewModel>(context);
    final hModel = Provider.of<HomeViewModel>(context);

    String authors = widget.livro.authors.isEmpty
        ? INDEFINIDO
        : widget.livro.authors.join(', ');
    String categorias = widget.livro.categories.isEmpty
        ? INDEFINIDO
        : widget.livro.categories.join(', ');
    List options = [
      ['Autor: ', authors, authors == INDEFINIDO],
      [
        'Ano: ',
        widget.livro.publishedDate,
        widget.livro.publishedDate == INDEFINIDO
      ],
      [
        'Editora: ',
        widget.livro.publisher,
        widget.livro.publisher == INDEFINIDO
      ],
      ['Categorias: ', categorias, categorias == INDEFINIDO],
      // ['Páginas: ', widget.livro.pageCount.toString(), false],
    ];

    return Stack(
      alignment: Alignment.center,
      children: [
        Container(
          margin: widget.showStatus
              ? EdgeInsets.only(right: 10, left: 10, bottom: 10)
              : EdgeInsets.all(10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
          ),
          child: FlatButton(
            onPressed: () async {
              setState(() => isLoading = true);
              List<Status> res = await hModel.checkBook(widget.livro);
              if (res != null) {
                widget.livro.status = res;
              } else {
                widget.livro.status = [];
              }
              hModel.setCurrentLivro(widget.livro);
              if (!widget.showStatus) {
                _data
                    .atualizarBuscasRecentes(widget.livro)
                    .then((value) => uModel.getUserData(type: 4));
              }
              setState(() => isLoading = false);
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => LivroPerfil(),
                ),
              );
            },
            color: Colors.white,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
            padding: EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      children: [
                        Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: LivroCover(
                            coverURL: widget.livro.coverURL,
                            borderRadius: 5,
                            boxFit: BoxFit.fitWidth,
                          ),
                        ),
                        SizedBox(height: 3),
                        Text(widget.livro.pageCount.toString() + " páginas")
                      ],
                    ),
                    SizedBox(width: 20),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            widget.livro.title,
                            softWrap: true,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                          SizedBox(height: 10),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: List.generate(
                              options.length,
                              (index) {
                                return Padding(
                                  padding: index != 4
                                      ? EdgeInsets.only(bottom: 8)
                                      : EdgeInsets.all(0.0),
                                  child: RichText(
                                    text: TextSpan(
                                      style: TextStyle(
                                        fontFamily: 'Merriweather',
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold,
                                      ),
                                      text: options[index][0],
                                      children: [
                                        TextSpan(
                                          style: TextStyle(
                                            fontWeight: FontWeight.normal,
                                            color: options[index][2]
                                                ? Colors.grey
                                                : Colors.black,
                                          ),
                                          text: options[index][1],
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                !widget.showStatus
                    ? Container()
                    : Padding(
                        padding: const EdgeInsets.only(top: 8),
                        child: Wrap(
                          runSpacing: 8,
                          spacing: 8,
                          children: List.generate(
                            widget.livro.status.length,
                            (index) => Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(30),
                                color: Colors.grey[100],
                              ),
                              padding: EdgeInsets.symmetric(
                                  vertical: 3, horizontal: 10),
                              child: Wrap(
                                crossAxisAlignment: WrapCrossAlignment.center,
                                spacing: 5,
                                children: [
                                  Text(
                                    widget.livro.status[index].title,
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12,
                                    ),
                                  ),
                                  Text(
                                    widget.livro.status[index].date,
                                    style: TextStyle(
                                      color: Colors.grey[600],
                                      fontSize: 11,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: 'Roboto',
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      )
              ],
            ),
          ),
        ),
        isLoading
            ? Loading(
                opacity: false,
                color: primaryCyan,
              )
            : Container(),
      ],
    );
  }
}
