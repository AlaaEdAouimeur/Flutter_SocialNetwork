import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_redux/flutter_redux.dart';
import '../models/app_state.dart';
import 'package:flutter/material.dart';
import '../viewModel/userProfileTab.dart';
import '../widgets/login_page.dart';
import '../widgets/user_profile.dart';
import '../pages/complete_profile_mandatory.dart';

class UserProfileTab extends StatefulWidget {
  @override
  UserProfileState createState() => UserProfileState();
}

class UserProfileState extends State<UserProfileTab> {
  FirebaseUser user;

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, ViewModel>(
      converter: ViewModel.fromStore,
      builder: (BuildContext context, ViewModel vm) {
        return Container(
          child: vm.isLoading
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : userProfile(),
        );
      },
    );
  }

  Widget userProfile() {
    return StoreConnector<AppState, ViewModel>(
      converter: ViewModel.fromStore,
      builder: (BuildContext context, ViewModel vm) {
        if (!vm.isLoggedIn) {
          if (vm.firstTime) {
            return CompleteProfile(vm);
          } else {
            return LoginPage(vm);
          }
        } else {
          return UserProfile(vm);
        }
      },
    );
  }
}
