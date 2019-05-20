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
          googleLoginButton(),
          facebookLoginButton(),
        ],
      ),
    );
  }

  Widget googleLoginButton() {
    return RaisedButton(
      child: Text("Login with google"),
      onPressed: () => loginFunctions.LoginFunctions()
          .googleLogin(vm)
          .then((_) => {
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
          .catchError((e) => print(e)),
    );
  }
}
