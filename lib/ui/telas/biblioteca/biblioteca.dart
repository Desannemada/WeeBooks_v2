import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weebooks2/_view_models/home_view_model.dart';
import 'package:weebooks2/ui/telas/biblioteca/widgets/categorias.dart';
import 'package:weebooks2/ui/telas/biblioteca/widgets/metaLeitura/metaLeitura.dart';
import 'package:weebooks2/ui/telas/biblioteca/widgets/recentes.dart';
import 'package:weebooks2/ui/telas/biblioteca/widgets/status.dart';

class Biblioteca extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView(
      shrinkWrap: true,
      children: [
        BibliotecaWidget(
          title: "Adicionados Recentemente",
          fontSize: 16,
          widget: Recentes(),
          padding: EdgeInsets.zero,
          alignment: MainAxisAlignment.center,
        ),
        BibliotecaWidget(
          title: "Status",
          widget: Status(),
          shrink: true,
        ),
        BibliotecaWidget(
          title: "Metas de Leitura",
          widget: MetaLeitura(),
          shrink: true,
        ),
        BibliotecaWidget(
          title: "Biblioteca",
          widget: Categorias(),
        ),
      ],
    );
  }
}

class BibliotecaWidget extends StatefulWidget {
  BibliotecaWidget({
    this.padding = const EdgeInsets.symmetric(horizontal: 10),
    @required this.title,
    this.fontSize = 20,
    @required this.widget,
    this.endDivider = true,
    this.alignment = MainAxisAlignment.spaceBetween,
    this.shrink = false,
  });

  final EdgeInsetsGeometry padding;
  final String title;
  final double fontSize;
  final Widget widget;
  final bool endDivider;
  final MainAxisAlignment alignment;
  final bool shrink;

  @override
  _BibliotecaWidgetState createState() => _BibliotecaWidgetState();
}

class _BibliotecaWidgetState extends State<BibliotecaWidget> {
  // bool isOpen = true;

  @override
  Widget build(BuildContext context) {
    final hModel = Provider.of<HomeViewModel>(context);

    return Column(
      children: [
        SizedBox(height: 15),
        GestureDetector(
          onTap: () {
            // setState(() {
            //   isOpen = !isOpen;
            // });
            hModel.setOpen(widget.title);
          },
          child: Container(
            color: Colors.white,
            child: Padding(
              padding: widget.padding,
              child: Row(
                mainAxisAlignment: widget.alignment,
                children: [
                  Text(
                    widget.title,
                    style: TextStyle(
                      fontSize: widget.fontSize,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  widget.shrink
                      ? Container(
                          height: 25,
                          child: Row(
                            children: [
                              Text(
                                "Mostrar",
                                style: TextStyle(color: Colors.black),
                              ),
                              Icon((widget.title == "Status"
                                      ? hModel.openStatus
                                      : hModel.openMetas)
                                  ? Icons.keyboard_arrow_down
                                  : Icons.keyboard_arrow_left)
                            ],
                          ),
                        )
                      : Container()
                ],
              ),
            ),
          ),
        ),
        AnimatedSwitcher(
          duration: Duration(milliseconds: 300),
          child: buildBibliotecaWidget(),
        ),
        SizedBox(height: 15),
        widget.endDivider ? Divider() : Container(),
      ],
    );
  }

  Widget buildBibliotecaWidget() {
    final hModel = Provider.of<HomeViewModel>(context);
    return (widget.title == "Status"
            ? hModel.openStatus
            : (widget.title == "Metas de Leitura" ? hModel.openMetas : true))
        ? Column(
            children: [
              SizedBox(height: 15),
              Padding(
                padding: widget.padding,
                child: widget.widget,
              ),
            ],
          )
        : Container();
  }
}
