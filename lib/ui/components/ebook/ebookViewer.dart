import 'dart:io';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pdf_render/pdf_render.dart';
import 'package:pdf_render/pdf_render_widgets2.dart';
import 'package:path/path.dart';
import 'package:provider/provider.dart';
import 'package:weebooks2/_view_models/home_view_model.dart';
import 'package:weebooks2/models/ebook.dart';
import 'package:weebooks2/services/database.dart';
import 'package:weebooks2/ui/components/ebook/ebookAddDialog.dart';
import 'package:weebooks2/ui/shared/defaultButton.dart';
import 'package:weebooks2/ui/shared/defaultMessageDialog.dart';
import 'package:weebooks2/ui/shared/defaultScaffold.dart';
import 'package:weebooks2/ui/shared/loading.dart';
import 'package:weebooks2/values/icons.dart';
import 'package:weebooks2/values/values.dart';

class EbookViewer extends StatefulWidget {
  EbookViewer({@required this.file, @required this.width});
  final File file;
  // final bool showBook;
  final double width;

  @override
  _EbookViewerState createState() => _EbookViewerState();
}

class _EbookViewerState extends State<EbookViewer> {
  final DatabaseService _data = DatabaseService();

  final controller = PdfViewerController();
  final scrollControllerEbook = ScrollController();
  int numPages;
  int indexAtual = 0;
  PdfDocument doc;
  bool isLoading = false;

  @override
  void initState() {
    getNumPages();
    super.initState();
  }

