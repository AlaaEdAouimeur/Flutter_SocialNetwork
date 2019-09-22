import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:redux_example/HelperClasses/FirstLoginHelper.dart';
import '../database/databaseReferences.dart' as databaseReferences;
import 'package:firebase_auth/firebase_auth.dart';

class DatabaseHelperClass {
  Future<void> saveUserDataToDatabase(FirebaseUser user, BuildContext context) {
    return checkIfUserAlreadyExist(user.email).then((val) async {
      if (val == null || val['username'] == null) {
        bool shouldProceed = true;
        Map<String, dynamic> userUpdate = await FirstLoginHelper.showPopup(context);
        if (userUpdate != null) {
          userUpdate.forEach((key, value) {
            if (value == null) shouldProceed = false;
          });
        } else
          shouldProceed = false;
        if (shouldProceed) {
          var value = {
            "name": user.displayName.toLowerCase(),
            "email": user.email.toLowerCase(),
            "isEmailVerified": user.isEmailVerified.toString(),
            "profilePictureUrl": user.photoUrl.toString(),
            "uid": user.uid,
            "createdAt": DateTime.now(),
            "followers": 0,
            "followings": 0,
            "posts": 0,
            "username": userUpdate['username'],
            "birthday": userUpdate['birthday'],
            "location": userUpdate['location'],
            "bio": userUpdate['bio'],
          };
          print("INITIALIZED USER DETAILS");
          await databaseReferences.DatabaseReferences()
              .users
              .document()
              .setData(value)
              .then(
                (_) => print("User data stored to firestore"),
              );
        } else
          throw NewUserEntryException(
              'FAILURE: Failed to store user details in firestore. Insufficient data.');
      }
    });
  }

  Future<DocumentSnapshot> checkIfUserAlreadyExist(email) async {
    QuerySnapshot data = await databaseReferences.DatabaseReferences()
        .users
        .where('email', isEqualTo: email)
        .getDocuments();
    if (data.documents.length == 1)
      return data.documents[0];
    else
      return null;
  }
}

class NewUserEntryException implements Exception {
  String cause;
  NewUserEntryException(this.cause);
}
