import 'package:flutter/material.dart';
import 'package:weebooks2/models/livro.dart';
import 'package:weebooks2/services/database.dart';
import 'package:weebooks2/services/google_books.dart';

class Teste extends StatelessWidget {
  final DatabaseService _data = DatabaseService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: RaisedButton(
          child: Text('Teste'),
          onPressed: () async {
            // GoogleBooks().buscaDeLivro('eduarda');
            await _data
                .getBookById("EVEjBgAAQBAJ")
                .then((value) => print(value));
            // print(await _data.getBookById("EVEjBgAAQBAJ"));
          },
        ),
      ),
    );
  }
}
