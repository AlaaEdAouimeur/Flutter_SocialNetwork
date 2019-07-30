import 'package:flutter/material.dart';
import '../database/databaseReferences.dart' as databaseReferences;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class WriteTab extends StatefulWidget {
  WriteTab({Key key}) : super(key: key);

  WriteTabState createState() => WriteTabState();
}

class WriteTabState extends State<WriteTab> {
  Future<FirebaseUser> user = FirebaseAuth.instance.currentUser();
  TextEditingController writeupController = TextEditingController();
  String loadingText = "sending";
  IconData loadingIcon = Icons.cloud_upload;

  Widget build(BuildContext context) {
    return Material(
      child: SafeArea(
        child: Scaffold(
          body: Container(
            padding: EdgeInsets.all(20),
            color: Colors.white,
            child: Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.only(bottom: 10.0),
                    child: TextFormField(
                      style: TextStyle(
                        color: Colors.green,
                        fontSize: 24.0,
                      ),
                      decoration: InputDecoration(
                        hintText: "Title",
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  Flexible(
                    fit: FlexFit.tight,
                    child: Container(
                      child: TextFormField(
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: 'Start writing...',
                        ),
                        controller: writeupController,
                        keyboardType: TextInputType.multiline,
                        maxLines: 10,
                      ),
                    ),
                  ),
                  Container(
                    child: RaisedButton(
                      child: Text("Submit"),
                      onPressed: () => user.then((user) => {
                            insertData(
                                user.displayName, writeupController.text, user.uid),
                          }),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void updateUser(String uid) {
    databaseReferences.DatabaseReferences()
        .userDatabaseReference
        .where('uid', isEqualTo: uid)
        .getDocuments()
        .then((query) => {
              print(query.documents.first.documentID),
              databaseReferences.DatabaseReferences()
                  .userDatabaseReference
                  .document(query.documents.first.documentID)
                  .updateData({"posts": FieldValue.increment(1)}).then(
                      (data) => print("User value updated")),
            });
  }

  void insertData(String name, String writeup, String uid) {
    var value = {
      "uid": uid,
      "name": name,
      "writeup": writeup,
      "createdAt": DateTime.now(),
      "upvotes": 0,
      "upvotedUsers": [],
      "tpqSelected": false,
    };
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return Center(
            child: SizedBox(
              height: 50.0,
              width: 50.0,
              child: CircularProgressIndicator(),
            ),
          );
        });
    databaseReferences.DatabaseReferences()
        .postDatabaseReference
        .document()
        .setData(value)
        .then((_) => {
              updateUser(uid),
              print("Here"),
              Future.delayed(
                  Duration(seconds: 2),
                  () => {
                        print("After 2 seconds"),
                        Navigator.pop(context),
                        Navigator.pop(context),
                      }),
            });
  }
}
