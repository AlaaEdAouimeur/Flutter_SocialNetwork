import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../database/databaseReferences.dart' as databaseReference;
import 'PostList.dart';
import '../widgets/CategoryDropdown.dart';
import 'package:cloud_functions/cloud_functions.dart';

class DropdownValueHolder {
  static String dropdownValue = "TPQ Selected";
}

class HomeTab extends StatefulWidget {
  String getDropdownValue() {
    return DropdownValueHolder.dropdownValue;
  }

  void setDropdownValue(String dropdownValue) {
    DropdownValueHolder.dropdownValue = dropdownValue;
  }

  HomeTab() {
    print("Constructor called");
  }

  @override
  _HomeTabState createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> {
  ScrollController scrollController;
  String category;
  Stream<QuerySnapshot> query;
  final HttpsCallable callable = CloudFunctions.instance.getHttpsCallable(
    functionName: 'helloWorld',
  );

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  categoryChanged() {
    setState(() {
      category = CategoryHelperFunction().getDropdownValue();
    });
  }

  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          child: Column(
            children: <Widget>[
              CategoryDropdown(notifyParent: categoryChanged),
              Flexible(
                child: streamBuilder(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Stream<QuerySnapshot> buildQuery() {
    Stream<QuerySnapshot> query;
    switch (category) {
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

  callCloudFunction() async {
    dynamic response = await callable.call(<String, dynamic>{
      'request': 'YOUR_PARAMETER_VALUE',
    });
    print(response.toString());
  }

  Widget streamBuilder() {
    query = buildQuery();
    return StreamBuilder<QuerySnapshot>(
        stream: query,
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
              return new Container(
                width: MediaQuery.of(context).size.width,
                child: Container(
                  color: Colors.black,
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                ),
              );
              break;
            default:
              return Column(
                children: <Widget>[
                  Center(
                    child:
                        RaisedButton(child: Text("Button"), onPressed: () {
                          callCloudFunction();
                        }),
                  ),
                  Expanded(
                    child: Container(
                      color: Color.fromRGBO(7, 8, 11, 1),
                      child: PostList(snapshot),
                    ),
                  ),
                ],
              );
              break;
          }
        });
  }
}
