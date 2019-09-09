import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:redux_example/database/databaseReferences.dart'
    as databaseReference;

class BlogDisplay extends StatefulWidget {
  final DocumentSnapshot snapshot;

  BlogDisplay({
    @required this.snapshot,
  });

  @override
  _BlogDisplayState createState() => _BlogDisplayState();
}

class _BlogDisplayState extends State<BlogDisplay> {
  FirebaseUser currentUser;
  bool hasUpvotedBlog = false;

  @override
  void initState() {
    super.initState();
    FirebaseAuth.instance.currentUser().then((user) {
      if (widget.snapshot.data['upvoted_users'] != null) {
        List userIds = widget.snapshot.data['upvoted_users'];
        if (userIds.contains(user.uid))
          hasUpvotedBlog = true;
        else
          hasUpvotedBlog = false;
      }
      currentUser = user;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Container(
          child: StreamBuilder(
            stream: databaseReference.DatabaseReferences()
                .blogs
                .document(widget.snapshot.documentID)
                .snapshots(),
            builder: (context, snapshot) {
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
                  return SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            snapshot.data['title'],
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                              letterSpacing: 0.2,
                              fontSize: 25,
                            ),
                          ),
                          SizedBox(
                            height: 20.0,
                          ),
                          Container(
                            width: MediaQuery.of(context).size.width,
                            child: FutureBuilder(
                              future: databaseReference.DatabaseReferences()
                                  .users
                                  .where('uid', isEqualTo: snapshot.data['uid'])
                                  .getDocuments(),
                              builder: (context, userSnapshot) {
                                TextStyle style = TextStyle(
                                  color: Colors.white,
                                  fontSize: 16.0,
                                  fontStyle: FontStyle.italic,
                                  fontWeight: FontWeight.w600,
                                );
                                if (userSnapshot.connectionState ==
                                    ConnectionState.done) {
                                  if (userSnapshot.hasData) {
                                    String userName = userSnapshot
                                        .data.documents[0]['name']
                                        .toString();
                                    return Text(
                                      "- $userName",
                                      textAlign: TextAlign.end,
                                      style: style,
                                    );
                                  }
                                  return Text(
                                    "- Unknown",
                                    style: style,
                                    textAlign: TextAlign.end,
                                  );
                                }
                                return Text(
                                  "Loading...",
                                  style: style,
                                  textAlign: TextAlign.end,
                                );
                              },
                            ),
                          ),
                          SizedBox(
                            height: 20.0,
                          ),
                          Text(
                            snapshot.data['content'],
                            textAlign: TextAlign.justify,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              height: 1.1,
                            ),
                          ),
                          SizedBox(
                            height: 40.0,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              GestureDetector(
                                child: getUpIcon(widget.snapshot.documentID),
                                onTap: () => {
                                  upVote(widget.snapshot.documentID),
                                },
                              ),
                              SizedBox(
                                width: 10.0,
                              ),
                              Text(
                                snapshot.data['upvoted_users'] == null
                                    ? '0'
                                    : snapshot.data['upvoted_users'].length
                                        .toString(),
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 20.0,
                                    fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
              }
            },
          ),
        ),
      ),
    );
  }

  Future<DocumentSnapshot> getUpvotedUserList(String documentID) {
    return databaseReference.DatabaseReferences()
        .blogs
        .document(documentID)
        .get()
        .then((snapshot) {
      return snapshot;
    });
  }

  Widget getUpIcon(String documentID) {
    IconData upIcon;
    if (currentUser != null) {
      if (hasUpvotedBlog)
        upIcon = EvaIcons.arrowCircleUp;
      else
        upIcon = EvaIcons.arrowCircleUpOutline;
      return Icon(
        upIcon,
        color: Colors.white,
        size: 24,
      );
    } else {
      return FutureBuilder(
        future: getUpvotedUserList(documentID),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.data['upvoted_users'] != null) {
              List userIds = snapshot.data['upvoted_users'];
              if (userIds.contains(currentUser.uid))
                upIcon = EvaIcons.arrowCircleUp;
              else
                upIcon = EvaIcons.arrowCircleUpOutline;
            }
          } else {
            upIcon = EvaIcons.arrowCircleUpOutline;
          }
          return Icon(
            upIcon,
            color: Colors.white,
            size: 24,
          );
        },
      );
    }
  }

  void upVote(String documentID) async {
    DocumentReference blogRef =
        databaseReference.DatabaseReferences().blogs.document(documentID);
    if (hasUpvotedBlog) {
      hasUpvotedBlog = false;
      blogRef.updateData({
        "upvoted_users": FieldValue.arrayRemove([currentUser.uid]),
      }).then((value) {
        print('Downvoted Successfully.');
        return true;
      }).catchError((error) {
        print('Failed to Downvote: $error');
        return false;
      });
    } else {
      hasUpvotedBlog = true;
      blogRef.updateData({
        "upvoted_users": FieldValue.arrayUnion([currentUser.uid]),
      }).then((value) {
        print('Upvoted Successfully.');
        return true;
      }).catchError((error) {
        print('Failed to Upvote: $error');
        return false;
      });
    }
  }
}
