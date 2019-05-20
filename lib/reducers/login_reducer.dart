import 'package:redux_example/actions/login_actions.dart';

bool loginReducer(bool isLoggedIn, action) {
  switch (action.runtimeType) {
    case LoggedIn:
      isLoggedIn = true;
      return isLoggedIn;
      break;

    case LoggedOut:
      isLoggedIn = false;
      return isLoggedIn;
      break;

    default:
      return isLoggedIn;
  }
}