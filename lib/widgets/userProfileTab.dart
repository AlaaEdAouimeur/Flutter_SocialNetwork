import 'package:flutter/material.dart';
import '../functions/login_functions.dart' as loginFunctions;
import 'package:firebase_auth/firebase_auth.dart';
import '../pages/login_page.dart';
import '../database/databaseReferences.dart' as databaseReference;
import 'package:cloud_firestore/cloud_firestore.dart';

class UserProfileTab extends StatefulWidget {
  UserProfileTab();

  UserProfileTabState createState() => UserProfileTabState();
}

class UserProfileTabState extends State<UserProfileTab> {
  FirebaseUser currentUser;

  @override
  void initState() {
    super.initState();
    FirebaseAuth.instance.currentUser().then((user) => currentUser = user);
  }

  double rowHeight = 45;

  Future<DocumentSnapshot> getDocumentFromQuery() {

  }
  Widget build(BuildContext context) {
    print("UID : " + currentUser.uid);
    return Container(
      color: Colors.white,
      padding: EdgeInsets.only(left: 10.0, top: 10.0, right: 10.0),
      child: FutureBuilder(
          future: databaseReference.DatabaseReferences()
              .userDatabaseReference
              .where("uid", isEqualTo: currentUser.uid)
              .limit(1)
              .getDocuments(),
          builder: (BuildContext context, AsyncSnapshot query) {
            DocumentSnapshot snapshot = await getDocumentFromQuery();
            if (snapshot.hasData) {
              if (snapshot.data != null) {
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
                                    snapshot.data["name"],
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
                            snapshot.data["posts"],
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
                            "10",
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
                            "following",
                          ),
                          Text(
                            "15",
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
                    Container(
                      height: rowHeight,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(
                            "Location",
                          ),
                          Text(
                            "Delhi",
                            style: TextStyle(),
                            textAlign: TextAlign.right,
                          ),
                        ],
                      ),
                    ),
                    RaisedButton(
                      child: Text("Logout"),
                      onPressed: () => loginFunctions.LoginFunctions()
                          .logout()
                          .then((_) => Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => LoginPage()))),
                    ),
                  ],
                );
              } else {
                return new CircularProgressIndicator(
                  backgroundColor: Colors.green,
                );
              }
            } else {
              return Container(
                child: Center(
                  child: new CircularProgressIndicator(
                    backgroundColor: Colors.red,
                  ),
                ),
              );
            }
          }),
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

  Widget logoutButton() {
    return RaisedButton(
      child: Text("Logout"),
      onPressed: () => loginFunctions.LoginFunctions().logout(),
    );
  }
}
