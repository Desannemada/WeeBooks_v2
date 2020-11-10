import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weebooks2/_view_models/user_view_model.dart';
import 'package:weebooks2/models/livro.dart';
import 'package:weebooks2/services/database.dart';
import 'package:weebooks2/ui/shared/livro/livroCover.dart';
import 'package:weebooks2/values/values.dart';

import 'livroPerfil/livroPerfil.dart';

class LivroWidget extends StatelessWidget {
  LivroWidget({@required this.livro});

  final Livro livro;

  final DatabaseService _data = DatabaseService();

  @override
  Widget build(BuildContext context) {
    final uModel = Provider.of<UserViewModel>(context);

    String authors =
        livro.authors.isEmpty ? INDEFINIDO : livro.authors.join(', ');
    String categorias =
        livro.categories.isEmpty ? INDEFINIDO : livro.categories.join(', ');
    List options = [
      ['Autor: ', authors, authors == INDEFINIDO],
      ['Ano: ', livro.publishedDate, livro.publishedDate == INDEFINIDO],
      ['Editora: ', livro.publisher, livro.publisher == INDEFINIDO],
      ['Categorias: ', categorias, categorias == INDEFINIDO],
    ];

    return Container(
      margin: EdgeInsets.all(10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
      ),
      child: FlatButton(
        onPressed: () {
          // _data.addBook(livro);
          _data
              .atualizarBuscasRecentes(livro)
              .then((value) => uModel.getUserData(type: 4));
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => LivroPerfil(livro: livro),
            ),
          );
        },
        color: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
        padding: EdgeInsets.all(10),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5),
              ),
              child: LivroCover(
                coverURL: livro.coverURL,
                borderRadius: 5,
                boxFit: BoxFit.fitWidth,
              ),
            ),
            SizedBox(width: 20),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    livro.title,
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
                      4,
                      (index) {
                        return Padding(
                          padding: index != 3
                              ? EdgeInsets.only(bottom: 5)
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
      ),
    );
  }
}
