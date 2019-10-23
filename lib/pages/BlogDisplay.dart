import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:redux_example/database/databaseReferences.dart'
    as databaseReference;
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

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
      if (widget.snapshot.data['upvotedUsers'] != null) {
        List userIds = widget.snapshot.data['upvotedUsers'];
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
      backgroundColor: Theme.of(context).backgroundColor,
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
                      color: Theme.of(context).backgroundColor,
                      child: Center(
                        child: CircularProgressIndicator(),
                      ),
                    ),
                  );
                  break;

                default:
                  return SingleChildScrollView(
                    child: Container(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            snapshot.data['title'],
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              color: Theme.of(context).accentColor,
                              letterSpacing: 0.2,
                              fontSize: 25,
                            ),
                          ),
                          SizedBox(
                            height: 20.0,
                          ),
                          Text(
                            "by " + snapshot.data['name'],
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              color: Theme.of(context).accentColor,
                              letterSpacing: 0.2,
                              fontSize: 16,
                            ),
                          ),
                          SizedBox(
                            height: 20.0,
                          ),
                          Text(
                            snapshot.data['content'],
                            textAlign: TextAlign.start,
                            style: TextStyle(
                              color: Theme.of(context).accentColor,
                              fontSize: 18,
                              height: 1.1,
                              letterSpacing: 0.3,
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
                                snapshot.data['upvotedUsers'] == null
                                    ? '0'
                                    : snapshot.data['upvotedUsers'].length
                                        .toString(),
                                style: TextStyle(
                                    color: Theme.of(context).accentColor,
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
        upIcon = FontAwesomeIcons.solidGrinHearts;
      else
        upIcon = FontAwesomeIcons.grinHearts;
      return Icon(
        upIcon,
        color: Theme.of(context).accentColor,
        size: 24,
      );
    } else {
      return FutureBuilder(
        future: getUpvotedUserList(documentID),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.data['upvotedUsers'] != null) {
              List userIds = snapshot.data['upvotedUsers'];
              if (userIds.contains(currentUser.uid))
                upIcon = FontAwesomeIcons.solidGrinHearts;
              else
                upIcon = FontAwesomeIcons.grinHearts;
            }
          } else {
            upIcon = FontAwesomeIcons.grinHearts;
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
        "upvotedUsers": FieldValue.arrayRemove([currentUser.uid]),
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
        "upvotedUsers": FieldValue.arrayUnion([currentUser.uid]),
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
