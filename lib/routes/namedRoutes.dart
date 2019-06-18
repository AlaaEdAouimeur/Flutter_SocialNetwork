import 'package:flutter/material.dart';
import 'package:redux_example/pages/home_page.dart';
import 'package:flutter_redux/flutter_redux.dart';
import '../models/app_state.dart';
import '../viewModel/userProfileTab.dart';
import '../pages/login_page.dart';
import '../pages/tutorial_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Routes extends StatefulWidget {
  RoutesState createState() => RoutesState();
}

class RoutesState extends State<Routes> {
  Widget build(BuildContext context) {
    return StoreConnector<AppState, ViewModel>(
        converter: ViewModel.fromStore,
        builder: (BuildContext context, ViewModel vm) {
          return new FutureBuilder(
              future: SharedPreferences.getInstance()
                  .then((prefs) => prefs.getBool("firstUse")),
              builder: (BuildContext context, AsyncSnapshot firstUse) {
                if (!firstUse.hasData) {
                  print("Tutorial Page");
                  return TutorialPage(vm);
                } else {
                  return new FutureBuilder(
                      future: FirebaseAuth.instance.currentUser(),
                      builder: (BuildContext context, AsyncSnapshot snapshot) {
                        if (snapshot.hasData) {
                          if (snapshot.data != null) {
                            print("Home Page");
                            return HomePage();
                          } else {
                            print("Progress Indicator");
                            return CircularProgressIndicator(
                              backgroundColor: Colors.green,
                            );
                          }
                        } else {
                          print("Login Page");
                          return LoginPage();
                        }
                      });
                }
              });
        });
  }
}
