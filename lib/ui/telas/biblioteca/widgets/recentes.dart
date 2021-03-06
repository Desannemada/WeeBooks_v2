import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weebooks2/_view_models/home_view_model.dart';
import 'package:weebooks2/_view_models/user_view_model.dart';
import 'package:weebooks2/models/livro.dart';
import 'package:weebooks2/models/status.dart';
import 'package:weebooks2/ui/components/livro/livroPerfil.dart';
import 'package:weebooks2/ui/components/livro/livroPerfil/livroCover.dart';
import 'package:weebooks2/ui/shared/loading.dart';

class Recentes extends StatefulWidget {
  @override
  _RecentesState createState() => _RecentesState();
}

class _RecentesState extends State<Recentes> {
  final double width = 95;
  final double height = 143;

  bool isLoading = false;
  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final uModel = Provider.of<UserViewModel>(context);
    final hModel = Provider.of<HomeViewModel>(context);

    return Container(
      width: double.infinity,
      height: height,
      child: CarouselSlider(
        options: CarouselOptions(
          viewportFraction: 0.26,
        ),
        items: List.generate(10, (index) {
          List<Livro> recentes = uModel.userRecentes.reversed.toList();
          return index < recentes.length
              ? Card(
                  margin: EdgeInsets.zero,
                  color: Colors.transparent,
                  elevation: 5,
                  child: Container(
                    width: width,
                    height: height,
                    decoration: BoxDecoration(
                      color: Colors.grey.withOpacity(0.8),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        EmptyRecentSlotContent(height, width),
                        LivroCover(
                          coverURL: recentes[index].coverURL ?? "",
                          type: 1,
                        ),
                        isLoading && currentIndex == index
                            ? Loading(
                                size: 30, opacity: true, borderRadius: 4.0)
                            : Text(""),
                        FlatButton(
                            color: Colors.transparent,
                            padding: EdgeInsets.zero,
                            child: Container(),
                            onPressed: () async {
                              setState(() {
                                currentIndex = index;
                                isLoading = true;
                              });
                              List<Status> res =
                                  await hModel.checkBook(recentes[index]);
                              if (res != null) {
                                recentes[index].status = res;
                              } else {
                                recentes[index].status = [];
                              }
                              hModel.setCurrentLivro(recentes[index]);
                              setState(() => isLoading = false);
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => LivroPerfil(),
                                ),
                              );
                            }),
                      ],
                    ),
                  ),
                )
              : EmptyRecentSlot(height, width);
        }),
      ),
    );
  }
}

class EmptyRecentSlot extends StatelessWidget {
  EmptyRecentSlot(this.height, this.width);

  final double width;
  final double height;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.zero,
      color: Colors.transparent,
      elevation: 5,
      child: EmptyRecentSlotContent(height, width),
    );
  }
}

class EmptyRecentSlotContent extends StatelessWidget {
  EmptyRecentSlotContent(this.height, this.width);

  final double width;
  final double height;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: Colors.grey.withOpacity(0.8),
        borderRadius: BorderRadius.circular(5),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.photo,
            size: 40,
            color: Colors.white,
          ),
          SizedBox(height: 5),
          Text(
            "Vazio",
            style: TextStyle(
              fontSize: 16,
              color: Colors.white,
            ),
          )
        ],
      ),
    );
  }
}
