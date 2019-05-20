import 'package:flutter/material.dart';

class LoadingScreen extends StatelessWidget {
  Widget build(BuildContext context) {
    return MaterialApp(
      home: CircularProgressIndicator(),
    );
  }
}