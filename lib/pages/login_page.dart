import 'package:flutter/material.dart';
import '../functions/login_functions.dart' as loginFunctions;
import 'package:firebase_auth/firebase_auth.dart';
import '../database/databaseReferences.dart' as databaseReferences;
import 'home_page.dart';
import 'package:firebase_database/firebase_database.dart';

class LoginPage extends StatefulWidget {
  LoginPage();

  @override
  State<StatefulWidget> createState() {
    return new LoginPageState();
  }
}

class LoginPageState extends State<LoginPage> {
  bool loginMode = true;

  LoginPageState();

  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final retypePasswordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    retypePasswordController.dispose();
    super.dispose();
  }

  Widget build(BuildContext context) {
    return Material(
      child: Scaffold(
        body: Container(
          child: ListView(
            children: <Widget>[
              GestureDetector(
                onTap: () =>
                    FocusScope.of(context).requestFocus(new FocusNode()),
                child: Container(
                  height: MediaQuery.of(context).size.height * 0.96,
                  padding: EdgeInsets.all(20.0),
                  color: Colors.teal,
                  child: GestureDetector(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Image.asset(
                          'assets/images/logo.png',
                          width: 50,
                        ),
                        SizedBox(height: 10),
                        headingBox(),
                        loginWithEmailPassword(context),
                        googleLoginButton(context),
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

  void showDialogBox(BuildContext context) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return Container(
            child: Center(
              child: CircularProgressIndicator(),
            ),
          );
        });
  }

  void hideDialogBox(BuildContext context) {
    Navigator.pop(context);
  }

  Widget signUpOption() {
    return GestureDetector(
        child: Container(
          width: double.infinity,
          child: loginMode == true
              ? Text(
                  "New to The Project Quote? Sign Up",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    decorationStyle: TextDecorationStyle.solid,
                    decoration: TextDecoration.underline,
                  ),
                )
              : Text(
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
          setState(() {
            loginMode = !loginMode;
          });
        });
  }

  Widget headingBox() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
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
        color: Colors.grey,
        width: 1.5,
        style: BorderStyle.solid,
      )),
    );
  }

  BoxDecoration buttonDecoration() {
    return BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(10.0),
      border: Border.all(
        color: Colors.transparent,
        style: BorderStyle.solid,
        width: 1.0,
      ),
    );
  }

  String validateEmail(String value) {
    if (!value.contains('@')) {
      return "Enter a valid email address";
    }
    return "";
  }

  String validatePassword(String value) {
    if (value.length < 6 || value.length > 14) {
      return "Password must be of length 8 to 14 character";
    }
    return "";
  }

  String validateRetypePassword(String value) {
    if (value.compareTo(retypePasswordController.value.toString()) != 0) {
      return "Passwords do not match";
    }
    return "";
  }

  Widget loginWithEmailPassword(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: <Widget>[
          TextFormField(
            decoration: textFieldDecoration("EMAIL"),
            keyboardType: TextInputType.emailAddress,
            controller: emailController,
            validator: validateEmail,
          ),
          TextFormField(
            decoration: textFieldDecoration("PASSWORD"),
            keyboardType: TextInputType.text,
            obscureText: true,
            controller: passwordController,
            validator: validatePassword,
          ),
          loginMode == false
              ? TextFormField(
                  decoration: textFieldDecoration("RETYPE PASSWORD"),
                  obscureText: true,
                  controller: retypePasswordController,
                  validator: validateRetypePassword,
                )
              : SizedBox(height: 0),
          SizedBox(height: 5),
          GestureDetector(
              child: Container(
                width: double.infinity,
                padding: EdgeInsets.all(15.0),
                child: Center(
                  child: loginMode == true ? Text("Sign In") : Text("Sign Up"),
                ),
                decoration: buttonDecoration(),
              ),
              onTap: () {
                if (_formKey.currentState.validate()) {
                  showDialogBox(context);
                  loginMode == true ? login() : signUp();
                }
              }),
          SizedBox(
            height: 10.0,
          ),
        ],
      ),
    );
  }

  void checkIfUserAlreadyExist(user) {
    databaseReferences.DatabaseReferences()
        .userDatabaseReference
        .once()
        .then((snapshot) => {
              userExistCallback(snapshot, user),
            });
  }

  void userExistCallback(DataSnapshot snapshot, FirebaseUser user) {
    if (snapshot.value != null) {
      for (var value in snapshot.value.values) {
        print(value["email"]);
        if (value["email"] == user.email) return;
      }
    }
    saveUserDataToDatabase(user);
  }

  void saveUserDataToDatabase(FirebaseUser user) {
    var value = {
      "name": user.displayName,
      "email": user.email,
      "isEmailVerified": user.isEmailVerified,
      "profilePictureUrl": user.photoUrl,
      "uid": user.uid,
    };
    databaseReferences.DatabaseReferences()
        .userDatabaseReference
        .push()
        .set(value)
        .then((value) => {
              print("Data Stored"),
            });
  }

  void login() {
    loginFunctions.LoginFunctions()
        .emailLogin(emailController.text, passwordController.text)
        .then((user) => {
              saveUserDataToDatabase(user),
              hideDialogBox(context),
            })
        .catchError((e) => {
              print(e),
              hideDialogBox(context),
            });
  }

  void signUp() {
    loginFunctions.LoginFunctions()
        .emailSignUp(emailController.text, passwordController.text)
        .then((user) => {
              hideDialogBox(context),
            })
        .catchError((e) => {
              print(e),
              hideDialogBox(context),
            });
  }

  Widget googleLoginButton(BuildContext context) {
    return Container(
      decoration: buttonDecoration(),
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
            onTap: () => {
                  showDialogBox(context),
                  loginFunctions.LoginFunctions()
                      .googleLogin()
                      .then((user) => {
                            checkIfUserAlreadyExist(user),
                          })
                      .then((_) => Navigator.push(context,
                          MaterialPageRoute(builder: (context) => HomePage())))
                      .catchError((e) => print(e)),
                }),
      ),
    );
  }

  Widget facebookLoginButton() {
    return RaisedButton(
        child: Text("Login with facebook"),
        onPressed: () => loginFunctions.LoginFunctions().loginWithFacebook());
  }
}
