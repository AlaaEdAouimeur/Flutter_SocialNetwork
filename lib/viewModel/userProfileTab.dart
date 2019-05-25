import 'package:redux/redux.dart';
import '../actions/login_actions.dart';
import '../actions/loading_actions.dart';
import '../actions/first_launch_actions.dart';
import '../models/app_state.dart';

class ViewModel {
  final bool isLoggedIn;
  final bool isLoading;
  final bool firstTime;
  Function changeLoginState;
  Function changeLoadingState;
  Function changeFirstTimeState;
  ViewModel(
      {this.changeLoginState,
      this.changeLoadingState,
      this.changeFirstTimeState,
      this.isLoggedIn,
      this.isLoading,
      this.firstTime});

  static ViewModel fromStore(Store<AppState> store) {
    return new ViewModel(
        isLoggedIn: store.state.isLoggedIn,
        isLoading: store.state.isLoading,
        firstTime: store.state.firstTime,
        changeLoginState: (state) {
          if (state) {
            store.dispatch(new LoggedIn());
          } else {
            store.dispatch(new LoggedOut());
          }
        },
        changeFirstTimeState: (state) {
          if(state) {
            store.dispatch(new FirstTime());
          } else {
            store.dispatch(new NotFirstTime());
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
