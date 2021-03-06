import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weebooks2/_view_models/home_view_model.dart';
import 'package:weebooks2/_view_models/user_view_model.dart';
import 'package:weebooks2/models/estatisticas.dart';
import 'package:weebooks2/values/icons.dart';
import 'package:weebooks2/values/values.dart';

class Status extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      margin: EdgeInsets.only(right: 0.1, left: 0.1, top: 0.05),
      child: Column(
        children: [
          SpecificInfo(id: 0, title: "Em sua Biblioteca"),
          Container(height: 20, color: Colors.white),
          SpecificInfo(id: 1, title: "Total de Páginas"),
        ],
      ),
    );
  }
}

class SpecificInfo extends StatefulWidget {
  SpecificInfo({
    @required this.id,
    @required this.title,
  });

  final int id;
  final String title;

  @override
  _SpecificInfoState createState() => _SpecificInfoState();
}

class _SpecificInfoState extends State<SpecificInfo> {
  int lontra = 0;

  @override
  Widget build(BuildContext context) {
    List<dynamic> options = [
      [WeeBooks.cBook, accent1],
      // [WeeBooks.cFic, accent2],
      [WeeBooks.cEbook, accent3]
    ];

    final hModel = Provider.of<HomeViewModel>(context);
    final uModel = Provider.of<UserViewModel>(context);
    Estatisticas info =
        widget.id == 0 ? uModel.userTotalLidos : uModel.userPaginasLidas;

    return Container(
      height: 90,
      child: Stack(
        children: [
          Container(
            height: 62,
            alignment: Alignment.topLeft,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/status/status.webp"),
                fit: BoxFit.cover,
                alignment: widget.id == 0
                    ? Alignment.topCenter
                    : Alignment.bottomCenter,
              ),
              borderRadius: BorderRadius.vertical(
                  bottom: Radius.circular(widget.id == 0 ? 0 : 7)),
            ),
            child: FractionallySizedBox(
              heightFactor: 0.5,
              child: Container(
                width: 170,
                padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.3),
                  borderRadius: BorderRadius.only(
                    bottomRight: Radius.circular(30),
                  ),
                ),
                child: Text(
                  widget.title,
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: 27,
              width: double.infinity,
              color: Colors.white,
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: List.generate(
              options.length,
              (index) => Align(
                alignment: Alignment.bottomCenter,
                child: GestureDetector(
                  onTap: () {
                    if (index == 1 && widget.id == 0) {
                      setState(() {
                        lontra += 1;
                        if (lontra == 7) {
                          lontra = 0;
                          hModel.setShowLontra(true);
                        }
                      });
                    }
                  },
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(7),
                    ),
                    elevation: 3,
                    child: Container(
                      height: 50,
                      width: 130,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(7),
                        color: Colors.white,
                      ),
                      padding: EdgeInsets.all(10),
                      child: Row(
                        children: [
                          Icon(
                            options[index][0],
                            color: options[index][1],
                          ),
                          SizedBox(width: 5),
                          Expanded(
                            child: Align(
                              alignment: Alignment.center,
                              child: Text(
                                hModel.formatNumber(index == 0
                                    ? info.livros
                                    : /*index == 1 ? info.fics :*/ info.ebooks),
                                style: TextStyle(fontSize: 18),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
