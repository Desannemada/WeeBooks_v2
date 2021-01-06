import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weebooks2/_view_models/home_view_model.dart';
import 'package:weebooks2/_view_models/user_view_model.dart';
import 'package:weebooks2/models/status.dart';
import 'package:intl/intl.dart';
import 'package:weebooks2/services/database.dart';
import 'package:weebooks2/ui/components/livro/livroPerfil/livroPerfilStatus.dart';
import 'package:weebooks2/ui/components/livro/livroPerfilAddDialog/livroPerfilDropDown.dart';
import 'package:weebooks2/ui/components/livro/livroPerfilAddDialog/livroPerfilTextField.dart';
import 'package:weebooks2/ui/shared/defaultButton.dart';
import 'package:weebooks2/ui/shared/defaultMessageDialog.dart';
import 'package:weebooks2/ui/shared/loading.dart';
import 'package:weebooks2/values/values.dart';

class LivroPerfilAddDialog extends StatefulWidget {
  @override
  _LivroPerfilAddDialogState createState() => _LivroPerfilAddDialogState();
}

class _LivroPerfilAddDialogState extends State<LivroPerfilAddDialog> {
  final DatabaseService _data = DatabaseService();

  TextEditingController _novaCategoriaController;
  TextEditingController _emprestadoParaController;
  TextEditingController _controllerDate;
  TextEditingController _controllerDropDown;

  bool isNovaCategoria = false;
  bool isEmprestado = false;
  String data = DateFormat('yMd', 'pt_BR').format(DateTime.now());
  bool isLoading = false;

  reset() {
    setState(() {
      _novaCategoriaController.text = "";
      _emprestadoParaController.text = "";
      _controllerDate.text = data;
      _controllerDropDown.text = "Nenhum";
      isNovaCategoria = false;
      isEmprestado = false;
    });
  }

  @override
  void initState() {
    super.initState();
    _novaCategoriaController = TextEditingController(text: "");
    _emprestadoParaController = TextEditingController(text: "");
    _controllerDate = TextEditingController(text: data);
    _controllerDropDown = TextEditingController(text: "Nenhum");

    _controllerDropDown.addListener(() {
      setState(() {
        isNovaCategoria = _controllerDropDown.text == 'Nova Categoria';
        isEmprestado = _controllerDropDown.text == 'Emprestado';
      });
    });
  }

  @override
  void dispose() {
    _novaCategoriaController.dispose();
    _emprestadoParaController.dispose();
    _controllerDate.dispose();
    _controllerDropDown.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final hModel = Provider.of<HomeViewModel>(context);
    final uModel = Provider.of<UserViewModel>(context);
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Container(
        padding: EdgeInsets.all(20),
        width: double.infinity,
        child: ListView(
          shrinkWrap: true,
          children: [
            Center(
              child: Text(
                'Status',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Divider(height: 20),
            SizedBox(height: 5),
            hModel.currentLivro.status.isNotEmpty
                ? Column(
                    children: [
                      LivroPerfilStatus(type: 1),
                      Divider(height: 30),
                    ],
                  )
                : Container(),
            LivroPerfilDropDown(controller: _controllerDropDown),
            isNovaCategoria
                ? LivroPerfilTextField(
                    controller: _novaCategoriaController,
                    id: 0,
                  )
                : Container(),
            isEmprestado
                ? LivroPerfilTextField(
                    controller: _emprestadoParaController,
                    id: 2,
                  )
                : Container(),
            Divider(height: 20),
            LivroPerfilTextField(
              controller: _controllerDate,
              id: 1,
            ),
            SizedBox(height: 5),
            Divider(height: 20),
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
                  replace: isLoading ? Loading(opacity: false, size: 15) : null,
                  textStyle: TextStyle(color: Colors.white),
                  onPressed: () async {
                    List<Status> listStatus = hModel.currentLivro.status;
                    bool update = false;
                    if (_controllerDropDown.text != "Nenhum") {
                      print("Novo status, updating");
                      update = true;
                      Status status = new Status();
                      status.date = _controllerDate.text;
                      if (isNovaCategoria) {
                        status.title = _novaCategoriaController.text;
                        status.categoria = _novaCategoriaController.text;
                      } else {
                        status.categoria = _controllerDropDown.text;
                        if (isEmprestado &&
                            _emprestadoParaController.text.isNotEmpty) {
                          status.title = _controllerDropDown.text +
                              " para " +
                              _emprestadoParaController.text;
                        } else {
                          status.title = _controllerDropDown.text;
                        }
                      }
                      listStatus.add(status);
                      hModel.updateCurrentLivroStatus(listStatus, true);
                      reset();
                    } else if (hModel.excludedStatus.contains(true)) {
                      print("Sem novo, updating");
                      update = true;
                      hModel.updateCurrentLivroStatus(listStatus, false);
                      reset();
                    }

                    if (update) {
                      setState(() => isLoading = true);
                      await _data.addBook(hModel.currentLivro).then((value) {
                        setState(() => isLoading = false);
                        if (value != null) {
                          showDialog(
                            context: context,
                            builder: (context) => DefaultMessageDialog(
                              title: value
                                  ? "Adicionado com sucesso!"
                                  : "Ocorreu um erro, tente novamente!",
                              onPressed: () {
                                if (!value) {
                                  hModel.currentLivro.status.removeLast();
                                }
                                Navigator.of(context).pop();
                              },
                            ),
                          );
                        }
                      });
                      await uModel.getUserData();
                    }
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
