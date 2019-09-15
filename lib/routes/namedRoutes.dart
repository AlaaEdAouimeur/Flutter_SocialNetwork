import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:redux_example/pages/home_page.dart';
import 'package:flutter_redux/flutter_redux.dart';
import '../models/app_state.dart';
import '../viewModel/userProfileTab.dart';
import '../pages/tutorial_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../database/databaseReferences.dart' as databaseReferences;

class Routes extends StatefulWidget {
  RoutesState createState() => RoutesState();
}

class RoutesState extends State<Routes> {
  FirebaseUser currentUser;
  bool isFetchingCurrentUser = true;
  bool isNewUser = false;

  @override
  void initState() {
    super.initState();
    FirebaseAuth.instance.currentUser().then((user) async {
      if(user != null){
        QuerySnapshot a =await databaseReferences.DatabaseReferences().users.where('email', isEqualTo:user.email).getDocuments();
        DocumentSnapshot d = a.documents[0];
        if(d['username'] == null || d['birthday'] == null || d['location'] == null || d['bio'] == null){
          isNewUser = true;
        }else{
          isNewUser = false;
        }
      }
      setCurrentUser(user);
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
          return isFetchingCurrentUser == true
              ? Center(
                  child: SizedBox(
                    height: 50.0,
                    width: 50.0,
                    child: CircularProgressIndicator(),
                  ),
                )
              : currentUser == null ? TutorialPage()
              : isNewUser ? TutorialPage() : HomePage();
        });
  }
}
