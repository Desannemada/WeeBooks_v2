import 'package:flutter/material.dart';
import 'package:weebooks2/models/ebook.dart';

class EbookWidget extends StatelessWidget {
  EbookWidget({@required this.ebook});
  final Ebook ebook;

  @override
  Widget build(BuildContext context) {
    return Text(ebook.title);
  }
}
