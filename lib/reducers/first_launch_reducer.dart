import 'package:redux_example/actions/first_launch_actions.dart';

bool firstLaunch(bool firstTime, action) {
  switch (action.runtimeType) {
    case NotFirstTime:
      firstTime = false;
      return firstTime;
      break;

    case FirstTime:
      firstTime = true;
      return firstTime;
      break;

    default:
      return firstTime;
  }
}