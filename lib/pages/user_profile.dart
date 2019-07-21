import 'package:flutter/material.dart';

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
      child: Text(documentID),
    );
  }
}