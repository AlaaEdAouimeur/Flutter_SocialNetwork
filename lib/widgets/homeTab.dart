import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../database/databaseReferences.dart' as databaseReference;
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'writeTab.dart';
import 'package:intl/intl.dart';
import 'package:firebase_auth/firebase_auth.dart';

class HomeTab extends StatefulWidget {
  HomeTab({Key key}) : super(key: key);

  @override
  _HomeTabState createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> {
  var containerHeight;
  var boxConstraint;
  FirebaseUser currentUser;
  bool showFull = false;
  IconData upIcon;
  IconData downIcon;

  @override
  void initState() {
    super.initState();
    FirebaseAuth.instance.currentUser().then((user) => currentUser = user);
  }

  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.border_color),
        backgroundColor: Colors.orange,
        onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => WriteTab(),
              ),
            ),
      ),
      body: Container(
        child: Column(
          children: <Widget>[
            Flexible(
              child: streamBuilder(),
            ),
          ],
        ),
      ),
    );
  }

  Widget streamBuilder() {
    String dropdownValue = 'TPQ Selected';
    return StreamBuilder<QuerySnapshot>(
        stream: databaseReference.DatabaseReferences()
            .postDatabaseReference
            .orderBy('createdAt', descending: true)
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
              return new Container(
                width: MediaQuery.of(context).size.width,
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              );
              break;
            default:
              return SafeArea(
                child: new Column(
                  children: <Widget>[
                    Container(
                      decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                            color: Colors.red,
                            offset: Offset(100, 100),
                          )
                        ]
                      ),
                      height: 50.0,
                      padding: EdgeInsets.only(left: 15.0, right: 15.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Image.asset(
                            'assets/images/logo.png',
                            width: 30,
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
                              underline: Container(),
                              onChanged: (String newValue) {
                                setState(() {
                                  dropdownValue = newValue;
                                });
                              },
                              items: <String>[
                                'TPQ Selected',
                                'Friends',
                                'Top',
                                'All'
                              ].map<DropdownMenuItem<String>>((String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value),
                                );
                              }).toList(),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: ListView.builder(
                          itemCount: snapshot.data.documents.length,
                          itemBuilder: (context, index) {
                            return new Container(
                              color: Color.fromRGBO(7, 8, 11, 1),
                              padding: EdgeInsets.all(15.0),
                              child:
                                  shortPostBody(snapshot.data.documents[index]),
                            );
                          }),
                    ),
                  ],
                ),
              );
              break;
          }
        });
  }

  FutureBuilder getUpIcon(String documentID) {
    List userIds;
    return new FutureBuilder(
      future: getUpvotedUserList(documentID),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.data['upvotedUsers'] != null) {
            userIds = snapshot.data['upvotedUsers'];
            if (userIds.contains(currentUser.uid))
              upIcon = EvaIcons.arrowCircleUp;
            else
              upIcon = EvaIcons.arrowCircleUpOutline;
          }
        }
        return Icon(
          upIcon,
          color: Colors.white,
          size: 18,
        );
      },
      initialData: Icon(
        EvaIcons.arrowCircleUpOutline,
        color: Colors.white,
        size: 18,
      ),
    );
  }

  Future<DocumentSnapshot> getUpvotedUserList(String documentID) {
    return databaseReference.DatabaseReferences()
        .postDatabaseReference
        .document(documentID)
        .get();
  }

  void upVote(String documentID) async {
    DocumentSnapshot snapshot = await getUpvotedUserList(documentID);
    List userIds = snapshot.data["upvotedUsers"];
    if (userIds.contains(currentUser.uid)) {
      databaseReference.DatabaseReferences()
          .postDatabaseReference
          .document(documentID)
          .updateData({
        "upvotes": FieldValue.increment(-1),
      });
    } else {
      databaseReference.DatabaseReferences()
          .postDatabaseReference
          .document(documentID)
          .updateData({
        "upvotes": FieldValue.increment(1),
      });
    }
  }

  void updateUpvotedUserList(String documentID) async {
    DocumentSnapshot snapshot = await getUpvotedUserList(documentID);
    List userIds = snapshot.data["upvotedUsers"];
    if (userIds.contains(currentUser.uid)) {
      databaseReference.DatabaseReferences()
          .postDatabaseReference
          .document(documentID)
          .updateData({
        "upvotedUsers": FieldValue.arrayRemove([currentUser.uid]),
      });
    } else {
      databaseReference.DatabaseReferences()
          .postDatabaseReference
          .document(documentID)
          .updateData({
        "upvotedUsers": FieldValue.arrayUnion([currentUser.uid]),
      });
    }
  }

  Widget shortPostBody(DocumentSnapshot snapshot) {
    containerHeight =
        showFull ? double.infinity : MediaQuery.of(context).size.width - 80;
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          GestureDetector(
            child: Container(
              constraints: BoxConstraints(
                maxHeight: containerHeight,
              ),
              child: Text(
                snapshot.data['writeup'],
                style: TextStyle(
                    color: Colors.white,
                    letterSpacing: 0.2,
                    height: 1.1,
                    fontSize: 20),
                textAlign: TextAlign.left,
                softWrap: true,
                overflow: TextOverflow.fade,
              ),
            ),
            onTap: () {
              print("tap");
              setState(() {
                showFull = !showFull;
              });
            },
          ),
          Container(
            child: Text(
              DateFormat.yMMMd()
                  .format(snapshot.data['createdAt'].toDate())
                  .toString(),
              style: TextStyle(
                color: Color.fromRGBO(255, 255, 255, 0.5),
                letterSpacing: 0.5,
                fontSize: 9.0,
                height: 2.0,
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Container(
                child: Text(
                  snapshot.data['name'],
                  style: TextStyle(
                    color: Color.fromRGBO(255, 255, 255, 0.7),
                    letterSpacing: 0.5,
                    fontSize: 11.0,
                    height: 2.0,
                  ),
                ),
              ),
              Container(
                child: Row(
                  children: <Widget>[
                    GestureDetector(
                      child: getUpIcon(snapshot.documentID),
                      onTap: () => {
                            upVote(snapshot.documentID),
                            updateUpvotedUserList(snapshot.documentID),
                          },
                    ),
                    SizedBox(
                      width: 4,
                    ),
                    GestureDetector(
                      child: Icon(
                        Icons.info,
                        color: Colors.white,
                        size: 18,
                      ),
                      onTap: () => showModalBottomSheet<void>(
                          context: context,
                          builder: (BuildContext context) {
                            return new Column(
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                new ListTile(
                                  leading: new Icon(Icons.warning),
                                  title: new Text('Report'),
                                  onTap: () => print(""),
                                ),
                                new ListTile(
                                  leading: new Icon(Icons.share),
                                  title: new Text('Share'),
                                  onTap: () => print(""),
                                ),
                              ],
                            );
                          }),
                    )
                  ],
                ),
              )
            ],
          ),
          Container(
            margin: EdgeInsets.only(top: 10.0, bottom: 20.0),
          ),
          Center(
            child: Container(
              width: MediaQuery.of(context).size.width - 50,
              child: Divider(
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
