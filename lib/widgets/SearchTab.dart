import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../HelperClasses/SearchTabHelperClass.dart';
import '../database/databaseReferences.dart' as databaseReference;

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
      backgroundColor: Colors.black,
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
                  child: Text("Search", style: TextStyle(color: Colors.white),),
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

  Widget categoryList(double widthOfContainer) {
    return StreamBuilder<QuerySnapshot>(
        stream: databaseReference.DatabaseReferences().category.snapshots(),
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
              return Container(
                padding: EdgeInsets.all(10.0),
                child: new ListView.builder(
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    itemCount: snapshot.data.documents.length,
                    itemBuilder: (context, index) {
                      return categoryListBuilder(
                          snapshot.data.documents[index]);
                    },),
              );
              break;
          }
        },);
  }

  Widget categoryListBuilder(DocumentSnapshot snapshot) {
    return new Container(
      margin: EdgeInsets.only(bottom: 15.0),
      padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 5.0),
      decoration: BoxDecoration(
        border: Border.all(
          color: Color.fromRGBO(255, 255, 255, 0.3),
        ),
        borderRadius: BorderRadius.circular(5.0),
      ),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          "TOP ${snapshot['category_name'].toString().toUpperCase()}",
          textAlign: TextAlign.start,
          style: TextStyle(color: Colors.white),
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
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return Container(
      child: Text("Build result"),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return Container(
      child: helperClass.suggestionList(query),
    );
  }
}
