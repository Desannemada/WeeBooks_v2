import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weebooks2/_view_models/home_view_model.dart';
import 'package:weebooks2/_view_models/user_view_model.dart';
import 'package:weebooks2/models/ebook.dart';
import 'package:weebooks2/models/status.dart';
import 'package:weebooks2/services/database.dart';
import 'package:intl/intl.dart';
import 'package:weebooks2/ui/components/ebook/ebookPerfilDropDown.dart';
import 'package:weebooks2/ui/components/livro/livroPerfilAddDialog/livroPerfilTextField.dart';
import 'package:weebooks2/ui/shared/defaultButton.dart';
import 'package:weebooks2/ui/shared/defaultMessageDialog.dart';
import 'package:weebooks2/ui/shared/loading.dart';
import 'package:weebooks2/values/values.dart';

class EbookAddDialog extends StatefulWidget {
  EbookAddDialog({@required this.title, @required this.pageCount});

  final String title;
  final int pageCount;

  @override
  _EbookAddDialogState createState() => _EbookAddDialogState();
}

class _EbookAddDialogState extends State<EbookAddDialog> {
  final DatabaseService _data = DatabaseService();

  TextEditingController _novaCategoriaController;
  TextEditingController _controllerDate;
  TextEditingController _controllerDropDown;

  bool isNovaCategoria = false;
  String data = DateFormat('yMd', 'pt_BR').format(DateTime.now());
  bool isLoading = false;
  bool isAdded = false;

  reset() {
    setState(() {
      _novaCategoriaController.text = "";
      _controllerDate.text = data;
      _controllerDropDown.text = "Nenhum";
      isNovaCategoria = false;
    });
  }

  @override
  void initState() {
    super.initState();
    _novaCategoriaController = TextEditingController(text: "");
    _controllerDate = TextEditingController(text: data);
    _controllerDropDown = TextEditingController(text: "Nenhum");

    _controllerDropDown.addListener(() {
      setState(() {
        isNovaCategoria = _controllerDropDown.text == 'Nova Categoria';
      });
    });
  }

  @override
  void dispose() {
    _novaCategoriaController.dispose();
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
            EbookPerfilDropDown(controller: _controllerDropDown),
            isNovaCategoria
                ? LivroPerfilTextField(
                    controller: _novaCategoriaController,
                    id: 0,
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
                    List<Status> listStatus = hModel.currentEbook.status;
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
                        status.title = _controllerDropDown.text;
                      }
                      listStatus.add(status);
                      hModel.updateCurrentEbookStatus(listStatus, true);
                      reset();
                    } else if (hModel.excludedStatus.contains(true)) {
                      print("Sem novo, updating");
                      update = true;
                      hModel.updateCurrentEbookStatus(listStatus, false);
                      reset();
                    }

                    if (update) {
                      setState(() => isLoading = true);
                      Ebook ebook = hModel.currentEbook;
                      if (ebook.title == null) ebook.title = widget.title;
                      if (ebook.pageCount == null)
                        ebook.pageCount = widget.pageCount;

                      await _data.addEbook(ebook).then((value) {
                        setState(() => isLoading = false);
                        if (value != null) {
                          showDialog(
                            context: context,
                            builder: (context) => DefaultMessageDialog(
                              title: value
                                  ? "Adicionado com sucesso!"
                                  : "Ocorreu um erro, tente novamente!",
                              onPressed: () {
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
