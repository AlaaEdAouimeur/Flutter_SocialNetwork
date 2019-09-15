import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:redux_example/widgets/PostList.dart';
import '../database/databaseReferences.dart' as databaseReference;

class Userpostlist extends StatelessWidget {
  final String title;
  final DocumentSnapshot snapshot;
  Userpostlist({this.title, this.snapshot});

  @override
  Widget build(BuildContext context) {
    return Material(
      child: SafeArea(
        child: Column(
          children: <Widget>[
            new SearchBox(),
            postsList(),
          ],
        ),
      ),
    );
  }

  Expanded postsList() => Expanded(child: streamBuilder());

  Widget streamBuilder() {
    Stream<QuerySnapshot> query = databaseReference.DatabaseReferences()
        .posts
        .where("uid", isEqualTo: this.snapshot["uid"])
        .snapshots();
    if (query == null) {
      print("Query is null");
      return new Container(
        child: Container(
          color: Colors.black,
          child: Center(
            child: CircularProgressIndicator(),
          ),
        ),
      );
    } else {
      return StreamBuilder<QuerySnapshot>(
          stream: query,
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.waiting:
                return new Container(
                  width: MediaQuery.of(context).size.width,
                  child: Container(
                    color: Colors.black,
                    child: Center(
                      child: CircularProgressIndicator(),
                    ),
                  ),
                );
                break;

              default:
                if (snapshot.data.documents.length == 0) {
                  return Container(
                    color: Colors.black,
                    child: Center(
                      child: Container(
                        child: Text(
                          "No posts yet.",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  );
                } else {
                  return Column(
                    children: <Widget>[
                      Expanded(
                        child: Container(
                          height: 400,
                          color: Color.fromRGBO(7, 8, 11, 1),
                          child: PostList(snapshot),
                        ),
                      ),
                    ],
                  );
                }
                break;
            }
          });
    }
  }
}

class SearchBox extends StatelessWidget {
  const SearchBox({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      child: TextField(
        decoration: InputDecoration(
    filled: true,
    fillColor: Colors.white,
    hintText: "Search posts",
    prefixIcon: Icon(
      Icons.search,
      color: Colors.grey,
    ),
    //  disabledBorder: b,
    border: OutlineInputBorder(
        borderSide: BorderSide.none,
        borderRadius: BorderRadius.all(Radius.circular(15.0)))),
      ),
    );
  }
}
