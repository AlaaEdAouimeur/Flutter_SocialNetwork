import 'package:flutter/material.dart';
import 'package:redux/redux.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux_example/models/app_state.dart';

class Counter extends StatelessWidget {
  Widget build(BuildContext context) {
    return new StoreConnector<AppState, _ViewModel>(
      converter: _ViewModel.fromStore,
      builder: (BuildContext context, _ViewModel vm) {
        return new Text(
          vm.count.toString(),
          style: Theme.of(context).textTheme.display1,
        );
      },
    );
  }
}

class _ViewModel {
  final int count;
  _ViewModel({
    @required this.count,
  });

  static _ViewModel fromStore(Store<AppState> store) {
    return new _ViewModel(count: store.state.counter);
  }
}
