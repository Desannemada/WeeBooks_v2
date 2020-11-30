import 'dart:async';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weebooks2/_view_models/home_view_model.dart';
import 'package:weebooks2/_view_models/user_view_model.dart';
import 'package:weebooks2/models/ebook.dart';
import 'package:weebooks2/models/user.dart';
import 'package:path/path.dart' as path;

import 'package:weebooks2/services/auth.dart';
import 'package:weebooks2/ui/components/ebook/ebookViewer.dart';
import 'package:weebooks2/ui/shared/defaultButton.dart';
import 'package:weebooks2/ui/shared/defaultMessageDialog.dart';
import 'package:weebooks2/ui/shared/defaultScaffold.dart';
import 'package:weebooks2/ui/shared/loading.dart';
import 'package:weebooks2/ui/telas/biblioteca/biblioteca.dart';
import 'package:weebooks2/ui/telas/biblioteca/widgets/conteudoBiblioteca/conteudoBibliotecaEbooks.dart';
import 'package:weebooks2/ui/telas/biblioteca/widgets/conteudoBiblioteca/conteudoBibliotecaLivros.dart';
import 'package:weebooks2/ui/telas/busca/busca.dart';
import 'package:weebooks2/ui/telas/home/widgets/homeButtonAnimation.dart';
import 'package:weebooks2/values/icons.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:weebooks2/values/values.dart';
import 'package:weebooks2/ui/shared/defaultValidateEmailDialog.dart';

class Home extends StatefulWidget {
  Home({Key key}) : super(key: key);
  @override
  HomeState createState() => HomeState();
}

class HomeState extends State<Home> with TickerProviderStateMixin {
  final AuthService _auth = AuthService();

