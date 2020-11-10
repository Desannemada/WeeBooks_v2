import 'package:flutter/material.dart';
import 'package:weebooks2/models/status.dart';

class LivroPerfilStatus extends StatelessWidget {
  LivroPerfilStatus({
    Key key,
    @required this.status,
    this.type = 0,
  }) : super(key: key);

  List<Status> status;
  final int type;

  @override
  Widget build(BuildContext context) {
    List<double> fontSizes = [];
    if (type == 0) {
      fontSizes = [17, 14, 12];
    } else {
      fontSizes = [16, 13, 11];
    }
    // status = [
    //   Status(
    //       title: 'Emprestado para Anne',
    //       date: '14/02/2018',
    //       categoria: 'Emprestado'),
    //   Status(title: 'Possuo', date: '15/08/2019', categoria: 'Possuo'),
    //   Status(title: 'Já Li', date: '15/08/2019', categoria: 'Já Li'),
    // ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        type == 0
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
        status.isNotEmpty
            ? Wrap(
                runSpacing: 10,
                spacing: 10,
                children: List.generate(
                  status.length,
                  (index) => Row(
                    mainAxisSize: MainAxisSize.min,
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
                              status[index].title,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: fontSizes[1],
                              ),
                            ),
                            Text(
                              status[index].date,
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
                      type != 0
                          ? Expanded(
                              child: Container(
                                width: 22,
                                height: 22,
                                alignment: Alignment.centerRight,
                                margin: EdgeInsets.only(left: 10),
                                child: IconButton(
                                  icon: Icon(Icons.delete_outline),
                                  iconSize: 22,
                                  padding: EdgeInsets.zero,
                                  onPressed: () {},
                                ),
                              ),
                            )
                          : Container()
                    ],
                  ),
                ),
              )
            : Text('Sem status')
      ],
    );
  }
}
