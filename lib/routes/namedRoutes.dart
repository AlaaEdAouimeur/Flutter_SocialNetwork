import 'package:flutter/material.dart';
import 'package:redux_example/pages/home_page.dart';
import 'package:flutter_redux/flutter_redux.dart';
import '../models/app_state.dart';
import '../viewModel/userProfileTab.dart';
import '../pages/tutorial_page.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Routes extends StatefulWidget {
  RoutesState createState() => RoutesState();
}

class RoutesState extends State<Routes> {
  FirebaseUser currentUser;
  bool isFetchingCurrentUser = true;

  @override
  void initState() {
    super.initState();
    FirebaseAuth.instance.currentUser().then((user) => {
          setCurrentUser(user),
        });
  }

  void setCurrentUser(FirebaseUser user) {
    setState(() {
      isFetchingCurrentUser = false;
      currentUser = user;
    });
  }

  Widget build(BuildContext context) {
    return StoreConnector<AppState, ViewModel>(
        converter: ViewModel.fromStore,
        builder: (BuildContext context, ViewModel vm) {
          return isFetchingCurrentUser == true ?
          Center(
            child: SizedBox(
              height: 50.0,
              width: 50.0,
              child: CircularProgressIndicator(),
            ),
          ) :
          currentUser == null ? TutorialPage() : HomePage();
        });
  }
}
