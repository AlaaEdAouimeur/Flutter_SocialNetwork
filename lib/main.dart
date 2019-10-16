import 'package:flutter/material.dart';
import 'package:redux_example/HelperClasses/themes.dart';
import 'package:redux_example/models/CustomTheme.dart';
import 'package:redux_example/store.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux_example/routes/namedRoutes.dart';

void main() => runApp(
      CustomTheme(
        initialThemeKey: ThemeKeys.White,
        child: MyApp(),
      ),
    );

class MyApp extends StatelessWidget {
  final String title = "The Project Quote";

  Widget build(BuildContext context) {
    return new StoreProvider(
        store: store,
        child: new MaterialApp(
          title: title,
          theme: CustomTheme.of(context),
          home: Scaffold(
            backgroundColor: Colors.black,
            body: Routes(),
          ),
        ));
  }
}
