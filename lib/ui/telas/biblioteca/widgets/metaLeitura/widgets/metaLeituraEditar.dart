import 'package:flutter/material.dart';
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
import 'package:weebooks2/ui/telas/biblioteca/widgets/metaLeitura/widgets/metaLeituraEditarIndividual.dart';
import 'package:weebooks2/values/values.dart';

class MetaLeituraEditar extends StatefulWidget {
  @override
  _MetaLeituraEditarState createState() => _MetaLeituraEditarState();
}

class _MetaLeituraEditarState extends State<MetaLeituraEditar> {
  bool start = true;
  TextEditingController _controllerD;
  TextEditingController _controllerM;
  TextEditingController _controllerA;
  TextEditingController _controllerDBD;
  TextEditingController _controllerDBM;
  TextEditingController _controllerDBA;

  @override
  void dispose() {
    _controllerD.dispose();
    _controllerM.dispose();
    _controllerA.dispose();
    _controllerDBD.dispose();
    _controllerDBM.dispose();
    _controllerDBA.dispose();
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
      List<String> tipos = [
        metas[0].tipo == -1 ? '0' : metas[0].tipo.toString(),
        metas[1].tipo == -1 ? '0' : metas[1].tipo.toString(),
        metas[2].tipo == -1 ? '0' : metas[2].tipo.toString(),
      ];
      setState(() {
        _controllerD =
            TextEditingController(text: metas[0].metaDefinida.toString());
        _controllerM =
            TextEditingController(text: metas[1].metaDefinida.toString());
        _controllerA =
            TextEditingController(text: metas[2].metaDefinida.toString());
        _controllerDBD = TextEditingController(text: tipos[0]);
        _controllerDBM = TextEditingController(text: tipos[1]);
        _controllerDBA = TextEditingController(text: tipos[2]);
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
              child: ListView(
                shrinkWrap: true,
                children: [
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        "Editar metas",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                      SizedBox(height: 5),
                      Text(
                        "(Crie ou edite suas metas de leitura)",
                        style: TextStyle(
                          fontSize: 16,
                        ),
                      ),
                      Text(
                        "*troca de tipos resetam suas metas atuais",
                        style: TextStyle(fontSize: 12, color: Colors.grey[500]),
                      ),
                      SizedBox(height: 30),
                      MetaLeituraEditarIndividual(
                        controller: _controllerD,
                        controllerDB: _controllerDBD,
                        title: 'Diária',
                        color: accent1,
                        meta: metas[0],
                      ),
                      SizedBox(height: 10),
                      MetaLeituraEditarIndividual(
                        controller: _controllerM,
                        controllerDB: _controllerDBM,
                        title: 'Mensal',
                        color: accent2,
                        meta: metas[1],
                      ),
                      SizedBox(height: 10),
                      MetaLeituraEditarIndividual(
                        controller: _controllerA,
                        controllerDB: _controllerDBA,
                        title: 'Anual',
                        color: accent3,
                        meta: metas[2],
                      ),
                      SizedBox(height: 30),
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
                                    metaDefinida: int.parse(_controllerD.text),
                                    metaAtual: metas[0].tipo ==
                                            int.parse(_controllerDBD.text)
                                        ? metas[0].metaAtual
                                        : 0,
                                    tipo: int.parse(_controllerDBD.text),
                                  ),
                                  metaMensal: MetaMensal(
                                    metaDefinida: int.parse(_controllerM.text),
                                    metaAtual: metas[1].tipo ==
                                            int.parse(_controllerDBM.text)
                                        ? metas[1].metaAtual
                                        : 0,
                                    tipo: int.parse(_controllerDBM.text),
                                  ),
                                  metaAnual: MetaAnual(
                                    metaDefinida: int.parse(_controllerA.text),
                                    metaAtual: metas[2].tipo ==
                                            int.parse(_controllerDBA.text)
                                        ? metas[2].metaAtual
                                        : 0,
                                    tipo: int.parse(_controllerDBA.text),
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
                                        ? 'Novas metas atualizadas!'
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
