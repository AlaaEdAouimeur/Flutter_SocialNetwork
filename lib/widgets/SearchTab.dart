import 'package:flutter/material.dart';
import '../database/databaseReferences.dart' as databaseReference;
import 'package:cloud_firestore/cloud_firestore.dart';

class SearchTab extends StatefulWidget {
  SearchTab({Key key}) : super(key: key);

  @override
  SearchTabState createState() => SearchTabState();
}

class SearchTabState extends State<SearchTab> {
  double widthOfContainer;

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
              child: categoryList(widthOfContainer),
            ),
          ],
        ),
      ),
    );
  }
}

Widget categoryList(double widthOfContainer) {
  return StreamBuilder<QuerySnapshot>(
      stream: databaseReference.DatabaseReferences()
          .categoryDatabaseReference
          .snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.waiting:
            return new Container(
              width: widthOfContainer,
              child: Center(
                child: CircularProgressIndicator(),
              ),
            );
            break;
          default:
            return new ListView.builder(
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                itemCount: snapshot.data.documents.length,
                itemBuilder: (context, index) {
                  return categoryListBuilder(snapshot.data.documents[index]);
                });
            break;
        }
      });
}

Widget categoryListBuilder(DocumentSnapshot snapshot) {
  return new Container(
    child: Text(snapshot["category_name"]),
  );
}

class UserSearch extends SearchDelegate<String> {
  final sampleData = [
    "Sample Data",
    "Sample Data",
    "Sample Data",
    "Sample Data",
    "Sample Data",
    "Sample Data",
    "Sample Data",
    "Sample Data",
    "Sample Data",
    "Sample Data",
    "Sample Data",
  ];

  final suggestion = [
    "suggestion",
    "suggestion",
    "suggestion",
  ];

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
    return null;
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    // TODO: implement buildSuggestions
    final suggestionList = query.isEmpty ? suggestion : sampleData;
    return ListView.builder(
      itemBuilder: (context, index) => ListTile(
            leading: Icon(Icons.share),
            title: Text(suggestionList[index]),
          ),
      itemCount: suggestionList.length,
    );
  }
}
