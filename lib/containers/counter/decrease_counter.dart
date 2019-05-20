import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux_example/models/app_state.dart';
import 'package:redux/redux.dart';
import 'package:redux_example/actions/counter_actions.dart';

class DecreaseCounter extends StatelessWidget {
  Widget build(BuildContext context) {
    return StoreConnector<AppState, VoidCallback>(
      converter: (Store<AppState> store) {
        return () {
          store.dispatch(new DecrementAction());
        };
      },
      builder: (BuildContext context, VoidCallback decrease) {
        return new RaisedButton(
          child: Icon(Icons.delete),
          onPressed: decrease,
        );
      },
    );
  }
}