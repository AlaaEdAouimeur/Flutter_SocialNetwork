import 'package:flutter/material.dart';
import 'package:redux_example/pages/home_page.dart';
import 'package:flutter_redux/flutter_redux.dart';
import '../models/app_state.dart';
import '../viewModel/userProfileTab.dart';
import '../pages/login_page.dart';
import '../pages/tutorial_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Routes extends StatefulWidget {
  RoutesState createState() => RoutesState();
}

class RoutesState extends State<Routes> {
  Widget initialRoute;
  bool firstUse;
  ViewModel viewModel;
  @override
  void initState() {
    super.initState();
    SharedPreferences.getInstance().then((prefs) => {
      firstUse = prefs.getBool("firstUse"),
      firstUse == null
      ?
        viewModel.changeFirstTimeState(true)
      :
        viewModel.changeFirstTimeState(false),
      Future.delayed(Duration(seconds: 3)).then((value) => {
        viewModel.changeLoadingState(false),
      }),
    });
  }

  Widget build(BuildContext context) {
    return StoreConnector<AppState, ViewModel>(
        converter: ViewModel.fromStore,
        builder: (BuildContext context, ViewModel vm) {
          viewModel = vm;
          if (!vm.isLoading) {
            if (vm.firstTime) {
              initialRoute = TutorialPage(vm);
            } else {
              if (vm.isLoggedIn) {
                initialRoute = HomePage();
              } else {
                initialRoute = LoginPage(vm);
              }
            }
          }
          return vm.isLoading
              ? Container(
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                )
              : initialRoute;
        });
  }
}
