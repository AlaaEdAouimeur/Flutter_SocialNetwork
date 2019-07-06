import 'package:firebase_database/firebase_database.dart';

class PostDataModel {
  String key;
  String name;
  DateTime createdAt;
  // DateTime updatedAt;
  // String category;

  PostDataModel(this.key, this.name, this.createdAt);

  PostDataModel.fromSnapshot(DataSnapshot snapshot)
      : key = snapshot.value['key'],
        name = snapshot.value['name'],
        createdAt = snapshot.value['createdAt'];
  // updatedAt = snapshot.value['updatedAt'],
  // category = snapshot.value['category'];
}