  List<AnimationController> _controllers = [];
  List<AnimationController> get controllers => _controllers;
  int indexAtual;
  Future<bool> _future;
  bool showVerifyDialog = false;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    initializeDateFormatting();
    for (var i = 0; i < 3; i++) {
      _controllers.add(AnimationController(
          duration: const Duration(milliseconds: 250), vsync: this));
    }
    indexAtual = 0;
    _future = context.read<UserViewModel>().getUserData();
  }

  @override
  void dispose() {
    _controllers[0].dispose();
    _controllers[1].dispose();
    _controllers[2].dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final homeModel = Provider.of<HomeViewModel>(context);
    final userModel = Provider.of<UserViewModel>(context);
    final usuario = Provider.of<Usuario>(context);

    return Stack(
      children: [
        DefaultScaffold(
          actions: [
            // TESTE BUTTON
            // IconButton(
            //   icon: Icon(Icons.announcement),
            //   onPressed: () => Navigator.push(
            //     context,
            //     MaterialPageRoute(builder: (context) => Teste()),
            //   ),
            // ),
            homeModel.bibliotecaWidget is Biblioteca
                ? IconButton(
                    icon: Icon(Icons.exit_to_app),
                    onPressed: () => showDialog(
                      context: context,
                      builder: (context) => ExitDialog(),
                    ),
                  )
                : homeModel.bibliotecaWidget is ConteudoBibliotecaEbooks
                    ? Container(
                        margin: EdgeInsets.all(10),
                        child: FlatButton(
                          onPressed: () async {
                            FilePickerResult result =
                                await FilePicker.platform.pickFiles();
                            if (result != null) {
                              File file = File(result.files.single.path);
                              String fileName;

                              if (file.path.contains('.pdf')) {
                                print('pdf');
                                fileName = path
                                    .basename(file.path)
                                    .replaceAll('.pdf', '');

                                Ebook ebook = new Ebook();
                                setState(() => isLoading = true);
                                Ebook res =
                                    await homeModel.checkEbook(fileName);
                                if (res != null) {
                                  ebook = res;
                                } else {
                                  ebook.status = [];
                                }
                                homeModel.setCurrentEbook(ebook);
                                homeModel.setCurrentEbookFile(file);
                                homeModel.setShowEbookPerfil(
                                    res != null ? true : false);
                                setState(() => isLoading = false);
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) => EbookViewer(
                                      file: file,
                                      width: MediaQuery.of(context).size.width,
                                    ),
                                  ),
                                );
                              } else {
                                showDialog(
                                  context: context,
                                  builder: (context) => DefaultMessageDialog(
                                    title: "Disponível somente para pdfs",
                                    onPressed: () =>
                                        Navigator.of(context).pop(),
                                  ),
                                );
                              }
                            }
                          },
                          shape: RoundedRectangleBorder(
                            side: BorderSide(color: Colors.white),
                          ),
                          child: Text(
                            "Novo Ebook",
                            style: TextStyle(
                                fontFamily: 'Roboto', color: Colors.white),
                          ),
                        ),
                      )
                    : Container()
          ],
          floatingActionButton: homeModel.displayFloatingButton
              ? Stack(
                  alignment: Alignment.bottomRight,
                  children: List.generate(
                    homeModel.botaoPrincipalOpcoes[indexAtual][0].length + 2,
                    (index) {
                      int len =
                          homeModel.botaoPrincipalOpcoes[indexAtual][0].length;
                      return index == 0
                          ? GestureDetector(
                              onTap: () {
                                homeModel.updateButtonPressed(_controllers);
                              },
                              child: Container(
                                width: double.infinity,
                                height: double.infinity,
                                color: homeModel.buttonPressed
                                    ? Colors.transparent
                                    : null,
                              ),
                            )
                          : index > 0 && index <= len
                              ? HomeButtonAnimation(
                                  controller: _controllers[index - 1],
                                  title:
                                      homeModel.botaoPrincipalOpcoes[indexAtual]
                                          [0][index - 1],
                                  onPressed:
                                      homeModel.botaoPrincipalOpcoes[indexAtual]
                                          [1][index - 1],
                                  edgeInsets: EdgeInsets.only(
                                    bottom: (((index - 1) != 0 ? 60 : 65) *
                                            ((index - 1) + 1))
                                        .toDouble(),
                                  ),
                                )
                              : FloatingActionButton(
                                  shape: CircleBorder(
                                    side: BorderSide(color: Colors.white),
                                  ),
                                  child: Icon(
                                    Icons.add,
                                    size: 34,
                                    color: Colors.white,
                                  ),
                                  onPressed: () {
                                    if (!(!showVerifyDialog &&
                                        !usuario.emailVerified)) {
                                      homeModel
                                          .updateButtonPressed(_controllers);
                                    }
                                  },
                                );
                    },
                  ),
                )
              : null,
          leading: homeModel.bibliotecaWidget is ConteudoBibliotecaLivros ||
              homeModel.bibliotecaWidget is ConteudoBibliotecaEbooks,
          leadingWidget: Biblioteca(),
          bottomNavigationBar: BottomNavigationBar(
            currentIndex: indexAtual,
            showUnselectedLabels: true,
            unselectedItemColor: Colors.white.withOpacity(0.5),
            onTap: (value) {
              if (indexAtual != 1 &&
                  value == 0 &&
                  (homeModel.bibliotecaWidget is ConteudoBibliotecaLivros ||
                      homeModel.bibliotecaWidget is ConteudoBibliotecaEbooks)) {
                print("Teste");
                homeModel.setBibliotecaWidget(Biblioteca());
              }
              // if (value != 1) {
              setState(() => indexAtual = value);
              // }
            },
            showSelectedLabels: true,
            items: [
              buildBottomNavigationBarItem("Biblioteca", WeeBooks.book),
              // BottomNavigationBarItem(title: Text(""), icon: Icon(Icons.add)),
              buildBottomNavigationBarItem("Procurar", WeeBooks.search),
              // buildBottomNavigationBarItem("Feed", WeeBooks.feed),
              // buildBottomNavigationBarItem("Perfil", WeeBooks.user),
            ],
          ),
          body: FutureBuilder(
            future: _future,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Loading(opacity: false, color: primaryCyan);
              } else if (snapshot.hasData) {
                return RefreshIndicator(
                  backgroundColor: primaryCyan,
                  onRefresh: () async {
                    await userModel.getUserData();
                  },
                  child: Stack(
                    children: [
                      IndexedStack(
                        index: indexAtual,
                        children: [
                          homeModel.bibliotecaWidget,
                          // Container(),
                          Busca(),
                          // Feed(),
                          // Perfil()
                        ],
                      ),
                      !showVerifyDialog && !usuario.emailVerified
                          ? Container(
                              color: Colors.black.withOpacity(0.5),
                              child: DefaultValidateEmailDialog(
                                title: "Verifique seu email",
                                onPressed: () async {
                                  // setState(() => showVerifyDialog = true);
                                  await _auth.signOut();
                                },
                              ),
                            )
                          : Container(),
                      isLoading ? Loading() : Container(),
                    ],
                  ),
                );
              } else {
                print('SNAPSHOT_FUTURE_GET_STARTED: ' +
                    snapshot.error.toString());
                return Center(
                  child: Text('Ocorreu um erro, tente novamente mais tarde!'),
                );
              }
            },
          ),
        ),
      ],
    );
  }

  BottomNavigationBarItem buildBottomNavigationBarItem(
      String title, IconData icon) {
    return BottomNavigationBarItem(
      label: title,
      icon: Icon(
        icon,
      ),
    );
  }
}

class ExitDialog extends StatelessWidget {
  final AuthService _auth = AuthService();

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              "Deseja mesmo sair?",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                DefaultButton(
                  label: "Não",
                  onPressed: () => Navigator.of(context).pop(),
                ),
                DefaultButton(
                  label: "Sim",
                  color: primaryCyan,
                  textStyle: TextStyle(color: Colors.white),
                  onPressed: () {
                    Navigator.of(context).pop();
                    _auth.signOut();
                  },
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
