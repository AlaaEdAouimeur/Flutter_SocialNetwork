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
  ViewModel vm;
  bool loginMode = true;
  bool isLoading = false;
  LoginPageState(this.vm);
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final retypePasswordController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    retypePasswordController.dispose();
    super.dispose();
  }

  Widget build(BuildContext context) {
    return vm.isLoading == true
        ?
    Container(
      width: 20.0,
      child: Center(child: CircularProgressIndicator(
        backgroundColor: Colors.red,
        strokeWidth: 7.0,
      )),
    )
        :
    Material(
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
          child: loginMode == true ? Text(
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

  BoxDecoration buttonDecoration() {
    return BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(40.0),
      border: Border.all(
        color: Colors.transparent,
        style: BorderStyle.solid,
        width: 1.0,
      ),
    );
  }

  Widget loginWithEmailPassword() {
    return Column(
      children: <Widget>[
        TextField(
          decoration: textFieldDecoration("EMAIL"),
          keyboardType: TextInputType.emailAddress,
          onEditingComplete: () {
            print("Completed");
          },
          onChanged: (value) {
            print("Changed + " + value);
          },
          controller: emailController,
        ),
        SizedBox(
          height: 10.0,
        ),
        TextField(
          decoration: textFieldDecoration("PASSWORD"),
          keyboardType: TextInputType.text,
          obscureText: true,
          controller: passwordController,
        ),
        loginMode == false ?
          TextField(
            decoration: textFieldDecoration("RETYPE PASSWORD"),
            obscureText: true,
            controller: retypePasswordController,
          )
            :
          SizedBox(height: 0),
        SizedBox(height: 10),
        GestureDetector(
          child: Container(
            width: double.infinity,
            padding: EdgeInsets.all(15.0),
            child: Center(
              child: loginMode == true ?
              Text("Sign In") :
              Text("Sign Up"),
            ),
            decoration: buttonDecoration(),
          ),
          onTap: () {
            print(vm.isLoading);
            loginMode == true
                ?
            loginFunctions.LoginFunctions()
                .emailLogin(vm, emailController.text, passwordController.text)
                .then((user) =>
                  {
                    userInstance.UserInstance.user = user,
                  vm.changeLoginState(true),
                  vm.changeLoadingState(false),
                  })
                .catchError((e) => print(e))
                :
            loginFunctions.LoginFunctions()
                .emailSignUp(vm, emailController.text, passwordController.text)
                .then((user) =>
            {
            userInstance.UserInstance.user = user,
            vm.changeLoginState(true),
            vm.changeLoadingState(false),
            })
                .catchError((e) => print(e));
            print(vm.isLoading);
          }
        ),
        SizedBox(
          height: 10.0,
        ),
      ],
    );
  }

  Widget googleLoginButton() {
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
