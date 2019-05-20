import 'package:firebase_database/firebase_database.dart';

class DatabaseReferences {
  DatabaseReference postDatabaseReference, parentReference,
      userDatabaseReference;

  DatabaseReferences() {
    final FirebaseDatabase database = FirebaseDatabase.instance;
    parentReference = database.reference();
    postDatabaseReference = database.reference().child('posts');
    userDatabaseReference = database.reference().child('users');
  }
}