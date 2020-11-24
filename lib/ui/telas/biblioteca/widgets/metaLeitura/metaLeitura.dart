import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:provider/provider.dart';
import 'package:weebooks2/_view_models/home_view_model.dart';
import 'package:weebooks2/_view_models/user_view_model.dart';
import 'package:weebooks2/models/meta.dart';
import 'package:weebooks2/values/values.dart';

class MetaLeitura extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final userModel = Provider.of<UserViewModel>(context);
    final homeModel = Provider.of<HomeViewModel>(context);

    List<Meta> metas = [
      userModel.userMetas.metaDiaria,
      userModel.userMetas.metaMensal,
      userModel.userMetas.metaAnual
    ];
    List<bool> check = [false, false, false];
    if (userModel.userMetas != null) {
      check = [
        userModel.userMetas.metaDiaria.tipo != -1,
        userModel.userMetas.metaMensal.tipo != -1,
        userModel.userMetas.metaAnual.tipo != -1
      ];
    }

    return !ListEquality().equals(check, [false, false, false])
        ? Container(
            height: 220,
            padding: EdgeInsets.only(left: 10, right: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Stack(
                  alignment: Alignment.center,
                  children: [
                    MetaCirculoPercentual(id: 0, meta: metas[0]),
                    MetaCirculoPercentual(id: 1, meta: metas[1]),
                    MetaCirculoPercentual(id: 2, meta: metas[2]),
                  ],
                ),
                Container(
                  height: double.infinity,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: List.generate(
                      3,
                      (index) => MetaInfo(
                        id: index,
                        meta: metas[index],
                      ),
                    ),
                  ),
                ),
              ],
            ))
        : Container(
            alignment: Alignment.centerLeft,
            child: FlatButton.icon(
              icon: Icon(Icons.add, color: Colors.grey[600]),
              label: Text(
                "Criar",
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                ),
              ),
              padding: EdgeInsets.zero,
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              color: Colors.white,
              onPressed: () => showDialog(
                  context: context,
                  child: homeModel.botaoPrincipalOpcoes[0][1][1]),
            ),
          );
  }
}

class MetaInfo extends StatelessWidget {
  MetaInfo({@required this.id, @required this.meta});

  final int id;
  final Meta meta;

  final List config = [
    ["DIÁRIA", accent1],
    ["MENSAL", accent2],
    ["ANUAL", accent3],
  ];

  final double circleSize = 10;
  final List<String> modos = ["minutos", "horas", "páginas", "livros"];
  final TextStyle ts = TextStyle(
      fontFamily: 'Merriweather',
      color: Colors.black,
      fontWeight: FontWeight.bold);

  @override
  Widget build(BuildContext context) {
    final hModel = Provider.of<HomeViewModel>(context);

    return Row(
      children: [
        Container(
          width: circleSize,
          height: circleSize,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: config[id][1],
          ),
        ),
        SizedBox(width: 15),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              config[id][0],
              style: TextStyle(
                fontWeight: FontWeight.w800,
                color: Colors.grey[400],
                fontSize: 14,
                fontFamily: 'Roboto',
              ),
            ),
            SizedBox(height: 2),
            RichText(
              textAlign: TextAlign.start,
              text: TextSpan(
                text: hModel.formatNumber(meta.metaAtual),
                style: ts.copyWith(fontSize: 18),
                children: [
                  TextSpan(
                    text: " / ${hModel.formatNumber(meta.metaDefinida)}",
                    style: ts.copyWith(fontSize: 12, color: Colors.grey[500]),
                  ),
                  TextSpan(
                    text: "\n${modos[meta.tipo]}",
                    style: ts.copyWith(fontSize: 12, color: Colors.grey[700]),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class MetaCirculoPercentual extends StatelessWidget {
  MetaCirculoPercentual({
    @required this.meta,
    @required this.id,
  });

  final Meta meta;
  final int id;

  final List config = [
    [210.0, accent1],
    [160.0, accent2],
    [120.0, accent3],
  ];

  @override
  Widget build(BuildContext context) {
    double percent = meta.metaAtual / meta.metaDefinida;

    return CircularPercentIndicator(
      radius: config[id][0],
      lineWidth: 8.0,
      percent: percent.isNaN || percent == 0
          ? 0.0001
          : percent > 1
              ? 1.0
              : percent,
      backgroundColor: Colors.grey[50],
      circularStrokeCap: CircularStrokeCap.round,
      progressColor: config[id][1],
      reverse: true,
      animation: true,
      animationDuration: 1500,
      animateFromLastPercent: true,
    );
  }
}
