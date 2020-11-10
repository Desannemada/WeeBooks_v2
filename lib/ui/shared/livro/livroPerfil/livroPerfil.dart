import 'package:flutter/material.dart';
import 'package:weebooks2/models/livro.dart';
import 'package:weebooks2/ui/shared/defaultScaffold.dart';

import 'widgets/livroPerfilAddDialog.dart';
import 'widgets/livroPerfilDescricao.dart';
import 'widgets/livroPerfilMainInfo.dart';
import 'widgets/livroStatus.dart';

class LivroPerfil extends StatelessWidget {
  LivroPerfil({@required this.livro});

  final Livro livro;

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width / 2.5;

    return DefaultScaffold(
      actions: [
        IconButton(
          icon: Icon(Icons.add),
          iconSize: 28,
          onPressed: () => showDialog(
            context: context,
            builder: (context) => LivroPerfilAddDialog(livro: livro),
          ),
        )
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
                    livro: livro,
                  ),
                ),
                SizedBox(height: 30),
                LivroPerfilStatus(status: livro.status),
                SizedBox(height: 30),
                LivroPerfilDescricao(descricao: livro.description),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
