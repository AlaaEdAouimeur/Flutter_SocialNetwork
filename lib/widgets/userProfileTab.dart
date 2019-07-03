import 'package:flutter/material.dart';
import '../functions/login_functions.dart' as loginFunctions;
import 'package:firebase_auth/firebase_auth.dart';
import '../pages/login_page.dart';

class UserProfileTab extends StatefulWidget {
  UserProfileTab();

  UserProfileTabState createState() => UserProfileTabState();
}

class UserProfileTabState extends State<UserProfileTab> {
  double rowHeight = 45;
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.only(left: 10.0, top: 10.0, right: 10.0),
      child: FutureBuilder(
          future: FirebaseAuth.instance.currentUser(),
          builder: (BuildContext context, AsyncSnapshot<FirebaseUser> user) {
            if (user.hasData) {
              if (user.data != null) {
                return new ListView(
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        profilePicture(user.data.photoUrl),
                        Padding(
                          padding: EdgeInsets.only(left: 20),
                          child: Column(
                            children: <Widget>[
                              Container(
                                height: 30,
                                child: Center(
                                  child: Text(
                                    user.data.displayName,
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
                            "1",
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
                            user.data.email,
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
