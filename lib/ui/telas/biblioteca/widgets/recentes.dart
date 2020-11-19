import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weebooks2/_view_models/user_view_model.dart';
import 'package:weebooks2/models/livro.dart';
import 'package:weebooks2/ui/components/livro/livroPerfil/livroCover.dart';

class Recentes extends StatelessWidget {
  final double width = 95;
  final double height = 143;

  @override
  Widget build(BuildContext context) {
    final userModel = Provider.of<UserViewModel>(context);

    return Container(
      width: double.infinity,
      height: height,
      child: CarouselSlider(
        options: CarouselOptions(
          viewportFraction: 0.26,
          // enlargeCenterPage: true,
        ),
        items: List.generate(10, (index) {
          List<Livro> recentes = userModel.userRecentes.reversed.toList();
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
                          coverURL: recentes[index].coverURL,
                          type: 1,
                        ),
                        FlatButton(
                          color: Colors.transparent,
                          padding: EdgeInsets.zero,
                          child: Container(),
                          onPressed: () {},
                        ),
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
