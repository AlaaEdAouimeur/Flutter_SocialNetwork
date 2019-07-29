import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../database/databaseReferences.dart' as databaseReference;
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'PostList.dart';

class HomeTab extends StatefulWidget {
  String dropdownValue;
  HomeTab({Key key}) : super(key: key);

  @override
  _HomeTabState createState() => _HomeTabState();

  void setDropDownValue(String val) {
    dropdownValue = val;
  }

  String getDropDownValue() {
    return dropdownValue;
  }
}

class _HomeTabState extends State<HomeTab> {
  ScrollController scrollController;
  Stream<QuerySnapshot> query;

  @override
  void initState() {
    widget.dropdownValue = "TPQ Selected";
    if(widget.getDropDownValue() == null) {
      print("Dropdown Value : " + widget.getDropDownValue().toString());
      widget.setDropDownValue('TPQ Selected');
      print("Dropdown Value : " + widget.getDropDownValue().toString());
    }
    super.initState();
  }

  Widget build(BuildContext context) {
    return Scaffold(
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

  Stream<QuerySnapshot> buildQuery(dropdownValue) {
    Stream<QuerySnapshot> query;
    switch (dropdownValue) {
      case "TPQ Selected":
        query = databaseReference.DatabaseReferences()
            .postDatabaseReference
            .where("tpqSelected", isEqualTo: true)
            .orderBy('createdAt', descending: true)
            .snapshots();
        break;

      case "Following":
        query = databaseReference.DatabaseReferences()
            .postDatabaseReference
            .orderBy('createdAt', descending: true)
            .snapshots();
        break;

      default:
        query = databaseReference.DatabaseReferences()
            .postDatabaseReference
            .orderBy('createdAt', descending: true)
            .snapshots();
        break;
    }
    return query;
  }

  Widget streamBuilder() {
    query = buildQuery(widget.getDropDownValue());
    return StreamBuilder<QuerySnapshot>(
        stream: query,
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
                child: Column(
                  children: <Widget>[
                    Container(
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
                              value: widget.getDropDownValue(),
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
                                  widget.setDropDownValue(newValue);
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
                    ),
                    Expanded(
                      child: Container(
                        color: Color.fromRGBO(7, 8, 11, 1),
                        child: PostList(snapshot),
                      ),
                    ),
                  ],
                ),
              );
              break;
          }
        });
  }
}
