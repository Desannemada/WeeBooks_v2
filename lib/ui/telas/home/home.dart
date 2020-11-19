import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';
import 'package:weebooks2/_view_models/home_view_model.dart';
import 'package:weebooks2/_view_models/user_view_model.dart';
import 'package:weebooks2/models/user.dart';

import 'package:weebooks2/services/auth.dart';
import 'package:weebooks2/services/database.dart';
import 'package:weebooks2/ui/shared/defaultMessageDialog.dart';
import 'package:weebooks2/ui/shared/defaultScaffold.dart';
import 'package:weebooks2/ui/shared/loading.dart';
import 'package:weebooks2/ui/telas/biblioteca/biblioteca.dart';
import 'package:weebooks2/ui/telas/busca/busca.dart';
import 'package:weebooks2/ui/telas/home/widgets/homeButtonAnimation.dart';
import 'package:weebooks2/values/icons.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:weebooks2/values/values.dart';

class Home extends StatefulWidget {
  Home({Key key}) : super(key: key);
  @override
  HomeState createState() => HomeState();
}

class HomeState extends State<Home> with TickerProviderStateMixin {
  final AuthService _auth = AuthService();
  final DatabaseService _data = DatabaseService();

  List<AnimationController> _controllers = [];
  List<AnimationController> get controllers => _controllers;
  int indexAtual;
  Future<bool> _future;
  bool showVerifyDialog = false;

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
            //TESTE BUTTON
            // IconButton(
            //   icon: Icon(Icons.announcement),
            //   onPressed: () => Navigator.push(
            //     context,
            //     MaterialPageRoute(builder: (context) => Teste()),
            //   ),
            // ),
            IconButton(
              icon: Icon(Icons.exit_to_app),
              onPressed: () => _auth.signOut(),
            ),
          ],
          bottomNavigationBar: BottomNavigationBar(
            currentIndex: indexAtual,
            onTap: (value) {
              if (value != 1) {
                setState(() => indexAtual = value);
              }
            },
            items: [
              buildBottomNavigationBarItem("Biblioteca", WeeBooks.book),
              BottomNavigationBarItem(title: Text(""), icon: Icon(Icons.add)),
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
                          Biblioteca(),
                          Container(),
                          Busca(),
                          // Feed(),
                          // Perfil()
                        ],
                      ),
                      !showVerifyDialog && !usuario.emailVerified
                          ? Container(
                              color: Colors.black.withOpacity(0.5),
                              child: DefaultMessageDialog(
                                title: "Verifique seu email",
                                onPressed: () =>
                                    setState(() => showVerifyDialog = true),
                              ),
                            )
                          : Container(),
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
        GestureDetector(
          onTap: () {
            homeModel.updateButtonPressed(_controllers);
          },
          child: Container(
            color: homeModel.buttonPressed ? Colors.transparent : null,
          ),
        ),
        Stack(
          children: List.generate(
              homeModel.botaoPrincipalOpcoes[indexAtual][0].length, (index) {
            return HomeButtonAnimation(
              controller: _controllers[index],
              title: homeModel.botaoPrincipalOpcoes[indexAtual][0][index],
              onPressed: homeModel.botaoPrincipalOpcoes[indexAtual][1][index],
              edgeInsets: EdgeInsets.only(
                bottom: index < 2 ? 85.0 : 145.0,
                right:
                    index == 0 ? MediaQuery.of(context).size.width / 2.3 : 0.0,
                left:
                    index == 1 ? MediaQuery.of(context).size.width / 2.3 : 0.0,
              ),
            );
          }),
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: Container(
            height: AppBar().preferredSize.height + 10,
            child: FittedBox(
              child: FloatingActionButton(
                shape: CircleBorder(side: BorderSide(color: Colors.white)),
                child: Icon(Icons.add, size: 34, color: Colors.white),
                onPressed: () {
                  homeModel.updateButtonPressed(_controllers);

                  // List<Livro> livros =
                  //     await GoogleBooks().buscaDeLivro("harry");
                  // for (var i = 0; i < 1; i++) {
                  //   await _data.addBook(livros[i + 9]);
                  // }
                  // await _data.atualizarMeta();
                },
              ),
            ),
          ),
        ),
      ],
    );
  }

  BottomNavigationBarItem buildBottomNavigationBarItem(
      String title, IconData icon) {
    return BottomNavigationBarItem(
      title: Text(title),
      icon: Icon(
        icon,
      ),
    );
  }
}
