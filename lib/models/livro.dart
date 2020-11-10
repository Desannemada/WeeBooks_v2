import 'package:weebooks2/models/status.dart';

class Livro {
  final String id;
  final String title;
  final List authors;
  final String publisher;
  final String publishedDate;
  final String description;
  final int pageCount;
  final List categories;
  final String language;
  final String coverURL;
  List<Status> status;

  Livro({
    this.id,
    this.title,
    this.authors,
    this.publisher,
    this.publishedDate,
    this.description,
    this.pageCount,
    this.categories,
    this.language,
    this.coverURL,
    this.status,
  });

  factory Livro.fromJson(Map<String, dynamic> json) {
    List<Status> status = [];
    for (var item in json['status']) {
      status.add(Status.fromJson(item));
    }

    return Livro(
      id: json['id'],
      title: json['title'],
      authors: json['authors'],
      publisher: json['publisher'],
      publishedDate: json['publishedDate'],
      description: json['description'],
      pageCount: json['pageCount'],
      categories: json['categories'],
      language: json['language'],
      coverURL: json['coverURL'],
      status: status,
    );
  }

  Map<String, dynamic> toJson() {
    List sts = [];
    for (var item in status) {
      sts.add(item.toJson());
    }

    return {
      'id': id,
      'title': title,
      'authors': authors,
      'publisher': publisher,
      'publishedDate': publishedDate,
      'description': description,
      'pageCount': pageCount,
      'categories': categories,
      'language': language,
      'coverURL': coverURL,
      'status': sts,
    };
  }

  void printLivro(Livro livro) {
    print("\nLIVRO");
    livro.toJson().forEach((key, value) {
      print('$key: $value');
    });
    print('\n');
  }
}
