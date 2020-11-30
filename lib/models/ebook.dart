import 'package:weebooks2/models/status.dart';

class Ebook {
  // final String id;
  String title;
  int pageCount;
  List<Status> status;
  int lastPage;
  String path;
  List markings;

  Ebook({
    // this.id,
    this.title,
    this.pageCount,
    this.status,
    this.lastPage,
    this.path,
    this.markings,
  });

  factory Ebook.fromJson(Map<String, dynamic> json) {
    List<Status> status = [];
    if (json['status'] != null) {
      for (var item in json['status']) {
        status.add(Status.fromJson(item));
      }
    }

    return Ebook(
      // id: json['id'],
      title: json['title'],
      pageCount: json['pageCount'],
      lastPage: json['lastPage'],
      status: status,
      path: json['path'],
      markings: json['markings'],
    );
  }

  Map<String, dynamic> toJson() {
    List sts = [];
    for (var item in status) {
      sts.add(item.toJson());
    }

    return {
      // 'id': id,
      'title': title,
      'pageCount': pageCount,
      'lastPage': lastPage,
      'status': sts,
      'path': path,
      'markings': markings,
    };
  }

  void printLivro(Ebook ebook) {
    print("\EBOOK");
    ebook.toJson().forEach((key, value) {
      print('$key: $value');
    });
    print('\n');
  }
}
