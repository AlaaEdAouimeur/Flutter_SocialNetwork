import 'package:flutter/material.dart';
import '../database/databaseReferences.dart' as databaseReferences;
import 'package:firebase_auth/firebase_auth.dart';

class WriteTab extends StatefulWidget {
  WriteTab({Key key}) : super(key: key);

  WriteTabState createState() => WriteTabState();
}

class WriteTabState extends State<WriteTab> {
  Widget build(BuildContext context) {
    Future<FirebaseUser> user = FirebaseAuth.instance.currentUser();
    TextEditingController writeupController = TextEditingController();
    return Material(
      child: Container(
        padding: EdgeInsets.only(left: 20, right: 20),
        color: Colors.white,
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                height: MediaQuery.of(context).size.height - 150,
                child: TextField(
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: 'Start writing...',
                  ),
                  controller: writeupController,
                  keyboardType: TextInputType.multiline,
                  maxLines: 999,
                ),
              ),
              RaisedButton(
                child: Text("Submit"),
                onPressed: () => user.then((user) => {
                      insertData(user.displayName, writeupController.text),
                    }),
              )
            ],
          ),
        ),
      ),
    );
  }

  void insertData(String name, String writeup) {
    var value = {"name": name, "writeup": writeup};
    databaseReferences.DatabaseReferences()
        .postDatabaseReference
        .push()
        .set(value)
        .then((value) => {
              print("Data Stored"),
            });
    setState(() {});
  }
}
