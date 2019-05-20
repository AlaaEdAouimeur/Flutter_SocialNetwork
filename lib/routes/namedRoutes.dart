import 'package:flutter/material.dart';
import 'package:redux_example/pages/home_page.dart';

class Routes extends StatelessWidget {
  final String initialRoute;
  Routes(this.initialRoute);

  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Named Routes Demo',
        // Start the app with the "/" named route. In our case, the app will start
        // on the FirstScreen Widget
        initialRoute: initialRoute,
        routes: {
          // When we navigate to the "/" route, build the FirstScreen Widget
          '/': (context) => HomePage(),
          // When we navigate to the "/second" route, build the SecondScreen Widget
        },
      );
  }
}