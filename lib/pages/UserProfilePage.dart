import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../database/databaseReferences.dart' as databaseReference;
import 'package:strings/strings.dart';

class UserProfilePage extends StatefulWidget {
  final String documentID;
  UserProfilePage(this.documentID);

  @override
  UserProfilePageState createState() => UserProfilePageState();
}

class UserProfilePageState extends State<UserProfilePage> {
  double rowHeight = 45;
  UserProfilePageState();
  Widget build(BuildContext context) {
    return Material(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.red,
            actions: <Widget>[
            Icon(Icons.arrow_drop_down),
          ],
        ),
        body: Container(
          color: Colors.white,
          padding: EdgeInsets.only(left: 10.0, top: 10.0, right: 10.0),
          child: FutureBuilder<DocumentSnapshot>(
              future: databaseReference
                  .DatabaseReferences()
                  .users
              .document(widget.documentID)
              .get(),
              builder: (BuildContext context,
                  AsyncSnapshot<DocumentSnapshot> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return new Container(
                    width: MediaQuery
                        .of(context)
                        .size
                        .width,
                    child: Center(
                      child: CircularProgressIndicator(),
                    ),
                  );
                } else {
                  return new ListView(
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          profilePicture(snapshot.data["profilePictureUrl"]),
                          Padding(
                            padding: EdgeInsets.only(left: 20),
                            child: Column(
                              children: <Widget>[
                                Container(
                                  height: 30,
                                  child: Center(
                                    child: Text(
                                      camelize(snapshot.data["name"]),
                                      style: TextStyle(
                                        color: Colors.green,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 10.0),
                        height: rowHeight,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text(
                              "username",
                            ),
                            Text(
                              "Change",
                              style: TextStyle(
                                color: Colors.blue,
                                decoration: TextDecoration.underline,
                              ),
                              textAlign: TextAlign.right,
                            ),
                          ],
                        ),
                      ),
                      Container(
                        height: rowHeight,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text(
                              "posts",
                            ),
                            Text(
                              snapshot.data["posts"] == null ? "0" : snapshot.data["posts"]
                                  .toString(),
                              style: TextStyle(),
                              textAlign: TextAlign.right,
                            ),
                          ],
                        ),
                      ),
                      Container(
                        height: rowHeight,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text(
                              "followers",
                            ),
                            Text(
                              snapshot.data["followers"] == null
                                  ? "0"
                                  : snapshot.data["followers"].toString(),
                              style: TextStyle(),
                              textAlign: TextAlign.right,
                            ),
                          ],
                        ),
                      ),
                      Container(
                        height: rowHeight,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text(
                              "followings",
                            ),
                            Text(
                              snapshot.data["followings"] == null
                                  ? "0"
                                  : snapshot.data["followings"].toString(),
                              style: TextStyle(),
                              textAlign: TextAlign.right,
                            ),
                          ],
                        ),
                      ),
                      Container(
                        height: rowHeight,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text(
                              "Email",
                            ),
                            Text(
                              snapshot.data["email"],
                              style: TextStyle(),
                              textAlign: TextAlign.right,
                            ),
                          ],
                        ),
                      ),
                    ],
                  );
                }
              }),
        ),
      ),
    );
  }

  Widget profilePicture(String photoUrl) {
    return Container(
      width: 50,
      height: 50,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        image: new DecorationImage(
          fit: BoxFit.fill,
          image: new NetworkImage(photoUrl),
        ),
      ),
    );
  }
}