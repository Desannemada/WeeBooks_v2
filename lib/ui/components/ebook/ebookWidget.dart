import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weebooks2/_view_models/home_view_model.dart';
import 'package:weebooks2/models/ebook.dart';
import 'package:path_provider/path_provider.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:weebooks2/ui/components/ebook/ebookViewer.dart';
import 'package:weebooks2/ui/shared/loading.dart';
import 'package:weebooks2/values/icons.dart';
import 'package:weebooks2/values/values.dart';

class EbookWidget extends StatefulWidget {
  EbookWidget({@required this.ebook});
  final Ebook ebook;

  @override
  _EbookWidgetState createState() => _EbookWidgetState();
}

class _EbookWidgetState extends State<EbookWidget> {
  String ebookPath;
  bool isLoading = false;
  IconData icon;

  @override
  void initState() {
    if (widget.ebook.path.contains('.pdf')) {
      icon = WeeBooks.pdf;
    } else if (widget.ebook.path.contains('.epub')) {
      icon = WeeBooks.epub;
    }
    super.initState();
  }

  Future<File> downloadPDF() async {
    setState(() => isLoading = true);
    Directory appDocDir = await getApplicationDocumentsDirectory();
    File downloadToFile = File('${appDocDir.path}/${widget.ebook.title}.pdf');
    print(downloadToFile.path);
    if ((await downloadToFile.exists()) == false) {
      print("Não existe");
      try {
        print("Ebook-path: " + widget.ebook.path);
        await firebase_storage.FirebaseStorage.instance
            .ref(widget.ebook.path)
            .writeToFile(downloadToFile);
      } catch (e) {
        setState(() => isLoading = false);
        print("Erro PDF: " + e.toString());
        return null;
      }
    } else {
      print("Existe");
    }

    setState(() => isLoading = false);
    return downloadToFile;
  }

  @override
  Widget build(BuildContext context) {
    final hModel = Provider.of<HomeViewModel>(context);

    return Container(
      margin: EdgeInsets.all(10),
      color: Colors.grey,
      child: Stack(
        alignment: Alignment.center,
        children: [
          RaisedButton(
            onPressed: () async {
              File file = await downloadPDF();
              if (file != null) {
                hModel.setCurrentEbook(widget.ebook);
                print(widget.ebook.toJson());
                hModel.setShowEbookPerfil(true);
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => EbookViewer(
                      file: file,
                      width: MediaQuery.of(context).size.width,
                    ),
                  ),
                );
              }
            },
            shape: RoundedRectangleBorder(side: BorderSide(color: primaryCyan)),
            color: Colors.white,
            padding: EdgeInsets.zero,
            child: Padding(
              padding: EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(icon, size: 34),
                      SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          widget.ebook.title,
                          style: TextStyle(fontSize: 16),
                          softWrap: true,
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Wrap(
                      runSpacing: 8,
                      spacing: 8,
                      children: List.generate(
                        widget.ebook.status.length,
                        (index) => Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30),
                            color: Colors.grey[300],
                          ),
                          padding:
                              EdgeInsets.symmetric(vertical: 3, horizontal: 10),
                          child: Wrap(
                            crossAxisAlignment: WrapCrossAlignment.center,
                            spacing: 5,
                            children: [
                              Text(
                                widget.ebook.status[index].title,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                ),
                              ),
                              Text(
                                widget.ebook.status[index].date,
                                style: TextStyle(
                                  color: Colors.grey[600],
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'Roboto',
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
          isLoading
              ? Loading(
                  opacity: false,
                  color: primaryCyan,
                  size: 28,
                )
              : Container()
        ],
      ),
    );
  }
}
