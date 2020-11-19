import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weebooks2/_view_models/home_view_model.dart';
import 'package:weebooks2/services/google_books.dart';
import 'package:weebooks2/ui/components/livro/livroWidget.dart';
import 'package:weebooks2/ui/shared/loading.dart';
import 'package:weebooks2/values/icons.dart';
import 'package:weebooks2/values/values.dart';

class Search extends SearchDelegate {
  ThemeData appBarTheme(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return theme.copyWith(
      primaryColor: Theme.of(context).primaryColor,
      primaryIconTheme: IconThemeData(color: Colors.white),
      primaryTextTheme: Theme.of(context).textTheme,
      cursorColor: Theme.of(context).cursorColor,
      inputDecorationTheme: Theme.of(context).inputDecorationTheme,
    );
  }

  @override
  // String get searchFieldLabel => 'Encontre livros, fics, pessoas e grupos...';
  String get searchFieldLabel => 'Encontre livros...';

  @override
  TextStyle get searchFieldStyle => TextStyle(color: Colors.white);

  @override
  List<Widget> buildActions(BuildContext context) {
    return <Widget>[
      IconButton(
        icon: Icon(Icons.close),
        onPressed: () => query = "",
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () => Navigator.of(context).pop(),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    if (query.isEmpty) return buildSuggestions(context);
    final hmodel = Provider.of<HomeViewModel>(context);

    int queryLen = query.length;
    int currentIndex = 0;
    bool isSugestion = false;
    if (queryLen >= 3 &&
        query.substring(queryLen - 3, queryLen).contains('s=')) {
      currentIndex = int.parse(query.substring(queryLen - 1));
      query = query.substring(0, queryLen - 3);
      isSugestion = true;
    }

    return DefaultTabController(
      length: 1,
      child: Builder(
        builder: (context) {
          final TabController tabController = DefaultTabController.of(context);
          if (isSugestion && currentIndex != 0) {
            tabController.animateTo(currentIndex);
          }
          return Column(
            children: [
              Container(
                height: 50,
                child: TabBar(
                  labelColor: Colors.black,
                  indicatorColor: secondaryPink,
                  unselectedLabelColor: Colors.grey[500],
                  tabs: [
                    Tab(text: 'Livros'),
                    // Tab(text: 'Fics'),
                    // Tab(text: 'Pessoas'),
                    // Tab(text: 'Grupos'),
                  ],
                ),
              ),
              Expanded(
                child: TabBarView(
                  physics: NeverScrollableScrollPhysics(),
                  children: [
                    FutureBuilder(
                      future: GoogleBooks().buscaDeLivro(query, context),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Loading(opacity: false, color: primaryCyan);
                        } else if (snapshot.hasData) {
                          return ListView.separated(
                            shrinkWrap: true,
                            itemCount: snapshot.data.length,
                            separatorBuilder: (context, index) => Divider(
                              color: Colors.grey[400],
                              indent: 20,
                              endIndent: 20,
                              height: 2,
                            ),
                            itemBuilder: (context, index) =>
                                LivroWidget(livro: snapshot.data[index]),
                          );
                        } else if (snapshot.data == null) {
                          return Center(
                            child: Text(
                              'Sem resultados!',
                              style: TextStyle(fontSize: 16),
                            ),
                          );
                        } else if (snapshot.hasError) {
                          return Center(
                            child: Text(
                              'Ocorreu um erro, tente novamente mais tarde!',
                              style: TextStyle(fontSize: 16),
                            ),
                          );
                        }
                      },
                    ),
                    // EmDesenvolvimento(),
                    // EmDesenvolvimento(),
                    // EmDesenvolvimento(),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    List options = [
      [WeeBooks.cBook, 'em Livros'],
      // [WeeBooks.cFic, 'em Fics'],
      // [Icons.account_circle, 'em Pessoas'],
      // [Icons.group, 'em Grupos'],
    ];

    return Padding(
      padding: EdgeInsets.symmetric(vertical: 20, horizontal: 5),
      child: ListView.builder(
        itemCount: options.length,
        itemBuilder: (context, index) => Column(
          children: [
            FlatButton(
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              padding: EdgeInsets.zero,
              child: Padding(
                padding: EdgeInsets.all(10),
                child: Row(
                  children: [
                    Icon(
                      options[index][0],
                      color: primaryCyan.withOpacity(0.8),
                      size: 32,
                    ),
                    SizedBox(width: 10),
                    Row(
                      children: [
                        Text(
                          query,
                          style:
                              TextStyle(fontSize: 16, color: Colors.grey[500]),
                        ),
                        Text(
                          ' ' + options[index][1],
                          style:
                              TextStyle(fontSize: 16, color: Colors.grey[800]),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              onPressed: () {
                if (query.isNotEmpty) {
                  query = query + 's=$index';
                  showResults(context);
                }
              },
            ),
            Divider(),
          ],
        ),
      ),
    );
  }
}
