import 'package:flutter/material.dart';
import '../functions/login_functions.dart' as loginFunctions;
import '../viewModel/userProfileTab.dart';
import '../functions/instances.dart' as userInstance;

class LoginPage extends StatefulWidget {
  final ViewModel vm;
  LoginPage(this.vm);
  @override
  State<StatefulWidget> createState() {
    return new LoginPageState(vm);
  }
}

class LoginPageState extends State<LoginPage> {
  final ViewModel vm;
  bool loginMode = true;
  LoginPageState(this.vm);

  Widget build(BuildContext context) {
    return Material(
      child: Scaffold(
        resizeToAvoidBottomPadding: true,
        body: Container(
          child: ListView(
            children: <Widget>[
              GestureDetector(
                onTap: () =>
                    FocusScope.of(context).requestFocus(new FocusNode()),
                child: Container(
                  height: MediaQuery.of(context).size.height * 0.96,
                  padding: EdgeInsets.all(20.0),
                  color: Colors.blueAccent,
                  child: GestureDetector(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Image.asset(
                          'assets/images/logo.png',
                          width: 70,
                        ),
                        SizedBox(height: 10),
                        headingBox(),
                        loginWithEmailPassword(),
                        googleLoginButton(),
                        SizedBox(height: 10),
                        signUpOption(),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget signUpOption() {
    return GestureDetector(
        child: Container(
          width: double.infinity,
          child: loginMode == false ? Text(
            "New to The Project Quote? Sign Up",
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white,
              decorationStyle: TextDecorationStyle.solid,
              decoration: TextDecoration.underline,
            ),
          ) :
          Text(
            "Back to Login",
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white,
              decorationStyle: TextDecorationStyle.solid,
              decoration: TextDecoration.underline,
            ),
          ),
        ),
        onTap: () {
          if(loginMode == false) {
            setState(() {
              loginMode = true;
            });
          } else {
            setState(() {
              loginMode = false;
            });
          }
        }
    );
  }

  Widget headingBox() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget> [
        Text(
          "Hello",
          style: TextStyle(
            fontSize: 40.0,
            color: Colors.white,
          ),
        ),
        Text(
          "Quoter",
          style: TextStyle(
            fontSize: 40.0,
            color: Colors.white,
          ),
        ),
        SizedBox(
          height: 10.0,
        ),
      ],
    );
  }

  InputDecoration textFieldDecoration(String label) {
    return InputDecoration(
      labelText: label,
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
      focusedBorder: new UnderlineInputBorder(
          borderSide: BorderSide(
            color: Colors.grey ,
            width: 1.5,
            style: BorderStyle.solid,
          )
      ),
    );
  }

  Widget loginWithEmailPassword() {
    return Column(
      children: <Widget>[
        TextField(
          decoration: textFieldDecoration("EMAIL"),
        ),
        SizedBox(
          height: 10.0,
        ),
        TextField(
          decoration: textFieldDecoration("PASSWORD"),
          obscureText: true,
        ),
        loginMode == false ?
        TextField(
          decoration: textFieldDecoration("RETYPE PASSWORD"),
          obscureText: true,
        )
            :
        SizedBox(height: 0),
        SizedBox(height: 10),
        Container(
          color: Colors.white,
          width: double.infinity,
          padding: EdgeInsets.all(15.0),
          child: Center(
            child: GestureDetector(
                child: loginMode == false ?
                Text("Sign In") :
                Text("Sign Up"),
                onTap: () => print("tapped")),
          ),
        ),
        SizedBox(
          height: 10.0,
        ),
      ],
    );
  }

  Widget googleLoginButton() {
    return Container(
      color: Colors.white,
      width: double.infinity,
      padding: EdgeInsets.all(10.0),
      child: Center(
        child: GestureDetector(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Image.asset(
                'assets/images/google_icon.png',
                width: 30,
              ),
              SizedBox(width: 10.0),
              Text("Login with google"),
            ],
          ),
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
