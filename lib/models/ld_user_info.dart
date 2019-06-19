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

class UserInfo {
  String uid;
  String name;

//  String username;
//  String contactNumber;
  String email;
  String profilePictureURL;

//  String loginProvider;
//  DateTime dateOfBirth;
//  String gender;
//  String instagramUserName;
//  DateTime createdAt;
  bool isEmailVerified;

  UserInfo({
    this.uid,
    this.name,
//      this.username,
//      this.contactNumber,
    this.email,
//      this.loginProvider,
    this.profilePictureURL,
//      this.dateOfBirth,
//      this.gender,
//      this.instagramUserName,
    this.isEmailVerified,
//      this.createdAt
  });

  factory UserInfo.fromJson(Map<String, dynamic> json) => new UserInfo(
      uid: json["uid"],
      name: json["name"],
//      username: json["username"],
//      contactNumber: json["contactNumber"],
      email: json["email"],
//      loginProvider: json["loginProvider"],
      profilePictureURL: json["profilePictureURL"],
//      dateOfBirth: json["dateOfBirth"],
//      gender: json["gender"],
//      instagramUserName: json["instagramUserName"],
      isEmailVerified: json["logiisEmailVerifiednProvider"]
//      createdAt: json["createdAt"]
  );

  Map<String, dynamic> toJson() => {
        "uid": uid,
        "name": name,
//        "username": username,
//        "contactNumber": contactNumber,
        "email": email,
//        "loginProvider": loginProvider,
        "profilePictureURL": profilePictureURL,
//        "dateOfBirth": dateOfBirth,
//        "gender": gender,
//        "instagramUserName": instagramUserName,
        "isEmailVerified": isEmailVerified,
//        "createdAt": createdAt,
      };

  insert(UserInfo newUser) async {
    print("Inside insert");
    final db = await database.DBProvider.db.database;
    print("step 1");
    var res = await db.insert("UserInfo", newUser.toJson());
    print("Step 2");
    return res;
  }

  read(String email) async {
    final db = await database.DBProvider.db.database;
    var res =
        await db.query("UserInfo", where: "email = ?", whereArgs: [email]);
    return res.isNotEmpty ? UserInfo.fromJson(res.first) : Null;
  }

  updateUserInfo(UserInfo userInfo) async {
    final db = await database.DBProvider.db.database;
    var res = await db.update("UserInfo", userInfo.toJson(),
        where: "email = ?", whereArgs: [userInfo.email]);
    return res;
  }

  deleteUserInfo(String email) async {
    final db = await database.DBProvider.db.database;
    db.delete("UserInfo", where: "email = ?", whereArgs: [email]);
  }
}
