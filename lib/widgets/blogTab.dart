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
  String category;
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

  categoryChanged() {
    setState(() {
      category = CategoryHelperFunction().getDropdownValue();
    });
  }

  Stream<QuerySnapshot> buildQuery() {
    Stream<QuerySnapshot> query;
    switch (category) {
      case "TPQ Selected":
        setState(() {
          query = databaseReference.DatabaseReferences()
              .blogs
              .where("tpqSelected", isEqualTo: true)
              .orderBy('uploaded_at', descending: true)
              .snapshots();
        });
        break;

      case "Following":
        print("Following Selected");
        setState(() {
          query = databaseReference.DatabaseReferences()
              .blogs
              .where("visibleTo", arrayContains: currentUser.uid)
              .orderBy('uploaded_at', descending: true)
              .snapshots();
        });
        break;

      case "All":
        print("All Selected");
        setState(() {
          query = databaseReference.DatabaseReferences()
              .blogs
              .snapshots();
        });
        break;

      default:
        print("Test: Default");
        query = null;
        break;
    }
    return query;
  }

  @override
  Widget build(BuildContext context) {
    categoryChanged();
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: currentUser == null
              ? Container(
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                )
              : Container(
                  child: Column(
                    children: <Widget>[
                      CategoryDropdown(
                        notifyParent: categoryChanged,
                      ),
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
      print("Query is null");
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
              print("Waiting for blogs to be loaded.");
              return Center(
                child: CircularProgressIndicator(),
              );
              break;
            default:
              if (snapshots.data.documents.length == 0) {
                return Center(
                  child: Container(
                    child: Text(
                      "No blogs to show",
                      style: TextStyle(
                        color: Colors.white,
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
                        Center(
                          child: Container(
                            width: MediaQuery.of(context).size.width / 2,
                            child: index + 1 >= snapshots.data.documents.length
                                ? null
                                : Divider(
                                    color: Color.fromRGBO(255, 255, 255, 0.5),
                                  ),
                          ),
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
