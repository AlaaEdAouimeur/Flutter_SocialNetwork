import 'package:redux_example/actions/loading_actions.dart';

bool loadingReducer(bool isLoading, action) {
  switch (action.runtimeType) {
    case LoadingStart:
      isLoading = true;
      return isLoading;
      break;

    case LoadingEnd:
      isLoading = false;
      return isLoading;
      break;

    default:
      return isLoading;
  }
}