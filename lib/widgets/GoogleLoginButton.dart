import 'package:flutter/material.dart';
import '../functions/login_functions.dart' as loginFunctions;
import '../HelperClasses/DatabaseHelperClass.dart';
import '../pages/home_page.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class GoogleLoginButton extends StatelessWidget {
  final DatabaseHelperClass databaseHelperClass = new DatabaseHelperClass();

  Widget build(BuildContext context) {
    return GestureDetector(
      child: Container(
        width: 250.0,
        height: 50.0,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.red),
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: IntrinsicWidth(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Icon(
                FontAwesomeIcons.google,
                color: Colors.red,
              ),
              SizedBox(
                width: 10.0,
              ),
              Text(
                "CONTINUE WITH GOOGLE",
                style:
                    TextStyle(fontWeight: FontWeight.bold, color: Colors.red),
              )
            ],
          ),
        ),
      ),
      onTap: () {
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return Center(
                child: SizedBox(
                  height: 50.0,
                  width: 50.0,
                  child: CircularProgressIndicator(),
                ),
              );
            });
        loginFunctions.LoginFunctions()
            .googleLogin()
            .then((user) async {
              await databaseHelperClass.saveUserDataToDatabase(user, context);
            })
            .then((_) => {
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                      builder: (context) => HomePage(),
                    ),
                    (Route<dynamic> route) => false,
                  ),
                })
            .catchError((e) => {
                  Navigator.pop(context),
                });
      },
    );
  }
}
