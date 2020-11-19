import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weebooks2/_view_models/home_view_model.dart';
import 'package:weebooks2/_view_models/user_view_model.dart';
import 'package:weebooks2/models/status.dart';

class LivroPerfilStatus extends StatefulWidget {
  LivroPerfilStatus({
    Key key,
    this.type = 0,
  }) : super(key: key);

  final int type;

  @override
  _LivroPerfilStatusState createState() => _LivroPerfilStatusState();
}

class _LivroPerfilStatusState extends State<LivroPerfilStatus> {
  // List<bool> isExcluded = [];

  @override
  Widget build(BuildContext context) {
    final hModel = Provider.of<HomeViewModel>(context);

    // for (var _ in hModel.currentLivro.status) {
    //   isExcluded.add(false);
    // }

    List<double> fontSizes = [];
    if (widget.type == 0) {
      fontSizes = [17, 14, 12];
    } else {
      fontSizes = [16, 13, 11];
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        widget.type == 0
            ? Padding(
                padding: EdgeInsets.only(bottom: 10),
                child: Text(
                  'Status',
                  style: TextStyle(
                    fontSize: fontSizes[0],
                    fontWeight: FontWeight.bold,
                  ),
                ),
              )
            : Container(),
        hModel.currentLivro.status.isNotEmpty
            ? Wrap(
                runSpacing: 10,
                spacing: 10,
                children: List.generate(
                  hModel.excludedStatus.length,
                  (index) => Stack(
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(
                          vertical: 5,
                          horizontal: 10,
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30),
                          color: Colors.grey[300],
                        ),
                        child: Wrap(
                          crossAxisAlignment: WrapCrossAlignment.center,
                          spacing: 5,
                          children: [
                            Text(
                              hModel.currentLivro.status[index].title,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: fontSizes[1],
                              ),
                            ),
                            Text(
                              hModel.currentLivro.status[index].date,
                              style: TextStyle(
                                color: Colors.grey[600],
                                fontSize: fontSizes[2],
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Roboto',
                              ),
                            ),
                          ],
                        ),
                      ),
                      widget.type != 0
                          ? Container(
                              height: 26,
                              child: FlatButton(
                                materialTapTargetSize:
                                    MaterialTapTargetSize.shrinkWrap,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30),
                                ),
                                padding: EdgeInsets.zero,
                                child: Container(
                                  alignment: Alignment.centerRight,
                                  padding: EdgeInsets.symmetric(horizontal: 10),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(30),
                                    color: hModel.excludedStatus[index]
                                        ? Colors.white.withOpacity(0.8)
                                        : Colors.transparent,
                                  ),
                                  child: Icon(
                                    Icons.delete_outline,
                                    size: 22,
                                    color: !hModel.excludedStatus[index]
                                        ? Colors.black
                                        : Colors.grey[300],
                                  ),
                                ),
                                onPressed: () {
                                  hModel.setExcludedStatus(index);
                                },
                              ),
                            )
                          : Text("")
                    ],
                  ),
                ),
              )
            : Text('Sem status')
      ],
    );
  }
}
