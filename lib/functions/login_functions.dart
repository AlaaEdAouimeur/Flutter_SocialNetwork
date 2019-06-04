import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import '../viewModel/userProfileTab.dart';

class LoginFunctions {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final facebookLogin = FacebookLogin();
  FirebaseUser user;

  Future<void> logout(ViewModel vm) async {
    vm.changeLoadingState(true);
    if(_googleSignIn != null) _googleSignIn.signOut();
    if(facebookLogin != null) facebookLogin.logOut();
    await _auth.signOut();
  }

  Future<FirebaseUser> googleLogin(ViewModel vm) async {
    vm.changeLoadingState(true);
    GoogleSignInAccount account = await _googleSignIn.signIn();
    GoogleSignInAuthentication _googleAuth = await account.authentication;
    final AuthCredential credential = GoogleAuthProvider.getCredential(
      accessToken: _googleAuth.accessToken,
      idToken: _googleAuth.idToken,
    );
    user = await _auth.signInWithCredential(credential);
    return user;
  }

  Future<FirebaseUser> emailLogin(ViewModel vm, String email, String password) async {
    vm.changeLoadingState(true);
    user = await _auth.signInWithEmailAndPassword(email: email, password: password);
    return user;
  }

  Future<FirebaseUser> emailSignUp(ViewModel vm, String email, String password) async {
    vm.changeLoadingState(true);
    print(vm.isLoading);
    user = await _auth.createUserWithEmailAndPassword(email: email, password: password);
    return user;
  }

  Future<FirebaseUser> loginWithFacebook(ViewModel vm) async {
    vm.changeLoadingState(true);
    final result = await facebookLogin.logInWithReadPermissions(['email']);
    switch (result.status) {
      case FacebookLoginStatus.loggedIn:
        print("I am here bitches");
        final AuthCredential credential = FacebookAuthProvider.getCredential(
            accessToken: result.accessToken.token);
        user = await _auth.signInWithCredential(credential);
        break;

      case FacebookLoginStatus.error:
        print("Error with login");
        vm.changeLoadingState(false);
        break;

      default:
        vm.changeLoadingState(false);
        print("Default case");
    }
    return user;
  }
}
