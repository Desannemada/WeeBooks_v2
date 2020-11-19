import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weebooks2/_view_models/home_view_model.dart';
import 'package:weebooks2/models/livro.dart';
import 'package:weebooks2/services/apis/api.dart';
import 'package:http/http.dart' as http;
import 'package:weebooks2/values/values.dart';

class GoogleBooks extends API {
  static GoogleBooks _api;

  GoogleBooks();

  static GoogleBooks instance() {
    if (_api == null) {
      _api = GoogleBooks();
    }
    return _api;
  }

  final String parameters =
      "&maxResults=40&printType=books&key=AIzaSyCXVoW02Obje-qVPxn2lW2SAC4uKOUouG0";
  // final String parameters =
  //     "&maxResults=1&key=AIzaSyCXVoW02Obje-qVPxn2lW2SAC4uKOUouG0";
  final String volumeSearchURL =
      "https://www.googleapis.com/books/v1/volumes?q=";

  Future<List<Livro>> buscaDeLivro(String input, BuildContext context) async {
    final hmodel = Provider.of<HomeViewModel>(context);
    if (hmodel.ultimaQuery[0] == input) {
      return hmodel.ultimaQuery[1];
    }
    if (input == '') {
      return null;
    }

    String splitInputs = input.replaceAll(" ", "+");

    var response = await http.get(volumeSearchURL + splitInputs + parameters);
    List<Livro> resultadoBusca = [];
    if (response.statusCode == 200) {
      Map<String, dynamic> busca = jsonDecode(response.body);

      for (var i = 0; i < busca['items'].length; i++) {
        Map item = busca['items'][i];
        Map volumeInfo = item['volumeInfo'];

        int pageCount = volumeInfo['pageCount'];
        String coverURL = volumeInfo.containsKey('imageLinks') &&
                volumeInfo['imageLinks'].containsKey('thumbnail')
            ? volumeInfo['imageLinks']['thumbnail']
            : 'assets/no-book-cover.png';
        String publishedDate = volumeInfo['publishedDate'];
        try {
          publishedDate = DateTime.parse(publishedDate).year.toString();
        } catch (e) {
          if (publishedDate == null || publishedDate.length != 4) {
            publishedDate = INDEFINIDO;
          }
        }

        if (pageCount != null) {
          resultadoBusca.add(Livro(
            authors: volumeInfo['authors'] ?? [],
            categories: volumeInfo['categories'] ?? [],
            coverURL: coverURL,
            description: volumeInfo['description'] ?? INDEFINIDO,
            id: item['id'],
            language: volumeInfo['language'] ?? INDEFINIDO,
            pageCount: pageCount,
            publishedDate: publishedDate,
            publisher: capitalize(volumeInfo['publisher']) ?? INDEFINIDO,
            title: capitalize(volumeInfo['title']) ?? INDEFINIDO,
            status: [],
          ));
        }
        // print(resultadoBusca.last.coverURL);
        for (var i = 0; i < resultadoBusca.last.authors.length; i++)
          resultadoBusca.last.authors[i] =
              capitalize(resultadoBusca.last.authors[i]);
        for (var i = 0; i < resultadoBusca.last.categories.length; i++)
          resultadoBusca.last.categories[i] =
              capitalize(resultadoBusca.last.categories[i]);
      }
    } else {
      print("\nErroStatus (Google Books): " + response.statusCode.toString());
    }
    hmodel.setUltimaQuery(input, resultadoBusca);
    return resultadoBusca;
  }

  String capitalize(String string) {
    String newString = "";
    if (string == null) {
      return null;
    } else {
      string = string.toLowerCase();
      List words = string.split(" ");

      for (var i = 0; i < words.length; i++) {
        newString += words[i][0].toUpperCase() + words[i].substring(1);
        if (i < words.length - 1) {
          newString += " ";
        }
      }
    }
    return newString;
  }
}
