import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseReferences {
  CollectionReference postDatabaseReference,
      userDatabaseReference;

  DatabaseReferences() {
    final Firestore firestore = Firestore.instance;
    postDatabaseReference = firestore.collection('posts');
    userDatabaseReference = firestore.collection('users');
  }
}