  getNumPages() async {
    PdfDocument aux = await PdfDocument.openFile(widget.file.path);
    setState(() {
      doc = aux;
      numPages = aux.pageCount;
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  String getFileName() {
    return basename(widget.file.path)
        .replaceAll('.pdf', '')
        .replaceAll('.epub', '');
  }

  @override
  Widget build(BuildContext context) {
    final hmodel = Provider.of<HomeViewModel>(context);

    double width = MediaQuery.of(context).size.width / 2.5;
    return DefaultScaffold(
      actions: hmodel.showEbookPerfil
          ? [
              IconButton(
                icon: Icon(Icons.add),
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) => EbookAddDialog(
                      title: hmodel.currentEbook.title,
                      pageCount: hmodel.currentEbook.pageCount,
                    ),
                  );
                },
              ),
              IconButton(
                icon: Icon(Icons.bookmark_border),
                onPressed: () async {
                  setState(() => isLoading = true);
                  double offset = scrollControllerEbook.offset;
                  int page = ((offset / widget.width)).round();
                  hmodel.setEbookMarking(
                      page, hmodel.currentEbook.markings.contains(page));
                  bool addOrRemove =
                      hmodel.currentEbook.markings.contains(page);
                  bool res =
                      await _data.atualizarEbookMarkings(hmodel.currentEbook);

                  showDialog(
                      context: context,
                      builder: (context) => DefaultMessageDialog(
                            title: res
                                ? addOrRemove
                                    ? "Marcação Adicionada"
                                    : "Marcação Removida"
                                : "Ocorreu um erro :(",
                            onPressed: () => Navigator.of(context).pop(),
                          ));

                  setState(() => isLoading = false);
                },
              ),
            ]
          : [],
      body: Stack(
        children: [
          Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              child: PdfDocumentLoader(
                filePath: widget.file.path,
                documentBuilder: (context, pdfDocument, pageCount) =>
                    LayoutBuilder(
                  builder: (context, constraints) => InteractiveViewer(
                    panEnabled: false,
                    minScale: 0.5,
                    maxScale: 4,
                    child: ListView.builder(
                      controller: scrollControllerEbook,
                      scrollDirection: Axis.horizontal,
                      itemCount: pageCount + 1,
                      itemBuilder: (context, index) => index != 0
                          ? Container(
                              height: MediaQuery.of(context).size.height,
                              width: MediaQuery.of(context).size.width,
                              color: Colors.black12,
                              child: Stack(
                                fit: StackFit.expand,
                                children: [
                                  PdfPageView(
                                    pdfDocument: pdfDocument,
                                    pageNumber: index,
                                  ),
                                  Align(
                                    alignment: Alignment.topRight,
                                    child: Container(
                                      margin: EdgeInsets.all(15),
                                      padding: EdgeInsets.all(3),
                                      color: Colors.black.withOpacity(0.4),
                                      child: Text(
                                        index.toString(),
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    ),
                                  )
                                ],
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
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
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
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(top: 10),
                                          child: Wrap(
                                            runSpacing: 8,
                                            spacing: 8,
                                            children: List.generate(
                                              hmodel.currentEbook.status.length,
                                              (index) => Container(
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(30),
                                                  color: Colors.grey[300],
                                                ),
                                                padding: EdgeInsets.symmetric(
                                                    vertical: 3,
                                                    horizontal: 10),
                                                child: Wrap(
                                                  crossAxisAlignment:
                                                      WrapCrossAlignment.center,
                                                  spacing: 5,
                                                  children: [
                                                    Text(
                                                      hmodel.currentEbook
                                                          .status[index].title,
                                                      style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 12,
                                                      ),
                                                    ),
                                                    Text(
                                                      hmodel.currentEbook
                                                          .status[index].date,
                                                      style: TextStyle(
                                                        color: Colors.grey[600],
                                                        fontSize: 11,
                                                        fontWeight:
                                                            FontWeight.bold,
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
                                  hmodel.showEbookPerfil
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
                                                    pageCount:
                                                        controller.pageCount,
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
                                  !hmodel.showEbookPerfil
                                      ? Container()
                                      : Expanded(
                                          child: Container(
                                            padding:
                                                EdgeInsets.only(bottom: 10),
                                            alignment: hmodel.currentEbook
                                                    .markings.isEmpty
                                                ? Alignment.center
                                                : Alignment.topCenter,
                                            child: ListView(
                                              shrinkWrap: true,
                                              children: [
                                                Padding(
                                                  padding: EdgeInsets.only(
                                                      bottom: 20),
                                                  child: ListView(
                                                    shrinkWrap: true,
                                                    physics:
                                                        NeverScrollableScrollPhysics(),
                                                    children: List.generate(
                                                      hmodel.currentEbook
                                                          .markings.length,
                                                      (index) => FlatButton(
                                                        onPressed: () {
                                                          scrollControllerEbook
                                                              .jumpTo((widget
                                                                      .width *
                                                                  hmodel.currentEbook
                                                                          .markings[
                                                                      index]));
                                                        },
                                                        materialTapTargetSize:
                                                            MaterialTapTargetSize
                                                                .shrinkWrap,
                                                        child: Row(
                                                          children: [
                                                            Icon(
                                                              Icons.bookmark,
                                                              color:
                                                                  Colors.purple,
                                                            ),
                                                            SizedBox(width: 10),
                                                            Text(
                                                              "Ir para página ${hmodel.currentEbook.markings[index]}",
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                Icon(
                                                  WeeBooks.swipe_left,
                                                  color: Colors.black,
                                                  size: 40,
                                                ),
                                                SizedBox(height: 10),
                                                Text(
                                                  "Arraste para ler",
                                                  textAlign: TextAlign.center,
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
          ),
          isLoading ? Loading() : Container()
        ],
      ),
      bottomNavigationBar: hmodel.showEbookPerfil
          ? Container(
              height: 56,
              color: Colors.red,
              child: Stack(
                alignment: Alignment.bottomCenter,
                children: [
                  BottomNavigationBar(
                    showUnselectedLabels: true,
                    showSelectedLabels: true,
                    onTap: (value) {
                      if (value == 0) {
                        scrollControllerEbook.jumpTo(0.0);
                      } else if (value == 1) {
                        double offset = scrollControllerEbook.offset;
                        int page = ((offset / widget.width) - 1).round();
                        if (page >= 0) {
                          scrollControllerEbook.jumpTo((widget.width * page));
                        }
                      } else if (value == 3) {
                        double offset = scrollControllerEbook.offset;
                        int page = ((offset / widget.width) + 1).round();
                        if (page <= numPages) {
                          scrollControllerEbook.jumpTo((widget.width * page));
                        }
                      } else if (value == 4) {
                        scrollControllerEbook.jumpTo(
                            scrollControllerEbook.position.maxScrollExtent);
                      } else if (value == 2) {
                        showDialog(
                          context: context,
                          builder: (context) => GoToPageDialog(
                            controller: scrollControllerEbook,
                            width: widget.width,
                            pageCount: numPages,
                          ),
                        );
                      }
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
                        icon: Icon(Icons.find_in_page_outlined),
                        label: "Escolher",
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
                ],
              ),
            )
          : Text(""),
    );
  }
}

class GoToPageDialog extends StatefulWidget {
  GoToPageDialog(
      {@required this.controller,
      @required this.width,
      @required this.pageCount});

  final ScrollController controller;
  final double width;
  final int pageCount;

  @override
  _GoToPageDialogState createState() => _GoToPageDialogState();
}

class _GoToPageDialogState extends State<GoToPageDialog> {
  TextEditingController paginaController = TextEditingController();

  @override
  void initState() {
    double offset = widget.controller.offset;
    int page = (offset / widget.width).round();
    paginaController = TextEditingController(text: page.toString());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        padding: EdgeInsets.all(20),
        width: 60,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            TextField(
              controller: paginaController,
              decoration: InputDecoration(
                labelText: "Página",
                contentPadding: EdgeInsets.zero,
                counterText: "Total: " + widget.pageCount.toString(),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(20),
                  ),
                  borderSide: BorderSide(
                    color: primaryCyan,
                    width: 2,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(20),
                  ),
                  borderSide: BorderSide(
                    color: primaryCyan,
                    width: 2,
                  ),
                ),
              ),
              cursorColor: primaryCyan,
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                DefaultButton(
                  label: "Voltar",
                  onPressed: () => Navigator.of(context).pop(),
                ),
                DefaultButton(
                  label: "Ir",
                  color: primaryCyan,
                  textStyle: TextStyle(color: Colors.white),
                  onPressed: () {
                    if (paginaController.text.isNotEmpty) {
                      int page = int.parse(paginaController.text);
                      if (page >= 0 && page <= widget.pageCount) {
                        Navigator.of(context).pop();
                        widget.controller.jumpTo(widget.width * page);
                      }
                    }
                  },
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
