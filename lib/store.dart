import 'package:redux/redux.dart';
import 'package:redux_example/reducers/app_reducer.dart';
import 'package:redux_example/models/app_state.dart';

final store = new Store<AppState>(
  appReducer,
  initialState: new AppState(),
);