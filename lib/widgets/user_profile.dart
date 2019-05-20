import 'package:flutter/material.dart';
import '../functions/login_functions.dart' as loginFunctions;
import '../viewModel/userProfileTab.dart';

class UserProfile extends StatelessWidget {
  final ViewModel vm;
  UserProfile(this.vm);

  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Padding(
          padding: EdgeInsets.only(left: 20),
          child: Row(
            children: <Widget>[
              Container(
                width: 60,
                height: 60,
                color: Colors.red,
              ),
              Padding(
                padding: EdgeInsets.only(left: 20),
                child: Column(
                  children: <Widget>[
                    Container(
                      height: 30,
                      child: Center(
                        child: Text("Full Name"),
                      ),
                    ),
                    Container(
                      height: 30,
                      child: Center(
                        child: Text("Username"),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget logoutButton() {
    return RaisedButton(
        child: Text("Logout"),
        onPressed: () =>
            loginFunctions.LoginFunctions().logout(vm).then((_) => {
                  vm.changeLoginState(false),
                  vm.changeLoadingState(false),
                }));
  }
}
