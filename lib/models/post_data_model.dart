import 'package:firebase_database/firebase_database.dart';

class PostDataModel {
  String key;
  String name;
  String age;
  // DateTime createdAt;
  // DateTime updatedAt;
  // String category;

  PostDataModel(this.key, this.name, this.age);

  PostDataModel.fromSnapshot(DataSnapshot snapshot)
      : key = snapshot.value['key'],
        name = snapshot.value['name'],
        age = snapshot.value['age'];
  // createdAt = snapshot.value['createdAt'],
  // updatedAt = snapshot.value['updatedAt'],
  // category = snapshot.value['category'];
}