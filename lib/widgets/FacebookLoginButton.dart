import 'package:flutter/material.dart';
import '../functions/login_functions.dart' as loginFunctions;
import '../HelperClasses/DatabaseHelperClass.dart';
import '../pages/home_page.dart';
import '../ErrorHandling/LoginErrorHandling.dart' as loginErrorHandling;
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class FacebookLoginButton extends StatelessWidget {
  final DatabaseHelperClass databaseHelperClass = new DatabaseHelperClass();

  Widget build(BuildContext context) {
    return GestureDetector(
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.blue),
          borderRadius: BorderRadius.circular(10.0),
        ),
        width: 250.0,
        height: 50.0,
        child: IntrinsicWidth(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Icon(
                FontAwesomeIcons.facebook,
                color: Colors.blue,
              ),
              SizedBox(
                width: 10.0,
              ),
              Text(
                "CONTINUE WITH FACEBOOK",
                style:
                    TextStyle(fontWeight: FontWeight.bold, color: Colors.blue),
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
            .loginWithFacebook()
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
                  loginErrorHandling.LoginErrorHandling(context, e.code)
                      .handleLoginError(),
                });
      },
    );
  }
}
