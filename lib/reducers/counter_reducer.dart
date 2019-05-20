import 'package:redux_example/actions/counter_actions.dart';

int counterReducer(int currentCount, action) {
  switch (action.runtimeType) {
    case IncrementAction:
      currentCount++;
      return currentCount;
      break;

    case DecrementAction:
      currentCount--;
      return currentCount;
      break;

    default:
      return currentCount;
  }
}