import 'package:flutter/material.dart';
import '../functions/login_functions.dart' as loginFunctions;
import '../viewModel/userProfileTab.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserProfile extends StatefulWidget {
  final ViewModel vm;
  UserProfile(this.vm);
  UserProfileState createState() => UserProfileState(vm);
}

class UserProfileState extends State<UserProfile> {
  final ViewModel vm;
  UserProfileState(this.vm);
  FirebaseUser user;

  Widget build(BuildContext context) {
    return Column(
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
                        child: Text(user.displayName),
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
                      onPressed: () => loginFunctions.LoginFunctions()
                          .logout(vm)
                          .then((_) => {
                                vm.changeLoginState(false),
                                vm.changeLoadingState(false),
                              }),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        Column(
          children: <Widget>[
            Text(user.uid),
            Text(user.providerId),
            Text(user.isEmailVerified.toString()),
            Text(user.email),
            Text(user.photoUrl),
            Text(user.displayName),
          ], 
        ),
      ],
    );
  }

  Widget logoutButton() {
    return RaisedButton(
        child: Text("Logout"),
        onPressed: () =>
            loginFunctions.LoginFunctions().logout(vm).then((_) => {
                  vm.changeLoginState(false),
                  vm.changeLoadingState(false),
                }));
  }
}
