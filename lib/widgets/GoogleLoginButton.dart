import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:redux_example/HelperClasses/FirstLoginHelper.dart';
import '../functions/login_functions.dart' as loginFunctions;
import '../HelperClasses/DatabaseHelperClass.dart';
import '../pages/home_page.dart';
import '../database/databaseReferences.dart' as databaseReferences;

class GoogleLoginButton extends StatelessWidget {
  final DatabaseHelperClass databaseHelperClass = new DatabaseHelperClass();
  int userType;
  Map<String, dynamic> userUpdate;
  String username, birthday, location, bio;
  FirebaseUser currentUser;

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
                EvaIcons.google,
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
          },
        );
        loginFunctions.LoginFunctions().googleLogin().then((user) async {
          currentUser = user;
          await databaseHelperClass
              .saveUserDataToDatabase(user)
              .then((DocumentSnapshot userSnapshot) async {
            Navigator.pop(context);
            if (userSnapshot == null)
              userType = FirstLoginHelper.NEW;
            else if (userSnapshot['username'] == null)
              userType = FirstLoginHelper.OLD_WITHOUT;
            else
              userType = FirstLoginHelper.OLD_WITH;
            if (userType == FirstLoginHelper.NEW ||
                userType == FirstLoginHelper.OLD_WITHOUT) {
              print("NEW USER");
              userUpdate = await FirstLoginHelper.showPopup(context);
              print("NEW USER IS ${userUpdate.toString()}");
              if(userUpdate != null){
                username = userUpdate['username'];
                birthday = userUpdate['birthday'];
                location = userUpdate['location'];
                bio = userUpdate['bio'];
              }
            } else {
              print("OLD USER");
            }
          });
        }).then((_) async {
          if (userType == FirstLoginHelper.NEW ||
              userType == FirstLoginHelper.OLD_WITHOUT) {
            if (username != null ||
                birthday != null ||
                location != null ||
                bio != null) {
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
                },
              );
              QuerySnapshot a = await databaseReferences.DatabaseReferences()
                  .users
                  .where('email', isEqualTo: currentUser.email)
                  .getDocuments();
              databaseReferences.DatabaseReferences()
                  .users
                  .document(a.documents[0].documentID)
                  .updateData(userUpdate);
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                  builder: (context) => HomePage(),
                ),
                (Route<dynamic> route) => false,
              );
            }
          } else {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                builder: (context) => HomePage(),
              ),
              (Route<dynamic> route) => false,
            );
          }
        }).catchError((e) => {
          Navigator.pop(context),
        });
      },
    );
  }
}
