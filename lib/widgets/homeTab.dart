import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../database/databaseReferences.dart' as databaseReference;
import 'PostList.dart';
import '../widgets/CategoryDropdown.dart';
import 'package:firebase_auth/firebase_auth.dart';

class DropdownValueHolder {
  static String dropdownValue = "TPQ Selected";
}

class HomeTab extends StatefulWidget {
  String getDropdownValue() {
    return DropdownValueHolder.dropdownValue;
  }

  void setDropdownValue(String dropdownValue) {
    DropdownValueHolder.dropdownValue = dropdownValue;
  }

  @override
  _HomeTabState createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> {
  ScrollController scrollController;
  String category;
  Stream<QuerySnapshot> query;
  FirebaseUser currentUser;

  @override
  void initState() {
    super.initState();
    FirebaseAuth.instance.currentUser().then((user) => setCurrentUser(user));
    category = "Following";
  }

  @override
  void dispose() {
    super.dispose();
  }

  setCurrentUser(user) {
    setState(() {
      currentUser = user;
    });
  }

  categoryChanged() {
    setState(() {
      category = CategoryHelperFunction().getDropdownValue();
    });
  }

  Widget build(BuildContext context) {
    categoryChanged();
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      body: SafeArea(
        child: currentUser == null
            ? Container(
                width: MediaQuery.of(context).size.width,
                child: Container(
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                ),
              )
            : Container(
                child: Column(
                  children: <Widget>[
                    CategoryDropdown(notifyParent: categoryChanged),
                    Flexible(
                      child: streamBuilder(),
                    ),
                  ],
                ),
              ),
      ),
    );
  }

  Stream<QuerySnapshot> buildQuery() {
    Stream<QuerySnapshot> query;
    switch (category) {
      case "TPQ Selected":
        setState(() {
          query = databaseReference.DatabaseReferences()
              .posts
              .where("tpqSelected", isEqualTo: true)
              .orderBy('createdAt', descending: true)
              .snapshots();
        });
        break;

      case "Following":
        setState(() {
          query = databaseReference.DatabaseReferences()
              .posts
              .where("visibleTo", arrayContains: currentUser.uid)
              .orderBy('createdAt', descending: true)
              .snapshots();
        });
        break;

      case "All":
        setState(() {
          query = databaseReference.DatabaseReferences()
              .posts
              .orderBy('createdAt', descending: true)
              .snapshots();
        });
        break;

      default:
        query = null;
        break;
    }
    return query;
  }

  Widget streamBuilder() {
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
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.waiting:
                return new Container(
                  width: MediaQuery.of(context).size.width,
                  child: Container(
                    child: Center(
                      child: CircularProgressIndicator(),
                    ),
                  ),
                );
                break;

              default:
                if (snapshot.data.documents.length == 0) {
                  return Container(
                    child: Center(
                      child: Container(
                        child: Text(
                          "Nothing To Show\nChoose Another Category",
                          style: TextStyle(
                            color: Theme.of(context).accentColor,
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
