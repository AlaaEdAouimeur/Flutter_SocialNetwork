import 'package:flutter/material.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:firebase_database/firebase_database.dart';
import '../database/databaseReferences.dart' as databaseReference;

class HomeTab extends StatefulWidget {
  HomeTab({Key key}) : super(key: key);
  @override
  _HomeTabState createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> {
  
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Flexible(
          child: FirebaseAnimatedList(
              query: databaseReference.DatabaseReferences().postDatabaseReference,
              itemBuilder: (BuildContext context, DataSnapshot snapshot,
                  Animation<double> animation, int index) {
                return new Container(
                  margin: EdgeInsets.only(
                      left: 40.0, right: 40.0, top: 10.0, bottom: 10.0),
                  child: shortPostBody(snapshot),
                );
              }),
        ),
      ],
    );
  }

  Widget shortPostBody(DataSnapshot snapshot) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          snapshot.value['writeup'],
          style: TextStyle(
            color: Colors.grey,
            letterSpacing: 0.5,
            height: 1.2,
          ),
          textAlign: TextAlign.justify,
        ),
        Text(
          snapshot.value['name'],
          style: TextStyle(
            color: Colors.green,
            letterSpacing: 1.0,
            fontSize: 14.0,
            height: 2.0,
          ),
        ),
        Container(
          margin: EdgeInsets.only(top: 10.0, bottom: 20.0),
        ),
        Center(
          child: Container(
            width: 200,
            child: Divider(
              height: 1.0,
              color: Color.fromRGBO(100, 100, 100, 1),
            ),
          ),
        ),
      ],
    );
  }
}
