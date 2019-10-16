import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:redux_example/database/databaseReferences.dart'
    as databaseReference;
import 'package:strings/strings.dart';

class Following extends StatefulWidget {
  final List userslist;
  Following({this.userslist});

  @override
  _FollowingState createState() => _FollowingState();
}

class _FollowingState extends State<Following> {
  List<DocumentSnapshot> followersList = [];
  List<DocumentSnapshot> searchedFollowers = [];
  bool _ready = true;

  @override
  void initState() {
    super.initState();
    if (widget.userslist != null) {
      _ready = false;
      for (int i = 0; i < widget.userslist.length; i++) {
        databaseReference.DatabaseReferences()
            .users
            .where("uid", isEqualTo: widget.userslist[i])
            .limit(1)
            .getDocuments()
            .then((QuerySnapshot snapshot) {
          followersList.add(snapshot.documents[0]);
          searchedFollowers.add(snapshot.documents[0]);
          if (i == widget.userslist.length - 1) {
            _ready = true;
            setState(() {});
          }
        });
      }
    }
  }

  Widget searchBox() {
    return Container(
      height: 60,
      child: TextField(
        decoration: InputDecoration(
          filled: true,
          fillColor: Theme.of(context).backgroundColor,
          hintText: "Search users",
          prefixIcon: Icon(
            Icons.search,
            color: Colors.grey,
          ),
          border: OutlineInputBorder(
            borderSide: BorderSide.none,
            borderRadius: BorderRadius.all(
              Radius.circular(15.0),
            ),
          ),
        ),
        onChanged: (val) {
          searchedFollowers.clear();
          followersList.forEach((snapshot) {
            if (snapshot.data['name'].toString().contains(val) ||
                snapshot.data['username'].toString().contains(val))
              searchedFollowers.add(snapshot);
          });
          setState(() {});
        },
      ),
    );
  }

  Container flowWidget(BuildContext context, DocumentSnapshot snapshot) {
    var textStyle = TextStyle(
      fontSize: 16,
      color: Theme.of(context).accentColor.withOpacity(0.8),
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
            color: Theme.of(context).accentColor,
            width: 30,
          ),
          SizedBox(
            width: 5,
          ),
          Text(
            data ?? "0",
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
    return widget.userslist == null
        ? Expanded(
            child: Container(
              child: Center(
                child: Container(
                  child: Text(
                    "No one yet.",
                    style: TextStyle(
                      color: Theme.of(context).accentColor,
                      fontSize: 24,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  // child: RaisedButton(
                  //   child: Text('Rule ALL'),
                  //   onPressed: () async {
                  //     List<String> users = [];
                  //     await databaseReference.DatabaseReferences()
                  //         .users
                  //         .getDocuments()
                  //         .then((querySnapshots) {
                  //       querySnapshots.documents.forEach((snapshot) {
                  //         String id = snapshot.data['uid'];
                  //         print(id);
                  //         if (id != 'W4pKpLwCnNZigYdpOsElWk6P0c63') users.add(id);
                  //       });
                  //     });
                  //     await databaseReference.DatabaseReferences()
                  //         .users
                  //         .document('xTD6FVt9ZLJd9JHDOysg')
                  //         .updateData({
                  //       "followers_uid": FieldValue.arrayUnion(users),
                  //       "followers": FieldValue.increment(users.length),
                  //     });
                  //     print('ADDED');
                  //     print(users.toString());
                  //   },
                  // ),
                ),
              ),
            ),
          )
        : Expanded(
            child: ListView.builder(
              itemCount: searchedFollowers.length,
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              itemBuilder: (BuildContext context, i) {
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    //userCell(context, widget.userslist[i]),
                    staticUserCell(context, searchedFollowers[i]),
                    Container(
                      width: MediaQuery.of(context).size.width - 200,
                      child: Divider(
                        color: Theme.of(context).accentColor.withOpacity(0.5),
                      ),
                    ),
                  ],
                );
              },
            ),
          );
  }

  Widget staticUserCell(context, DocumentSnapshot snapshot) {
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
            borderSide: BorderSide(
              color: Theme.of(context).accentColor.withOpacity(0.3),
            ),
            onPressed: () {
              //TODO Follow user
            },
            child: Text('Follow'),
          )
        ],
      ),
    );
  }

  // Widget userCell(context, String uid) {
  //   Stream<QuerySnapshot> _query = databaseReference.DatabaseReferences()
  //       .users
  //       .where("uid", isEqualTo: uid)
  //       .limit(1)
  //       .snapshots();
  //   return StreamBuilder(
  //     stream: _query,
  //     builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> query) {
  //       if (query.connectionState == ConnectionState.waiting)
  //         return Center(
  //           child: CircularProgressIndicator(),
  //         );
  //       else {
  //         DocumentSnapshot snapshot = query.data.documents[0];
  //         return Container(
  //           padding: EdgeInsets.symmetric(vertical: 5, horizontal: 5),
  //           child: Column(
  //             mainAxisAlignment: MainAxisAlignment.start,
  //             crossAxisAlignment: CrossAxisAlignment.start,
  //             children: <Widget>[
  //               //<-------------User name and username------>//
  //               Row(
  //                 mainAxisAlignment: MainAxisAlignment.start,
  //                 children: <Widget>[
  //                   CircleAvatar(
  //                     radius: 20,
  //                     backgroundImage: NetworkImage(
  //                       snapshot["profilePictureUrl"],
  //                     ),
  //                   ),
  //                   SizedBox(
  //                     width: 10,
  //                   ),
  //                   Text(
  //                     camelize(snapshot["name"]),
  //                     style: TextStyle(
  //                       fontSize: 18,
  //                     ),
  //                   ),
  //                   Text(
  //                     snapshot["username"] == null
  //                         ? ""
  //                         : " | " + snapshot["username"],
  //                     style: TextStyle(
  //                       fontSize: 16,
  //                     ),
  //                   ),
  //                 ],
  //               ),
  //               //<-------------UserNumber Of posts and blogs------>//
  //               flowWidget(context, snapshot),

  //               //<-------The Follow Button---->
  //               OutlineButton(
  //                 color: Colors.yellow,
  //                 onPressed: () {
  //                   //TODO Follow user
  //                 },
  //                 child: Text('Follow'),
  //               )
  //             ],
  //           ),
  //         );
  //       }
  //     },
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Theme.of(context).backgroundColor,
      child: SafeArea(
        child: _ready
            ? Column(
                children: <Widget>[
                  searchBox(),
                  userList(context),
                ],
              )
            : Center(
                child: CircularProgressIndicator(),
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
        color: Theme.of(context).accentColor.withOpacity(.87),
      ),
    );
  }
}
