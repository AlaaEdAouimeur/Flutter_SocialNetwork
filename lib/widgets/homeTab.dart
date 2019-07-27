import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../database/databaseReferences.dart' as databaseReference;
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'writeTab.dart';
import '../widgets/PostBody.dart';

class HomeTab extends StatefulWidget {
  HomeTab({Key key}) : super(key: key);

  @override
  _HomeTabState createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> {

  @override
  void initState() {
    super.initState();
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
                      child: Container(
                        color: Color.fromRGBO(7, 8, 11, 1),
                        child: ListView.builder(
                            itemCount: snapshot.data.documents.length,
                            itemBuilder: (context, index) {
                              return Column(
                                children: <Widget>[
                                  new Container(
                                    margin: EdgeInsets.all(25.0),
                                    child:
                                        PostBody(snapshot.data.documents[index]),
                                  ),
                                  Center(
                                    child: Container(
                                      width: MediaQuery.of(context).size.width/2,
                                      child: Divider(
                                        color: Color.fromRGBO(255, 255, 255, 0.3),
                                      ),
                                    ),
                                  ),
                                ],
                              );
                            }),
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
