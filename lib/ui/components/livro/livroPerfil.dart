import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weebooks2/_view_models/home_view_model.dart';
import 'package:weebooks2/ui/components/livro/livroPerfil/livroPerfilStatus.dart';
import 'package:weebooks2/ui/components/livro/livroPerfil/livroPerfilDescricao.dart';
import 'package:weebooks2/ui/components/livro/livroPerfil/livroPerfilMainInfo.dart';
import 'package:weebooks2/ui/shared/defaultScaffold.dart';

import 'livroPerfilAddDialog.dart';

class LivroPerfil extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final hModel = Provider.of<HomeViewModel>(context);
    double width = MediaQuery.of(context).size.width / 2.5;

    return DefaultScaffold(
      actions: [
        IconButton(
            icon: Icon(Icons.add),
            iconSize: 28,
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => LivroPerfilAddDialog(),
              );
            })
      ],
      body: ListView(
        shrinkWrap: true,
        children: [
          Container(
            margin: EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: width + 100,
                  child: LivroPerfilMainInfo(
                    width: width,
                    livro: hModel.currentLivro,
                  ),
                ),
                SizedBox(height: 30),
                LivroPerfilStatus(),
                SizedBox(height: 30),
                LivroPerfilDescricao(
                  descricao: hModel.currentLivro.description ?? "",
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
