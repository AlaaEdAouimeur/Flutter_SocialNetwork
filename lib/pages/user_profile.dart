import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../database/databaseReferences.dart' as databaseReference;
import 'package:strings/strings.dart';

class SearchedUserProfile extends StatefulWidget {
  String documentID;
  SearchedUserProfile(this.documentID);

  @override
  SearchedUserProfileState createState() => SearchedUserProfileState(this.documentID);
}

class SearchedUserProfileState extends State<SearchedUserProfile> {
  String documentID;
  SearchedUserProfileState(this.documentID);
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.only(left: 10.0, top: 10.0, right: 10.0),
      child: FutureBuilder<DocumentSnapshot>(
          future: databaseReference
              .DatabaseReferences()
              .userDatabaseReference
          .document(documentID)
          .get(),
          builder: (BuildContext context,
              AsyncSnapshot<DocumentSnapshot> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return new Container(
                width: MediaQuery
                    .of(context)
                    .size
                    .width,
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              );
            } else {
              return new ListView(
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      profilePicture(snapshot.data["profilePictureUrl"]),
                      Padding(
                        padding: EdgeInsets.only(left: 20),
                        child: Column(
                          children: <Widget>[
                            Container(
                              height: 30,
                              child: Center(
                                child: Text(
                                  camelize(snapshot.data["name"]),
                                  style: TextStyle(
                                    color: Colors.green,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              );
            }
          }),
    );
  }

  Widget profilePicture(String photoUrl) {
    return Container(
      width: 50,
      height: 50,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        image: new DecorationImage(
          fit: BoxFit.fill,
          image: new NetworkImage(photoUrl),
        ),
      ),
    );
  }
}