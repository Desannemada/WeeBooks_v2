import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:weebooks2/_view_models/home_view_model.dart';
import 'package:weebooks2/_view_models/user_view_model.dart';
import 'package:weebooks2/models/meta.dart';
import 'package:weebooks2/services/auth.dart';
import 'package:weebooks2/services/database.dart';
import 'package:weebooks2/ui/shared/defaultButton.dart';
import 'package:weebooks2/ui/shared/defaultDialog.dart';
import 'package:weebooks2/ui/shared/defaultMessageDialog.dart';
import 'package:weebooks2/ui/shared/loading.dart';
import 'package:weebooks2/values/values.dart';

class MetaLeituraAtualizar extends StatefulWidget {
  @override
  _MetaLeituraAtualizarState createState() => _MetaLeituraAtualizarState();
}

class _MetaLeituraAtualizarState extends State<MetaLeituraAtualizar> {
  bool start = true;
  TextEditingController _controllerD;
  TextEditingController _controllerM;
  TextEditingController _controllerA;

  @override
  void dispose() {
    _controllerD.dispose();
    _controllerM.dispose();
    _controllerA.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final userModel = Provider.of<UserViewModel>(context);
    final homeModel = Provider.of<HomeViewModel>(context);
    final DatabaseService _data = DatabaseService();

    List<Meta> metas = [
      userModel.userMetas.metaDiaria,
      userModel.userMetas.metaMensal,
      userModel.userMetas.metaAnual
    ];

    if (start) {
      setState(() {
        _controllerD =
            TextEditingController(text: metas[0].metaAtual.toString());
        _controllerM =
            TextEditingController(text: metas[1].metaAtual.toString());
        _controllerA =
            TextEditingController(text: metas[2].metaAtual.toString());
        start = false;
      });
    }

    bool loading = false;

    return DefaultDialog(
      child: Stack(
        children: [
          Dialog(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            child: Container(
              padding: EdgeInsets.all(20),
              width: double.infinity,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    "Minhas metas",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  Text(
                    "(${homeModel.getDate()})",
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  ),
                  SizedBox(height: 20),
                  Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(bottom: 10),
                        child: MetaLeituraAtualizarIndividual(
                          controller: _controllerD,
                          title: 'Hoje',
                          color: accent1,
                          meta: metas[0],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: MetaLeituraAtualizarIndividual(
                          controller: _controllerM,
                          title: 'Este mês',
                          color: accent2,
                          meta: metas[1],
                        ),
                      ),
                      SizedBox(height: 10),
                      MetaLeituraAtualizarIndividual(
                        controller: _controllerA,
                        title: 'Este ano',
                        color: accent3,
                        meta: metas[2],
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      DefaultButton(
                        label: 'Voltar',
                        onPressed: () => Navigator.of(context).pop(),
                      ),
                      DefaultButton(
                        label: 'Confirmar',
                        color: primaryCyan,
                        textStyle: TextStyle(color: Colors.white),
                        onPressed: () async {
                          FocusScope.of(context).unfocus();
                          setState(() => loading = true);
                          _controllerD.text = _controllerD.text.isEmpty
                              ? '0'
                              : _controllerD.text;
                          _controllerM.text = _controllerM.text.isEmpty
                              ? '0'
                              : _controllerM.text;
                          _controllerA.text = _controllerA.text.isEmpty
                              ? '0'
                              : _controllerA.text;

                          bool res;
                          res = await _data.atualizarMeta(
                            Metas(
                              metaDiaria: MetaDiaria(
                                metaAtual: int.parse(_controllerD.text),
                              ),
                              metaMensal: MetaMensal(
                                metaAtual: int.parse(_controllerM.text),
                              ),
                              metaAnual: MetaAnual(
                                metaAtual: int.parse(_controllerA.text),
                              ),
                            ),
                          );
                          if (res != null) {
                            setState(() => loading = false);
                            Navigator.of(context).pop();
                            showDialog(
                              context: context,
                              builder: (context) => DefaultMessageDialog(
                                title: res
                                    ? 'Metas Atualizadas!'
                                    : 'Ocorreu um erro, tente novamente em alguns instantes!',
                                onPressed: () {
                                  homeModel.updateButtonPressed(
                                      homeKey.currentState.controllers,
                                      value: false);
                                  Navigator.of(context).pop();
                                  if (res) {
                                    userModel.getUserData(type: 3);
                                  }
                                },
                              ),
                            );
                          }
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          loading ? Loading(opacity: true) : Container()
        ],
      ),
    );
  }
}

class MetaLeituraAtualizarIndividual extends StatelessWidget {
  MetaLeituraAtualizarIndividual({
    @required this.controller,
    @required this.title,
    @required this.color,
    @required this.meta,
  });

  final TextEditingController controller;
  final String title;
  final Color color;
  final Meta meta;

  final List<String> modos = ["minutos", "horas", "páginas", "livros"];

  @override
  Widget build(BuildContext context) {
    return meta.tipo == -1
        ? Text("Sem meta para: " + title)
        : Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 80,
                child: Text(
                  title,
                  style: TextStyle(fontSize: 18),
                ),
              ),
              Container(
                width: 100,
                height: 40,
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: TextField(
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.zero,
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(20),
                      ),
                      borderSide: BorderSide(
                        color: color,
                        width: 2,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(20),
                      ),
                      borderSide: BorderSide(
                        color: color,
                        width: 2,
                      ),
                    ),
                  ),
                  cursorColor: color,
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  controller: controller,
                  textAlign: TextAlign.center,
                ),
              ),
              Container(
                width: 60,
                child: Text(modos[meta.tipo]),
              )
            ],
          );
  }
}
