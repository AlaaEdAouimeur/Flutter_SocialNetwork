import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../database/databaseReferences.dart' as databaseReference;
import 'BlogIntro.dart';

class BlogTab extends StatefulWidget {
  @override
  _BlogTabState createState() => _BlogTabState();
}

class _BlogTabState extends State<BlogTab> {
  FirebaseUser currentUser;

  @override
  void initState() {
    FirebaseAuth.instance.currentUser().then((user) {
      setState(() {
        currentUser = user;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          color: Colors.black,
          child: currentUser == null
              ? Container(
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                )
              : blogList(),
        ),
      ),
    );
  }

  Widget blogList() {
    return StreamBuilder(
      stream: databaseReference.DatabaseReferences().blogs.orderBy('uploaded_at', descending: true).snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshots) {
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
                    "That's all for today.",
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
