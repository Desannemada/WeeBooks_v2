import 'package:flutter/material.dart';

class LivroPerfilDescricao extends StatefulWidget {
  const LivroPerfilDescricao({
    Key key,
    @required this.descricao,
  }) : super(key: key);

  final String descricao;

  @override
  _LivroPerfilDescricaoState createState() => _LivroPerfilDescricaoState();
}

class _LivroPerfilDescricaoState extends State<LivroPerfilDescricao> {
  bool showDescricao = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Descrição',
          style: TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 15),
        Text(
          widget.descricao,
          maxLines: showDescricao ? null : 5,
          overflow: TextOverflow.fade,
          textAlign: TextAlign.justify,
          style: TextStyle(
            color: Colors.grey[600],
            height: 1.5,
          ),
        ),
        FlatButton(
          onPressed: () => setState(() => showDescricao = !showDescricao),
          color: Colors.grey[100],
          padding: EdgeInsets.zero,
          child: Center(
            child: Text(
              showDescricao ? 'Esconder' : 'Mostrar',
              style: TextStyle(color: Colors.grey[800]),
            ),
          ),
        )
      ],
    );
  }
}
