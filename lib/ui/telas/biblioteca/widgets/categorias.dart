import 'package:flutter/material.dart';
import 'package:weebooks2/values/icons.dart';
import 'package:weebooks2/values/values.dart';

class Categorias extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      // padding: EdgeInsets.symmetric(horizontal: 10),
      child: Row(
        children: [
          Expanded(
            child: ItemCategoria(
              title: "Livros",
              color: accent1,
              image: "assets/categories/cBook.webp",
            ),
          ),
          Expanded(
            child: ItemCategoria(
              title: "Fics",
              color: accent2,
              image: "assets/categories/cFic.webp",
            ),
          ),
          Expanded(
            child: ItemCategoria(
              title: "E-Books",
              color: accent3,
              image: "assets/categories/cEbook.webp",
            ),
          ),
        ],
      ),
    );
  }
}

class ItemCategoria extends StatelessWidget {
  ItemCategoria({
    @required this.title,
    @required this.color,
    @required this.image,
  });

  final String title;
  final Color color;
  final String image;

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height / 5;

    return Padding(
      padding: EdgeInsets.all(5),
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(7)),
        child: Stack(
          children: [
            Container(
              height: height,
              width: double.infinity,
              alignment: Alignment.bottomCenter,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(7),
                color: Colors.white,
                image: DecorationImage(
                  image: AssetImage(image),
                  fit: BoxFit.cover,
                ),
              ),
              child: FractionallySizedBox(
                heightFactor: 0.2,
                child: Container(
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(7),
                      bottomRight: Radius.circular(7),
                    ),
                    color: Colors.black.withOpacity(0.4),
                  ),
                  child: Text(
                    title,
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ),
              ),
            ),
            Container(
              height: height,
              width: double.infinity,
              child: FlatButton(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(7),
                ),
                child: null,
                onPressed: () {},
              ),
            )
          ],
        ),
      ),
    );
  }
}
