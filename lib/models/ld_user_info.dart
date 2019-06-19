import 'dart:convert';
import '../database/localDatabase.dart' as database;

UserInfo clientFromJson(String str) {
  final jsonData = json.decode(str);
  return UserInfo.fromJson(jsonData);
}

String clientToJson(UserInfo data) {
  final dyn = data.toJson();
  return json.encode(dyn);
}

void insert(UserInfo newUser) async {
  final db = await database.DBProvider.db.database;
  await db.insert("Client", newUser.toJson());
}

class UserInfo {
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

  UserInfo(
      {this.uid,
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
      this.createdAt});

  factory UserInfo.fromJson(Map<String, dynamic> json) => new UserInfo(
      uid: json["uid"],
      name: json["name"],
      username: json["username"],
      contactNumber: json["contactNumber"],
      email: json["email"],
      loginProvider: json["loginProvider"],
      profilePictureURL: json["profilePictureURL"],
      dateOfBirth: json["dateOfBirth"],
      gender: json["gender"],
      instagramUserName: json["instagramUserName"],
      isEmailVerified: json["logiisEmailVerifiednProvider"],
      createdAt: json["createdAt"]);

  Map<String, dynamic> toJson() => {
        "uid": uid,
        "name": name,
        "username": username,
        "contactNumber": contactNumber,
        "email": email,
        "loginProvider": loginProvider,
        "profilePictureURL": profilePictureURL,
        "dateOfBirth": dateOfBirth,
        "gender": gender,
        "instagramUserName": instagramUserName,
        "isEmailVerified": isEmailVerified,
        "createdAt": createdAt,
      };
}
