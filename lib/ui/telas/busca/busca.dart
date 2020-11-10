import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:provider/provider.dart';
import 'package:weebooks2/_view_models/user_view_model.dart';
import 'package:weebooks2/models/livro.dart';
import 'package:weebooks2/services/database.dart';
import 'package:weebooks2/ui/shared/livro/livroCover.dart';
import 'package:weebooks2/ui/shared/livro/livroPerfil/livroPerfil.dart';
import 'package:weebooks2/ui/telas/busca/widgets/search.dart';
import 'package:weebooks2/values/icons.dart';
import 'package:weebooks2/values/values.dart';

class Busca extends StatelessWidget {
  final DatabaseService _data = DatabaseService();

  @override
  Widget build(BuildContext context) {
    final uModel = Provider.of<UserViewModel>(context);

    List<Livro> buscas = uModel.buscasRecentes.reversed.toList();

    InputBorder border = OutlineInputBorder(
      borderRadius: BorderRadius.all(
        Radius.circular(30),
      ),
      borderSide: BorderSide(
        color: primaryCyan,
        width: 2,
      ),
    );

    return Container(
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          Expanded(
            child: Container(
              margin: EdgeInsets.only(top: 10, right: 10, left: 10),
              child: Column(
                children: [
                  TextField(
                    readOnly: true,
                    cursorColor: primaryCyan,
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.zero,
                      prefixIcon:
                          Icon(WeeBooks.search, color: Colors.grey[600]),
                      hintText: 'Encontre livros, fics, pessoas e grupos...',
                      hintStyle: TextStyle(color: Colors.grey[600]),
                      enabledBorder: border,
                      focusedBorder: border,
                    ),
                    onTap: () {
                      showSearch(context: context, delegate: Search());
                    },
                  ),
                  uModel.buscasRecentes.isNotEmpty
                      ? Expanded(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Padding(
                                padding: EdgeInsets.only(top: 20, bottom: 10),
                                child: Text(
                                  'Recentes',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              Expanded(
                                child: StaggeredGridView.countBuilder(
                                  padding: EdgeInsets.symmetric(vertical: 15),
                                  crossAxisCount: 3,
                                  itemCount: uModel.buscasRecentes.length,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    return Container(
                                      width: MediaQuery.of(context).size.width /
                                              3 -
                                          20,
                                      child: FlatButton(
                                        color: Colors.grey[200],
                                        padding: EdgeInsets.all(10),
                                        child: Column(
                                          children: [
                                            LivroCover(
                                              type: 1,
                                              coverURL: buscas[index].coverURL,
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                vertical: 10,
                                              ),
                                              child: Text(
                                                buscas[index].title,
                                                textAlign: TextAlign.center,
                                              ),
                                            ),
                                          ],
                                        ),
                                        onPressed: () {
                                          _data
                                              .atualizarBuscasRecentes(
                                                  buscas[index])
                                              .then((value) =>
                                                  uModel.getUserData(type: 4));
                                          Navigator.of(context).push(
                                            MaterialPageRoute(
                                              builder: (context) => LivroPerfil(
                                                livro: buscas[index],
                                              ),
                                            ),
                                          );
                                        },
                                      ),
                                    );
                                  },
                                  staggeredTileBuilder: (int index) =>
                                      new StaggeredTile.fit(1),
                                  mainAxisSpacing: 4.0,
                                  crossAxisSpacing: 4.0,
                                ),
                              ),
                            ],
                          ),
                        )
                      : Expanded(
                          child: Center(
                            child: Text(
                              'Sem buscas recentes...',
                              style: TextStyle(fontSize: 16),
                            ),
                          ),
                        ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
