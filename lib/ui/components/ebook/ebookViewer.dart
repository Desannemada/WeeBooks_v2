import 'dart:io';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:pdf_render/pdf_render.dart';
import 'package:pdf_render/pdf_render_widgets2.dart';
import 'package:path/path.dart';
import 'package:provider/provider.dart';
import 'package:weebooks2/_view_models/home_view_model.dart';
import 'package:weebooks2/models/ebook.dart';
import 'package:weebooks2/ui/components/ebook/ebookAddDialog.dart';
import 'package:weebooks2/ui/shared/defaultScaffold.dart';
import 'package:weebooks2/values/icons.dart';
import 'package:weebooks2/values/values.dart';

class EbookViewer extends StatefulWidget {
  EbookViewer(
      {@required this.file, @required this.showBook, @required this.width});
  final File file;
  final bool showBook;
  final double width;

  @override
  _EbookViewerState createState() => _EbookViewerState();
}

class _EbookViewerState extends State<EbookViewer> {
  final controller = PdfViewerController();
  final scrollController = ScrollController();
  final scrollControllerEbook = ScrollController();
  int numPages;
  int currentPage = 0;
  int indexAtual = 0;
  PdfDocument doc;

  @override
  void initState() {
    getNumPages();
    scrollControllerEbook.addListener(() {
      getPage();
    });
    super.initState();
  }

  getPage() {
    var aux = (scrollControllerEbook.position.pixels / widget.width).round();
    if (currentPage != aux) {
      print(aux);
      setState(() {
        currentPage = aux;
      });
    }
  }

  getNumPages() async {
    PdfDocument aux = await PdfDocument.openFile(widget.file.path);
    setState(() {
      doc = aux;
      numPages = aux.pageCount;
      currentPage = 0;
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  String getFileName() {
    return basename(widget.file.path).replaceAll('.pdf', '');
  }

  @override
  Widget build(BuildContext context) {
    final hmodel = Provider.of<HomeViewModel>(context);

    double width = MediaQuery.of(context).size.width / 2.5;
    return DefaultScaffold(
      actions: currentPage != 0
          ? [
              IconButton(
                icon: Icon(Icons.bookmark_border),
                onPressed: () {},
              )
            ]
          : [],
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: PdfDocumentLoader(
            filePath: widget.file.path,
            documentBuilder: (context, pdfDocument, pageCount) => LayoutBuilder(
              builder: (context, constraints) => ListView.builder(
                controller: scrollControllerEbook,
                scrollDirection: Axis.horizontal,
                itemCount: pageCount + 1,
                itemBuilder: (context, index) => index != 0
                    ? Container(
                        height: MediaQuery.of(context).size.height,
                        width: MediaQuery.of(context).size.width,
                        color: Colors.black12,
                        child: PdfPageView(
                          pdfDocument: pdfDocument,
                          pageNumber: index,
                        ),
                      )
                    : Container(
                        height: MediaQuery.of(context).size.height,
                        width: MediaQuery.of(context).size.width,
                        child: Column(
                          children: [
                            Stack(
                              children: [
                                Container(
                                  height: width + 100,
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                    image: DecorationImage(
                                      image: AssetImage(
                                          "assets/CatBackground-horizontal.webp"),
                                      fit: BoxFit.fitWidth,
                                      colorFilter: new ColorFilter.mode(
                                        Colors.black.withOpacity(0.6),
                                        BlendMode.dstATop,
                                      ),
                                    ),
                                  ),
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Container(
                                      margin: EdgeInsets.all(10),
                                      width: width,
                                      height: width + 80,
                                      child: Card(
                                        elevation: 5.0,
                                        child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(5),
                                          child: PdfDocumentLoader(
                                            filePath: widget.file.path,
                                            pageNumber: 1,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            Container(
                              margin: EdgeInsets.all(10),
                              padding: EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                border: Border.all(),
                                borderRadius: BorderRadius.circular(5),
                              ),
                              alignment: Alignment.center,
                              child: Column(
                                children: [
                                  Text(
                                    getFileName(),
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(height: 10),
                                  Text(
                                    numPages.toString() + " páginas",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(fontSize: 16),
                                  ),
                                ],
                              ),
                            ),
                            widget.showBook
                                ? Container()
                                : Expanded(
                                    child: Align(
                                      alignment: Alignment.topCenter,
                                      child: Container(
                                        margin: EdgeInsets.symmetric(
                                            horizontal: 30),
                                        width: double.infinity,
                                        child: RaisedButton(
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                          color: primaryCyan,
                                          child: Text(
                                            "Adicionar à Biblioteca",
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 16),
                                          ),
                                          onPressed: () {
                                            Ebook ebook = new Ebook(
                                              title: getFileName(),
                                              pageCount: controller.pageCount,
                                              status: [],
                                            );
                                            hmodel.setCurrentEbook(ebook);
                                            showDialog(
                                              context: context,
                                              builder: (context) =>
                                                  EbookAddDialog(
                                                title: getFileName(),
                                                pageCount: numPages,
                                              ),
                                            );
                                          },
                                        ),
                                      ),
                                    ),
                                  ),
                            !widget.showBook
                                ? Container()
                                : Expanded(
                                    child: Container(
                                      padding: EdgeInsets.only(bottom: 10),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Icon(
                                            WeeBooks.swipe_left,
                                            color: Colors.black,
                                            size: 40,
                                          ),
                                          SizedBox(height: 10),
                                          Text(
                                            "Arraste para ler",
                                            style: TextStyle(
                                              fontSize: 16,
                                            ),
                                          )
                                        ],
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
      bottomNavigationBar: widget.showBook
          ? Container(
              height: 56,
              color: Colors.red,
              child: Stack(
                alignment: Alignment.bottomCenter,
                children: [
                  BottomNavigationBar(
                    onTap: (value) {
                      int page;
                      if (value == 0) {
                        page = 0;
                        scrollControllerEbook.jumpTo(0.0);
                      } else if (value == 1) {
                        if (currentPage > 0) {
                          page = currentPage - 1;
                          scrollControllerEbook.jumpTo((widget.width * page));
                        }
                      } else if (value == 3) {
                        if (currentPage < numPages) {
                          page = currentPage + 1;
                          scrollControllerEbook.jumpTo((widget.width * page));
                        }
                      } else if (value == 4) {
                        page = numPages;
                        scrollControllerEbook.jumpTo(
                            scrollControllerEbook.position.maxScrollExtent);
                      }
                      if (page != null) {
                        setState(() {
                          currentPage = page;
                        });
                      }
                      print(currentPage);
                    },
                    items: [
                      BottomNavigationBarItem(
                        icon: Icon(Icons.first_page),
                        label: "Início",
                      ),
                      BottomNavigationBarItem(
                        icon: Icon(Icons.arrow_back_ios_outlined),
                        label: "Anterior",
                      ),
                      BottomNavigationBarItem(
                        icon: Icon(Icons.arrow_forward_ios_outlined,
                            color: Colors.transparent),
                        label: "Páginas",
                      ),
                      BottomNavigationBarItem(
                        icon: Icon(Icons.arrow_forward_ios_outlined),
                        label: "Próximo",
                      ),
                      BottomNavigationBarItem(
                        icon: Icon(Icons.last_page),
                        label: "Fim",
                      ),
                    ],
                  ),
                  Center(
                      child: Text(
                    currentPage == 0
                        ? "Perfil"
                        : "Pág. " + (currentPage).toString(),
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  )),
                ],
              ),
            )
          : Text(""),
    );
  }
}
