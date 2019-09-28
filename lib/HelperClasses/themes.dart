import 'package:flutter/material.dart';
enum ThemeKeys{White , Black}

class Themes {
  static final ThemeData whitetheme = ThemeData(
     fontFamily: 'OpenSans',
    backgroundColor: Colors.white,
    brightness: Brightness.light,
    buttonColor: Colors.orange,
    textTheme: TextTheme(
      headline:TextStyle(color: Colors.black),
      subhead: TextStyle(  fontSize: 18,
      fontWeight: FontWeight.bold,
      color: Color.fromRGBO(0, 0, 0, 0.8),),
      subtitle: TextStyle(color: Colors.black26),
      ),
      accentColor: Colors.black87
  );

  static final ThemeData blacktheme = ThemeData(
    accentColor: Colors.white70,
     fontFamily: 'OpenSans',
    backgroundColor: Colors.black,
    brightness: Brightness.dark,
    buttonColor: Colors.purple,
    textTheme: TextTheme(
      headline:TextStyle(color: Colors.white),
      subhead: TextStyle(  fontSize: 18,
      fontWeight: FontWeight.bold
      ,color: Colors.white70),
      subtitle: TextStyle(color: Colors.white24),
      )
  );


  static ThemeData getThemeFromKey(ThemeKeys themeKey) {
    switch (themeKey) {
      case ThemeKeys.White:
        return whitetheme;
      case ThemeKeys.Black:
        return blacktheme;
     
      default:
        return whitetheme;
    }
  }
}