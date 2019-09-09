import 'package:flutter/material.dart';
import '../database/databaseReferences.dart' as databaseReferences;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';

class WriteTab extends StatefulWidget {
  WriteTab({Key key}) : super(key: key);

  WriteTabState createState() => WriteTabState();
}

class WriteTabState extends State<WriteTab> {
  FirebaseUser currentUser;
  TextEditingController writeupController = TextEditingController();
  TextEditingController topicController = TextEditingController();
  static const postCategories = <String>[
    'Microtale',
    "Short story",
    "Snippet",
    "Quote",
    "Blog",
  ];
  String dropdownValue = 'Microtale';

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

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
                  postCategory(),
                  titleField(),
                  writingField(),
                  submitButton(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Container postCategory() {
    return Container(
      color: Colors.white,
      height: 50.0,
      padding: EdgeInsets.only(left: 15.0, right: 15.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            "Category  :  ",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.teal,
              fontSize: 16,
            ),
          ),
          Container(
            padding: EdgeInsets.only(left: 10.0, right: 10.0),
            margin: EdgeInsets.only(top: 8.0, bottom: 8.0),
            decoration: BoxDecoration(
              color: Color.fromRGBO(0, 128, 128, 0.2),
              borderRadius: BorderRadius.circular(5.0),
            ),
            child: DropdownButton<String>(
              value: dropdownValue,
              style: TextStyle(
                color: Colors.teal,
              ),
              icon: Icon(
                EvaIcons.arrowIosDownward,
                color: Colors.teal,
              ),
              onChanged: (String newValue) {
                setState(() {
                  dropdownValue = newValue;
                });
              },
              items:
                  postCategories.map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Container submitButton() {
    return Container(
      child: RaisedButton(
        child: Text("Submit"),
        onPressed: () => FirebaseAuth.instance.currentUser().then((user) => {
              currentUser = user,
              insertData(),
            }),
      ),
    );
  }

  Flexible writingField() {
    return Flexible(
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
    );
  }

  Container titleField() {
    return Container(
      margin: EdgeInsets.only(bottom: 10.0),
      child: TextFormField(
        controller: topicController,
        style: TextStyle(
          color: Colors.green,
          fontSize: 24.0,
        ),
        decoration: InputDecoration(
          hintText: "Title",
          border: InputBorder.none,
        ),
      ),
    );
  }

  updateUser() {
    databaseReferences.DatabaseReferences()
        .users
        .where('uid', isEqualTo: currentUser.uid)
        .getDocuments()
        .then((query) => {
              print(query.documents.first.documentID),
              databaseReferences.DatabaseReferences()
                  .users
                  .document(query.documents.first.documentID)
                  .updateData({"posts": FieldValue.increment(1)}).then(
                      (data) => print("User value updated")),
            });
  }

  getFollowersList() {
    return databaseReferences.DatabaseReferences()
        .users
        .where('uid', isEqualTo: currentUser.uid)
        .getDocuments();
  }

  insertPost() async {
    QuerySnapshot query;
    query = await getFollowersList();
    List<dynamic> visibleTo = query.documents.first.data["followers_uid"];
    var value = {
      "uid": currentUser.uid,
      "topic": topicController.text,
      "name": currentUser.displayName,
      "writeup": writeupController.text,
      "createdAt": DateTime.now(),
      "upvotes": 0,
      "upvotedUsers": [],
      "tpqSelected": false,
      "visibleTo": visibleTo,
    };

    databaseReferences.DatabaseReferences().posts.document().setData(value);
  }

  void insertData() async {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return Center(
            child: SizedBox(
              height: 50.0,
              width: 50.0,
              child: Icon(EvaIcons.upload),
            ),
          );
        });
    await insertPost();
    await updateUser();
    Navigator.pop(context);
    Navigator.pop(context);
  }
}
