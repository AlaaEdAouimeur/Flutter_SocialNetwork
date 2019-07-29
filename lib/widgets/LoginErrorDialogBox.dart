import 'package:flutter/material.dart';

class LoginErrorDialogBox extends StatelessWidget {
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.white,
      title: Icon(
        Icons.error_outline,
        color: Colors.red,
        size: 80.0,
      ),
      content: IntrinsicHeight(
        child: Column(
          children: <Widget>[
            Text(
              "This email is already registered with a different service provider. Please try logging in with Google.",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                letterSpacing: 0.5,
                fontSize: 18.0,
              ),
            ),
            SizedBox(height: 30.0,),
            GestureDetector(
              child: Text(
                "OK",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.green,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.5,
                  fontSize: 20.0,
                ),
              ),
              onTap: () => Navigator.pop(context),
            ),
          ],
        ),
      ),
      titleTextStyle: TextStyle(color: Colors.white, fontSize: 20.0),
    );
  }
}