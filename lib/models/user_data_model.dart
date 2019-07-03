import 'package:firebase_database/firebase_database.dart';

class UserDataModel {
  String uid;
  String name;
  String username;
  String contactNumber;
  String email;
  String profilePictureURL;
  String loginProvider;
  DateTime dateOfBirth;
  String gender;
  String instagramUserName;
  DateTime createdAt;
  bool isEmailVerified;
  int followers;
  int followings;
  int posts;
  String location;

  UserDataModel(
      this.uid,
      this.name,
      this.username,
      this.contactNumber,
      this.email,
      this.loginProvider,
      this.profilePictureURL,
      this.dateOfBirth,
      this.gender,
      this.instagramUserName,
      this.isEmailVerified,
      this.createdAt,
      this.followers,
      this.followings,
      this.posts);

  UserDataModel.fromSnapshot(DataSnapshot snapshot)
      : uid = snapshot.value['uid'],
        name = snapshot.value['name'],
        username = snapshot.value['username'],
        contactNumber = snapshot.value['contactNumber'],
        email = snapshot.value['email'],
        loginProvider = snapshot.value['loginProvider'],
        profilePictureURL = snapshot.value['profilePictureUrl'],
        dateOfBirth = snapshot.value['dateOfBirth'],
        gender = snapshot.value['gender'],
        instagramUserName = snapshot.value['instagramUsername'],
        isEmailVerified = snapshot.value['isEmailVerified'],
        createdAt = snapshot.value['createdAt'],
        followers = snapshot.value['followers'],
        followings = snapshot.value['followings'],
        posts = snapshot.value['posts'];
}
