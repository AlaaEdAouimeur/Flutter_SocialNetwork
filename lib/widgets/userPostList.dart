import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:redux_example/widgets/PostList.dart';
import 'package:redux_example/widgets/SearchTab.dart';
import 'package:strings/strings.dart';
import '../database/databaseReferences.dart' as databaseReference;

class Userpostlist extends StatefulWidget {
  final String title;
  final DocumentSnapshot snapshot;
  Userpostlist({this.title,this.snapshot});
  _UserpostlistState createState() => _UserpostlistState();
}

class _UserpostlistState extends State<Userpostlist> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        leading: IconButton(
            icon: Icon(
              Icons.arrow_back,
              color: Colors.black,
            ),
            onPressed: () => Navigator.pop(context)),
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
         '${ widget.title} by ${camelize(widget.snapshot["name"])}',
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: Center(
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                  decoration:InputDecoration(
                            filled: true,
                            fillColor: Colors.white,
                            hintText: "Find Something To Watch",
                            prefixIcon: Icon(Icons.search,color: Colors.grey,),
                            //  disabledBorder: b,
                            border: OutlineInputBorder(
                                borderSide: BorderSide.none,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(15.0)))),),
            ),
            Expanded(child: streamBuilder())
          ],
        ),
      ),
    );
  }
  
  Widget streamBuilder() {
    print( widget.snapshot["uid"]);
   Stream<QuerySnapshot> query = databaseReference.DatabaseReferences().posts.where("uid" ,isEqualTo : widget.snapshot["uid"]).snapshots();
    if (query == null) {
      print("Query is null");
      return new Container(
        width: MediaQuery.of(context).size.width,
        child: Container(
          color: Colors.black,
          child: Center(
            child: CircularProgressIndicator(),
          ),
        ),
      );
     } else {
      return StreamBuilder<QuerySnapshot>(
          stream: query,
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.waiting:
                print("waiting");
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
                if(snapshot.data.documents.length == 0) {
                  return Container(
                    color: Colors.black,
                    child: Center(
                      child: Container(
                        child: Text(
                          "Nothing To Show\nChoose Another Category",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  );
                } else {
                  print(snapshot.data.documents.length);
                  return Column(
                    children: <Widget>[
                      Expanded(
                        child: Container(
                          height: 400,
                          color: Color.fromRGBO(7, 8, 11, 1),
                          child: PostList(snapshot),
                        ),
                      ),
                    ],
                  );
                }
                break;
            }
          });
}
  }
}