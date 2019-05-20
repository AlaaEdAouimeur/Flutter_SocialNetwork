import 'package:firebase_database/firebase_database.dart';

class UserDataModel {
  String key;
  String name;
  String username;
  String contactNumber;
  String email;
  String profilePictureURL;
  DateTime dateOfBirth;
  String gender;
  String instagramUserName;
  DateTime createdAt;

  UserDataModel(this.key, this.name, this.username, this.contactNumber, this.email, this.profilePictureURL, this.dateOfBirth, this.gender, this.instagramUserName, this.createdAt);

  UserDataModel.fromSnapshot(DataSnapshot snapshot)
      : key = snapshot.value['key'],
        name = snapshot.value['name'],
        username = snapshot.value['username'],
        contactNumber = snapshot.value['contactNumber'],
        email = snapshot.value['email'],
        profilePictureURL = snapshot.value['profilePictureUrl'],
        dateOfBirth = snapshot.value['dateOfBirth'],
        gender = snapshot.value['gender'],
        instagramUserName = snapshot.value['instagramUsername'],
        createdAt = snapshot.value['createdAt'];
}