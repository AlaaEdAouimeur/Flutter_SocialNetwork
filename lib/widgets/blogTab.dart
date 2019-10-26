import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:redux_example/widgets/CategoryDropdown.dart';
import '../database/databaseReferences.dart' as databaseReference;
import 'BlogIntro.dart';

class BlogTab extends StatefulWidget {
  @override
  _BlogTabState createState() => _BlogTabState();
}

class _BlogTabState extends State<BlogTab> {
  FirebaseUser currentUser;
  Stream query;
  @override
  void initState() {
    FirebaseAuth.instance.currentUser().then((user) {
      setState(() {
        currentUser = user;
      });
    });
    super.initState();
  }

  Stream<QuerySnapshot> buildQuery() {
    Stream<QuerySnapshot> query;
    setState(() {
      query = databaseReference.DatabaseReferences().blogs.snapshots();
    });
    return query;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: currentUser == null
              ? Container(
                  color: Theme.of(context).backgroundColor,
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                )
              : Container(
                  color: Theme.of(context).backgroundColor,
                  child: Column(
                    children: <Widget>[
                      Flexible(
                        child: blogList(),
                      ),
                    ],
                  ),
                ),
        ),
      ),
    );
  }

  Widget blogList() {
    query = buildQuery();
    if (query == null) {
      return new Container(
        width: MediaQuery.of(context).size.width,
        child: Container(
          child: Center(
            child: CircularProgressIndicator(),
          ),
        ),
      );
    } else {
      return StreamBuilder<QuerySnapshot>(
        stream: query,
        builder:
            (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshots) {
          switch (snapshots.connectionState) {
            case ConnectionState.waiting:
              return Center(
                child: CircularProgressIndicator(),
              );
              break;
            default:
              if (snapshots.data.documents.length == 0) {
                return Center(
                  child: Container(
                    color: Theme.of(context).backgroundColor,
                    child: Text(
                      "No blogs to show",
                      style: TextStyle(
                        color: Theme.of(context).accentColor,
                        fontSize: 24,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                );
              } else {
                return ListView.builder(
                  itemCount: snapshots.data.documents.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          margin: EdgeInsets.all(25.0),
                          child: BlogIntro(
                              snapshot: snapshots.data.documents[index]),
                        ),
                      ],
                    );
                  },
                );
              }
              break;
          }
        },
      );
    }
  }
}
