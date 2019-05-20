import 'package:redux/redux.dart';
import '../actions/login_actions.dart';
import '../actions/loading_actions.dart';
import '../models/app_state.dart';

class ViewModel {
  final bool isLoggedIn;
  final bool isLoading;
  Function changeLoginState;
  Function changeLoadingState;
  ViewModel(
      {this.changeLoginState,
      this.changeLoadingState,
      this.isLoggedIn,
      this.isLoading});

  static ViewModel fromStore(Store<AppState> store) {
    return new ViewModel(
        isLoggedIn: store.state.isLoggedIn,
        isLoading: store.state.isLoading,
        changeLoginState: (state) {
          if (state) {
            store.dispatch(new LoggedIn());
          } else {
            store.dispatch(new LoggedOut());
          }
        },
        changeLoadingState: (state) {
          if (state) {
            store.dispatch(new LoadingStart());
          } else {
            store.dispatch(new LoadingEnd());
          }
        });
  }
}