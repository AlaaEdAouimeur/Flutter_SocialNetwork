import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:flutter_redux/flutter_redux.dart';
import '../models/app_state.dart';
import 'package:redux/redux.dart';

class UserProfile extends StatefulWidget {
  @override
  UserProfileState createState() => UserProfileState();
}

class UserProfileState extends State<UserProfile> {
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final facebookLogin = FacebookLogin();
  FirebaseUser user;

  @override
  Widget build(BuildContext context) {
    return new StoreConnector<AppState, _ViewModel>(
        converter: _ViewModel.fromStore,
        builder: (BuildContext context, _ViewModel vm) {
          return Container(
            child: vm.isLoading
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : userProfile(vm.isLoggedIn),
          );
        });
  }

  Widget userProfile(bool isLoggedIn) {
    if (!isLoggedIn) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text("Not Logged In"),
          ],
        ),
      );
    } else {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text("You are logged In"),
          ],
        ),
      );
    }
  }

  Widget googleLoginButton() {
    return RaisedButton(
      child: Text("Login with google"),
      onPressed: () => googleLogin()
          .then((FirebaseUser user) => print(user))
          .catchError((e) => print(e)),
    );
  }

  Widget facebookLoginButton() {
    return RaisedButton(
      child: Text("Login with facebook"),
      onPressed: () => loginWithFacebook()
          .then((FirebaseUser user) => print(user))
          .catchError((e) => print(e)),
    );
  }

  Widget logoutButton() {
    return RaisedButton(
      child: Text("Logout"),
      onPressed: logout,
    );
  }

  void logout() async {
    // setState(() {
    //   isLoading = true;
    // });
    await _auth.signOut();
    // setState(() {
    //   isLoggedIn = false;
    //   isLoading = false;
    // });
  }

  Future<FirebaseUser> googleLogin() async {
    // setState(() {
    //   isLoading = true;
    // });
    GoogleSignInAccount account = await _googleSignIn.signIn();
    GoogleSignInAuthentication _googleAuth = await account.authentication;
    final AuthCredential credential = GoogleAuthProvider.getCredential(
      accessToken: _googleAuth.accessToken,
      idToken: _googleAuth.idToken,
    );
    user = await _auth.signInWithCredential(credential);
    // setState(() {
    //   isLoggedIn = true;
    //   isLoading = false;
    // });
    print("Display Name : " + user.displayName);
    return user;
  }

  Future<FirebaseUser> loginWithFacebook() async {
    // setState(() {
    //   isLoading = true;
    // });
    final result = await facebookLogin.logInWithReadPermissions(['email']);
    switch (result.status) {
      case FacebookLoginStatus.loggedIn:
        final AuthCredential credential = FacebookAuthProvider.getCredential(
            accessToken: result.accessToken.token);
        user = await _auth.signInWithCredential(credential);
        // setState(() {
        //   isLoggedIn = true;
        //   isLoading = false;
        // });
        break;

      case FacebookLoginStatus.error:
        print("Error with login");
        // setState(() {
        //   isLoading = false;
        // });
        break;
      default:
        print("Default case");
    }
    return user;
  }
}

class _ViewModel {
  final bool isLoading, isLoggedIn;
  _ViewModel({@required this.isLoading, this.isLoggedIn});

  static _ViewModel fromStore(Store<AppState> store) {
    return new _ViewModel(
      isLoading: store.state.isLoading,
      isLoggedIn: store.state.isLoggedIn,
    );
  }
}
