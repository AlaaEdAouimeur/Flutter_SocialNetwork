import 'package:redux_example/models/app_state.dart';
import 'package:redux_example/reducers/login_reducer.dart';
import 'package:redux_example/reducers/loading_reducer.dart';
import 'package:redux_example/reducers/first_launch_reducer.dart';

AppState appReducer(AppState state, action) {
  return new AppState(
    isLoggedIn: loginReducer(state.isLoggedIn, action),
    isLoading: loadingReducer(state.isLoading, action),
    firstTime: firstLaunch(state.firstTime, action)
  );
}