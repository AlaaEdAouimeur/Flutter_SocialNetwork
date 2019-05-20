import 'package:redux_example/models/app_state.dart';
import 'package:redux_example/reducers/counter_reducer.dart';
import 'package:redux_example/reducers/login_reducer.dart';
import 'package:redux_example/reducers/loading_reducer.dart';

AppState appReducer(AppState state, action) {
  return new AppState(
    isLoggedIn: loginReducer(state.isLoggedIn, action),
    isLoading: loadingReducer(state.isLoading, action),
    counter: counterReducer(state.counter, action)
  );
}