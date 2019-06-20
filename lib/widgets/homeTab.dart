import 'package:flutter/material.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:firebase_database/firebase_database.dart';
import '../database/databaseReferences.dart' as databaseReference;
import 'package:eva_icons_flutter/eva_icons_flutter.dart';

class HomeTab extends StatefulWidget {
  HomeTab({Key key}) : super(key: key);

  @override
  _HomeTabState createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> {
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black,
      child: Column(
        children: <Widget>[
          Flexible(
            child: FirebaseAnimatedList(
                query: databaseReference.DatabaseReferences()
                    .postDatabaseReference,
                itemBuilder: (BuildContext context, DataSnapshot snapshot,
                    Animation<double> animation, int index) {
                  return new Container(
//                    color: Colors.red,
                    margin: EdgeInsets.only(
                        left: 25.0, right: 25.0, top: 20.0, bottom: 10.0),
                    child: shortPostBody(snapshot),
                  );
                }),
          ),
        ],
      ),
    );
  }

  Widget shortPostBody(DataSnapshot snapshot) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          snapshot.value['writeup'],
          style: TextStyle(
              color: Colors.white,
              letterSpacing: 0.1,
              height: 1.1,
              fontSize: 18),
          textAlign: TextAlign.left,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Container(
//              color: Colors.orange,
              child: Text(
                snapshot.value['name'],
                style: TextStyle(
                  color: Colors.green,
                  letterSpacing: 1.0,
                  fontSize: 14.0,
                  height: 2.0,
                ),
              ),
            ),
            Container(
//              color: Colors.red,
              child: Row(
                children: <Widget>[
                  Icon(
                    EvaIcons.email,
                    color: Colors.white,
                  ),
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
