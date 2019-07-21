import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../HelperClasses/SearchTabHelperClass.dart';

class SearchTab extends StatefulWidget {
  SearchTab({Key key}) : super(key: key);

  @override
  SearchTabState createState() => SearchTabState();
}

class SearchTabState extends State<SearchTab> {
  double widthOfContainer;
  static FirebaseUser currentUser;
  SearchTabHelperClass helperClass = new SearchTabHelperClass();

  @override
  void initState() {
    super.initState();
  }

  Widget build(BuildContext context) {
    widthOfContainer = MediaQuery.of(context).size.width;
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: <Widget>[
            Center(
              child: Container(
                height: 40,
                width: widthOfContainer,
                margin: EdgeInsets.all(10.0),
                padding: EdgeInsets.all(10.0),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.black12,
                    style: BorderStyle.solid,
                    width: 1.0,
                  ),
                  borderRadius: BorderRadius.all(
                    Radius.circular(5),
                  ),
                ),
                child: GestureDetector(
                  child: Text("Search"),
                  onTap: () =>
                      showSearch(context: context, delegate: UserSearch()),
                ),
              ),
            ),
            Flexible(
              child: helperClass.categoryList(widthOfContainer),
            ),
          ],
        ),
      ),
    );
  }
}

class UserSearch extends SearchDelegate<String> {
  SearchTabHelperClass helperClass = new SearchTabHelperClass();
  FirebaseUser currentUser = SearchTabState.currentUser;

  @override
  List<Widget> buildActions(BuildContext context) {
    // TODO: implement buildActions
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = "";
        },
      )
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    // TODO: implement buildLeading
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    // TODO: implement buildResults
    return Container(
      child: Text("Build result"),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    // TODO: implement buildSuggestions
    return Container(
      child: helperClass.suggestionList(query),
    );
  }
}
