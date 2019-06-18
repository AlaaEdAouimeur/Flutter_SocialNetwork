import 'package:flutter/material.dart';
import '../functions/login_functions.dart' as loginFunctions;
import 'package:firebase_auth/firebase_auth.dart';

class UserProfileTab extends StatefulWidget {
  UserProfileTab();

  UserProfileTabState createState() => UserProfileTabState();
}

class UserProfileTabState extends State<UserProfileTab> {
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: FirebaseAuth.instance.currentUser(),
        builder: (BuildContext context, AsyncSnapshot<FirebaseUser> user) {
          if (user.hasData) {
            if (user.data != null) {
              return new Column(
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(left: 20),
                    child: Row(
                      children: <Widget>[
                        Container(
                          width: 60,
                          height: 60,
                          color: Colors.red,
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: 20),
                          child: Column(
                            children: <Widget>[
                              Container(
                                height: 30,
                                child: Center(
                                  child: Text(user.data.displayName),
                                ),
                              ),
                              Container(
                                height: 30,
                                child: Center(
                                  child: Text("Username"),
                                ),
                              ),
                              RaisedButton(
                                child: Text("Logout"),
                                onPressed: () =>
                                    loginFunctions.LoginFunctions().logout(),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Column(
                    children: <Widget>[
                      Text(user.data.uid),
                      Text(user.data.providerId),
                      Text(user.data.isEmailVerified.toString()),
                      Text(user.data.email),
                      Text(user.data.photoUrl),
                      Text(user.data.displayName),
                    ],
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
        });
  }

  Widget logoutButton() {
    return RaisedButton(
      child: Text("Logout"),
      onPressed: () => loginFunctions.LoginFunctions().logout(),
    );
  }
}
