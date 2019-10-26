import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../database/databaseReferences.dart' as databaseReference;
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class DropdownValueHolder {
  static String dropdownValue = 'Following';
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
        DropdownValueHolder.dropdownValue = dropdownValue;
        break;

      case "Following":
        query = databaseReference.DatabaseReferences()
            .posts
            .orderBy('createdAt', descending: true)
            .snapshots();
        DropdownValueHolder.dropdownValue = dropdownValue;
        break;

      default:
        query = databaseReference.DatabaseReferences()
            .posts
            .orderBy('createdAt', descending: true)
            .snapshots();
        DropdownValueHolder.dropdownValue = dropdownValue;
        break;
    }
    return query;
  }
}

class CategoryDropdownState extends State<CategoryDropdown> {
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).backgroundColor,
      height: 50.0,
      padding: EdgeInsets.only(left: 15.0, right: 15.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Row(
            children: <Widget>[
              Image.asset(
                'assets/images/logo.png',
                width: 30,
              ),
              SizedBox(
                width: 10,
              ),
              Text(
                "The Project Quote",
                style: Theme.of(context).textTheme.title,
              ),
            ],
          ),
          Container(
            padding: EdgeInsets.only(left: 10.0, right: 10.0),
            margin: EdgeInsets.only(top: 8.0, bottom: 8.0),
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(5.0),
            ),
            child: DropdownButton<String>(
              value: widget.categoryHelperFunction.getDropdownValue(),
              style: TextStyle(
                color: Theme.of(context).accentColor,
              ),
              icon: Icon(
                FontAwesomeIcons.chevronDown,
                size: 20,
              ),
              underline: Container(),
              onChanged: (String newValue) {
                setState(() {
                  widget.categoryHelperFunction.setDropdownValue(newValue);
                  widget.notifyParent();
                });
              },
              items: <String>['TPQ Selected', 'Following', 'All']
                  .map<DropdownMenuItem<String>>((String value) {
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
