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
        heightFactor: 0.5,
        child: Container(
          color: Colors.black,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              loginWithEmailPassword(),
              googleLoginButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget loginWithEmailPassword() {
    return Container(
      color: Color.fromRGBO(255, 255, 255, 1),
      child: Column(
        children: <Widget>[
          TextField(
            decoration: InputDecoration(
              labelText: "EMAIL"
            ),
          ),
          RaisedButton(
            child: Text("Sign Up"),
            onPressed: () => print("pressed"),
          ),
        ],
      ),
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
