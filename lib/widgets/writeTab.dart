import 'package:flutter/material.dart';
import '../database/databaseReferences.dart' as databaseReferences;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

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
            style: Theme.of(context).textTheme.subhead,
          ),
          Container(
            padding: EdgeInsets.only(left: 10.0, right: 10.0),
            margin: EdgeInsets.only(top: 8.0, bottom: 8.0),
            child: DropdownButton<String>(
              value: dropdownValue,
              style: Theme.of(context).textTheme.subhead,
              icon: Icon(
                FontAwesomeIcons.chevronDown,
                size: 20,
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
        color: Theme.of(context).accentColor,
        child: Text(
          "Submit",
          style: Theme.of(context).textTheme.caption,
        ),
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

  insertBlog() async {
    QuerySnapshot query;
    query = await getFollowersList();
    List<dynamic> visibleTo = query.documents.first.data["followers_uid"];
    var value = {
      "uid": currentUser.uid,
      "title": topicController.text,
      "name": currentUser.displayName,
      "content": writeupController.text,
      "createdAt": DateTime.now(),
      "upvotes": 0,
      "upvotedUsers": [],
      "tpqSelected": false,
      "visibleTo": visibleTo,
    };
    databaseReferences.DatabaseReferences().blogs.document().setData(value);
  }

  void insertData() async {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return Center(
            child: SizedBox(
              height: 50.0,
              width: 50.0,
              child: Icon(
                FontAwesomeIcons.upload,
              ),
            ),
          );
        });
    await updateUser();
    Navigator.pop(context);
    Navigator.pop(context);
  }
}
