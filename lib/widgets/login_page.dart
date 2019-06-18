import 'package:flutter/material.dart';
import '../functions/login_functions.dart' as loginFunctions;
import '../viewModel/userProfileTab.dart';

class LoginPage extends StatelessWidget {
  final ViewModel vm;
  LoginPage(this.vm);

  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text("You are not logged in"),
          Text("Login to track your profile"),
          googleLoginButton(context),
        ],
      ),
    );
  }

  Widget showAlertBox() {
    return AlertDialog(
      title: Text(
          "Account already exist with same email. Try logging in with google."),
      actions: <Widget>[
        FlatButton(
          child: Text("Okay"),
          onPressed: () => {print("Button Pressed")},
        ),
      ],
    );
  }

  Widget googleLoginButton(BuildContext context) {
    return RaisedButton(
      child: Text("Login with google"),
      onPressed: () => loginFunctions.LoginFunctions()
          .googleLogin()
          .then((user) => {
                vm.changeLoginState(true),
                vm.changeLoadingState(false),
              })
          .catchError((e) => print(e)),
    );
  }

  Widget facebookLoginButton() {
    return RaisedButton(
      child: Text("Login with facebook"),
      onPressed: () => loginFunctions.LoginFunctions()
          .loginWithFacebook()
          .then((_) => {
                vm.changeLoginState(true),
                vm.changeLoadingState(false),
              })
          .catchError((e) => {
                print(e),
                showAlertBox(),
                vm.changeLoadingState(false),
              }),
    );
  }
}
