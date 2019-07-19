import 'package:flutter/material.dart';
import '../functions/login_functions.dart' as loginFunctions;
import 'package:firebase_auth/firebase_auth.dart';
import '../pages/login_page.dart';
import '../database/databaseReferences.dart' as databaseReference;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:strings/strings.dart';

class UserProfileTab extends StatefulWidget {
  UserProfileTab();

  UserProfileTabState createState() => UserProfileTabState();
}

class UserProfileTabState extends State<UserProfileTab> {
  FirebaseUser currentUser;

  @override
  void initState() {
    super.initState();
    getCurrentUser();
  }

  void getCurrentUser() async {
    FirebaseUser user = await FirebaseAuth.instance.currentUser();
    setState(() {
      currentUser = user;
    });
  }

  double rowHeight = 45;

  Widget build(BuildContext context) {
    if(currentUser == null) {
      return new Container(
        width: MediaQuery.of(context).size.width,
        child: Center(
          child: CircularProgressIndicator(),
        ),
      );
    } else {
      return Container(
        color: Colors.white,
        padding: EdgeInsets.only(left: 10.0, top: 10.0, right: 10.0),
        child: StreamBuilder<QuerySnapshot>(
            stream: databaseReference
                .DatabaseReferences()
                .userDatabaseReference
                .where("uid", isEqualTo: currentUser.uid)
                .limit(1)
                .snapshots(),
            builder: (BuildContext context,
                AsyncSnapshot<QuerySnapshot> query) {
              if (query.connectionState == ConnectionState.waiting) {
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
                DocumentSnapshot snapshot = query.data.documents[0];
                return new ListView(
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        profilePicture(snapshot["profilePictureUrl"]),
                        Padding(
                          padding: EdgeInsets.only(left: 20),
                          child: Column(
                            children: <Widget>[
                              Container(
                                height: 30,
                                child: Center(
                                  child: Text(
                                    camelize(snapshot["name"]),
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
                            snapshot["posts"] == null ? "0" : snapshot["posts"]
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
                            snapshot["followers"] == null
                                ? "0"
                                : snapshot["followers"].toString(),
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
                            snapshot["followings"] == null
                                ? "0"
                                : snapshot["followings"].toString(),
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
                            snapshot["email"],
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
                      onPressed: () =>
                          loginFunctions.LoginFunctions()
                              .logout()
                              .then((_) =>
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => LoginPage()))),
                    ),
                  ],
                );
              }
            }),
      );
    }
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
