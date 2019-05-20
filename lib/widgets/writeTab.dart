import 'package:flutter/material.dart';
import '../database/databaseReferences.dart' as databaseReferences;

class WriteTab extends StatefulWidget {
  WriteTab({Key key}) : super(key: key);

  WriteTabState createState() => WriteTabState();
}

class WriteTabState extends State<WriteTab> {

  Widget build(BuildContext context) {
    TextEditingController nameController = TextEditingController();
    TextEditingController writeupController = TextEditingController();
    return Column(
      children: <Widget>[
        TextField(
          decoration: InputDecoration(
            helperText: "Enter your name",
          ),
          controller: nameController,
        ),
        TextField(
          decoration: InputDecoration(
            helperText: "Enter your writeup",
          ),
          controller: writeupController,
        ),
        RaisedButton(
          child: Text("Submit"),
          onPressed: () =>
              insertData(nameController.text, writeupController.text),
        )
      ],
    );
  }

  void insertData(String name, String writeup) {
    var value = {"name": name, "writeup": writeup};
    databaseReferences.DatabaseReferences().postDatabaseReference.push().set(value).then((value) => {
          print("Data Stored"),
        });
    setState(() {
    });
  }
}
