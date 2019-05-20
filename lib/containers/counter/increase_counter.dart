import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:redux_example/models/app_state.dart';
import 'package:redux_example/actions/counter_actions.dart';

class IncreaseCounter extends StatelessWidget {
  Widget build(BuildContext context) {
    return new StoreConnector<AppState, VoidCallback>(
      converter: (Store<AppState> store) {
        return () {
          store.dispatch(new IncrementAction());
        };
      },
      builder: (BuildContext context, VoidCallback increase) {
        return new RaisedButton(
          child: Icon(Icons.add),
          onPressed: increase,
        );
      },
    );
  }
}