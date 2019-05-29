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
          padding: EdgeInsets.all(20.0),
          color: Colors.black,
          child: GestureDetector(
            onTap: () => FocusScope.of(context).requestFocus(new FocusNode()),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text("Hello",
                  style: TextStyle(
                    fontSize: 40.0,
                    color: Colors.white,
                  ),
                ),
                Text("Quoter",
                  style: TextStyle(
                    fontSize: 40.0,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 20.0,),
                loginWithEmailPassword(),
                googleLoginButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget loginWithEmailPassword() {
    return Column(
        children: <Widget>[
          TextField(
            decoration: InputDecoration(
              labelText: "EMAIL",
              fillColor: Colors.white,
              labelStyle: TextStyle(
                color: Colors.white,
              ),
              enabledBorder: new UnderlineInputBorder(
                borderSide: BorderSide(
                  color: Colors.white,
                  width: 1.0,
                  style: BorderStyle.solid,
                ),
              ),
            ),
          ),
          SizedBox(height: 10.0,),
          TextField(
            decoration: InputDecoration(
              labelText: "PASSWORD",
              fillColor: Colors.white,
              labelStyle: TextStyle(
                color: Colors.white,
              ),
              enabledBorder: new UnderlineInputBorder(
                borderSide: BorderSide(
                  color: Colors.white,
                  width: 1.0,
                  style: BorderStyle.solid,
                ),
              ),
            ),
            obscureText: true,
          ),
          SizedBox(height: 10.0,),
          Container(
            color: Colors.white,
            width: double.infinity,
            padding: EdgeInsets.all(15.0),
            child: Center(
              child: GestureDetector(
                child: Text("Sign Up"),
                onTap: () => loginFunctions.LoginFunctions()
                    .googleLogin(vm)
                    .then((user) => {
                  userInstance.UserInstance.user = user,
                  vm.changeLoginState(true),
                  vm.changeLoadingState(false),
                })
                    .catchError((e) => print(e)),
              ),
            ),
          ),
          SizedBox(height: 10.0,),
        ],
    );
  }

  Widget googleLoginButton() {
    return Container(
      color: Colors.white,
      width: double.infinity,
      padding: EdgeInsets.all(15.0),
      child: Center(
        child: GestureDetector(
          child: Text("Login with google"),
          onTap: () => loginFunctions.LoginFunctions()
              .googleLogin(vm)
              .then((user) => {
                    userInstance.UserInstance.user = user,
                    vm.changeLoginState(true),
                    vm.changeLoadingState(false),
                  })
              .catchError((e) => print(e)),
        ),
      ),
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
