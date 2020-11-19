import 'package:flutter/material.dart';
import 'package:weebooks2/models/livro.dart';
import 'package:weebooks2/ui/components/livro/livroPerfil/livroCover.dart';
import 'package:weebooks2/values/values.dart';

class LivroPerfilMainInfo extends StatelessWidget {
  LivroPerfilMainInfo({
    @required this.width,
    @required this.livro,
  });

  final double width;
  final Livro livro;

  final ScrollController _controller = ScrollController();

  @override
  Widget build(BuildContext context) {
    List<List<String>> options = [
      [
        livro.authors.isEmpty ? INDEFINIDO : livro.authors.join(', '),
        livro.authors.length > 1 ? 'Autores' : 'Autor'
      ],
      [livro.publishedDate + ', ' + livro.publisher, 'Ano, Editora'],
      [
        livro.categories.isEmpty ? INDEFINIDO : livro.categories.join(', '),
        livro.authors.length > 1 ? 'Categorias' : 'Categoria'
      ],
    ];

    return Row(
      children: [
        Container(
          width: width,
          height: width + 100,
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.all(
              Radius.circular(15),
            ),
          ),
          child: LivroCover(
            coverURL: livro.coverURL,
            boxFit: BoxFit.contain,
            borderRadius: 20,
          ),
        ),
        Expanded(
          child: Padding(
            padding: EdgeInsets.only(left: 20, top: 10, bottom: 10),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 46,
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                        color: Colors.grey.withOpacity(0.2),
                        width: 2,
                      ),
                    ),
                  ),
                  child: Scrollbar(
                    isAlwaysShown: true,
                    controller: _controller,
                    child: ListView(
                      shrinkWrap: true,
                      controller: _controller,
                      children: [
                        Text(
                          livro.title,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 5),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: List.generate(
                      3,
                      (index) => Padding(
                        padding: const EdgeInsets.only(bottom: 5),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              options[index][1].toUpperCase(),
                              style: TextStyle(
                                fontSize: 10,
                                color: Colors.grey[800],
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 5),
                            Text(
                              options[index][0],
                              style: TextStyle(
                                color: Colors.grey,
                                fontWeight: FontWeight.w600,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        )
      ],
    );
  }
}
