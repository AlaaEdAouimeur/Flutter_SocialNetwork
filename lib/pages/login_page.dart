import 'package:flutter/material.dart';
import '../functions/login_functions.dart' as loginFunctions;
import '../viewModel/userProfileTab.dart';
import '../functions/instances.dart' as userInstance;

class LoginPage extends StatelessWidget {
  final ViewModel vm;
  LoginPage(this.vm);

  Widget build(BuildContext context) {
    return Material(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            loginWithEmailPassword(),
            googleLoginButton(),
          ],
        ),
      ),
    );
  }

  Widget loginWithEmailPassword() {
    return Column(
        children: <Widget>[
          RaisedButton(
            child: Text("Sign Up"),
            onPressed: () => print("pressed"),
          ),
        ],
      );
  }

  Widget googleLoginButton() {
    return RaisedButton(
      child: Text("Login with google"),
      onPressed: () => loginFunctions.LoginFunctions()
          .googleLogin(vm)
          .then((user) => {
                userInstance.UserInstance.user = user,
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
          .loginWithFacebook(vm)
          .then((_) => {
                vm.changeLoginState(true),
                vm.changeLoadingState(false),
              })
          .catchError((e) => {
                print(e),
                vm.changeLoadingState(false),
              }),
    );
  }
}
