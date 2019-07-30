import 'package:cloud_firestore/cloud_firestore.dart';
import '../database/databaseReferences.dart' as databaseReferences;
import 'package:firebase_auth/firebase_auth.dart';

class DatabaseHelperClass {
  void saveUserDataToDatabase(FirebaseUser user) {
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
      "location": null,
      "username": null,
    };
    checkIfUserAlreadyExist(user.email).then((val) => val
        ? null
        : databaseReferences.DatabaseReferences()
        .users
        .document()
        .setData(value)
        .then((val) => print("User data stored to firestore")));
  }

  Future<bool> checkIfUserAlreadyExist(email) async {
    QuerySnapshot data = await databaseReferences.DatabaseReferences()
        .users
        .where('email', isEqualTo: email)
        .getDocuments();
    return data.documents.length == 1;
  }
}