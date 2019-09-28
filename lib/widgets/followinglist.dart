import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:redux_example/database/databaseReferences.dart'
    as databaseReference;
import 'package:strings/strings.dart';

class Following extends StatelessWidget {
  List userslist = [];
  Following({this.userslist});

  Widget searchBox() {
    return Container(
      height: 60,
      child: TextField(
        decoration: InputDecoration(
            filled: true,
            fillColor: Colors.white,
            hintText: "Search users",
            prefixIcon: Icon(
              Icons.search,
              color: Colors.grey,
            ),
            //  disabledBorder: b,
            border: OutlineInputBorder(
                borderSide: BorderSide.none,
                borderRadius: BorderRadius.all(Radius.circular(15.0)))),
      ),
    );
  }

  Container flowWidget(BuildContext context, DocumentSnapshot snapshot) {
    var textStyle = TextStyle(
      fontSize: 16,
      color: Color.fromRGBO(0, 0, 0, 0.8),
    );

    return Container(
      margin: EdgeInsets.only(top: 5.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          rowElement(snapshot["followers"].toString(), textStyle,
              'assets/images/followers.png'),
          new VerticalLine(),
          rowElement(snapshot["followings"].toString(), textStyle,
              'assets/images/following.png'),
          new VerticalLine(),
          rowElement(snapshot["blogs"].toString(), textStyle,
              'assets/images/blog.png'),
          new VerticalLine(),
          rowElement(snapshot["posts"].toString(), textStyle,
              'assets/images/post.png'),
        ],
      ),
    );
  }

  GestureDetector rowElement(String data, TextStyle textStyle, String icon) {
    return GestureDetector(
      child: Column(
        children: <Widget>[
          Image.asset(
            icon,
            width: 30,
          ),
          SizedBox(
            width: 5,
          ),
          Text(
            data == null ? "0" : data,
            style: textStyle,
          ),
        ],
      ),
      onTap: () {
        // TODO: Open page
      },
    );
  }

  Widget userList(context) {
    return userslist == null
        ? Expanded(
            child: Container(
            color: Colors.black,
            child: Center(
              child: Container(
                child: Text(
                  "No Following yet.",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ))
        : ListView.builder(
            itemCount: userslist.length,
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
            itemBuilder: (BuildContext context, i) {
              return Column(
                children: <Widget>[
                  userCell(context, userslist[i]),
                  Container(
                    width: MediaQuery.of(context).size.width - 200,
                    child: Divider(
                      color: Color.fromRGBO(0, 0, 0, 0.3),
                    ),
                  ),
                ],
              );
            },
          );
  }

  Widget userCell(context, String uid) {
    Stream<QuerySnapshot> _query = databaseReference.DatabaseReferences()
        .users
        .where("uid", isEqualTo: uid)
        .limit(1)
        .snapshots();
    return StreamBuilder(
      stream: _query,
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> query) {
        if (query.connectionState == ConnectionState.waiting)
          return Center(
            child: CircularProgressIndicator(),
          );
        else {
          DocumentSnapshot snapshot = query.data.documents[0];
          return Container(
            padding: EdgeInsets.symmetric(vertical: 5, horizontal: 5),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                //<-------------User name and username------>//
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    CircleAvatar(
                      radius: 20,
                      backgroundImage: NetworkImage(
                        snapshot["profilePictureUrl"],
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Text(
                      camelize(snapshot["name"]),
                      style: TextStyle(
                        fontSize: 18,
                      ),
                    ),
                    Text(
                      snapshot["username"] == null
                          ? ""
                          : " | " + snapshot["username"],
                      style: TextStyle(
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
                //<-------------UserNumber Of posts and blogs------>//
                flowWidget(context, snapshot),

                //<-------The Follow Button---->
                OutlineButton(
                  color: Colors.yellow,
                  onPressed: () {
                    //TODO Follow user
                  },
                  child: Text('Follow'),
                )
              ],
            ),
          );
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: SafeArea(
        child: Column(
          children: <Widget>[
            searchBox(),
            userList(context),
          ],
        ),
      ),
    );
  }
}

class VerticalLine extends StatelessWidget {
  const VerticalLine({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 30,
      child: VerticalDivider(
        width: 3.0,
        color: Colors.black87,
      ),
    );
  }
}
