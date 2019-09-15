import 'package:cloud_firestore/cloud_firestore.dart';
import '../database/databaseReferences.dart' as databaseReferences;
import 'package:firebase_auth/firebase_auth.dart';

class DatabaseHelperClass {
  Future<DocumentSnapshot> saveUserDataToDatabase(FirebaseUser user) {
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
      "blogs": 0,
      "location": null,
      "username": null,
      "birthday": null,
      "location": null,
      "bio": null,
    };
    return checkIfUserAlreadyExist(user.email).then((val) async {
      if (val == null) {
        print("INITIALIZED USER DETAILS");
        await databaseReferences.DatabaseReferences()
            .users
            .document()
            .setData(value)
            .then(
              (_) => print("User data stored to firestore"),
            );
      }
      return val;
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
