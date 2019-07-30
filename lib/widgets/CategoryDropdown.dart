import 'package:flutter/material.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../database/databaseReferences.dart' as databaseReference;

class DropdownValueHolder {
  static String dropdownValue = "Following";
}

class CategoryHelperFunction {
  String getDropdownValue() {
    return DropdownValueHolder.dropdownValue;
  }

  void setDropdownValue(String dropdownValue) {
    DropdownValueHolder.dropdownValue = dropdownValue;
  }
}

class CategoryDropdown extends StatefulWidget {
  final Function() notifyParent;
  CategoryDropdown({Key key, @required this.notifyParent}) : super(key: key);
  CategoryHelperFunction categoryHelperFunction = new CategoryHelperFunction();

  CategoryDropdownState createState() => CategoryDropdownState();

  Stream<QuerySnapshot> buildQuery(dropdownValue) {
    Stream<QuerySnapshot> query;
    switch (dropdownValue) {
      case "TPQ Selected":
        query = databaseReference.DatabaseReferences()
            .posts
            .where("tpqSelected", isEqualTo: true)
            .orderBy('createdAt', descending: true)
            .snapshots();
        break;

      case "Following":
        query = databaseReference.DatabaseReferences()
            .posts
            .orderBy('createdAt', descending: true)
            .snapshots();
        break;

      default:
        query = databaseReference.DatabaseReferences()
            .posts
            .orderBy('createdAt', descending: true)
            .snapshots();
        break;
    }
    return query;
  }
}

class CategoryDropdownState extends State<CategoryDropdown> {
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
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
              value: widget.categoryHelperFunction.getDropdownValue(),
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
                  widget.categoryHelperFunction.setDropdownValue(newValue);
                  widget.notifyParent();
                });
              },
              items: <String>[
                'TPQ Selected',
                'Following',
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
    );
  }
}