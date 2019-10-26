import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../database/databaseReferences.dart' as databaseReference;
import '../pages/UserProfilePage.dart';
import '../animations/fadeInAnimation.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class PostBody extends StatefulWidget {
  final DocumentSnapshot snapshot;

  PostBody(this.snapshot);

  @override
  PostBodyState createState() => PostBodyState();
}

class PostBodyState extends State<PostBody> {
  double containerHeight;
  bool showFull = false;
  FirebaseUser currentUser;
  bool hasUpvotedPost = false;
  IconData upIcon = FontAwesomeIcons.heart;

  @override
  void initState() {
    super.initState();
    FirebaseAuth.instance.currentUser().then((user) {
      if (widget.snapshot.data['upvotedUsers'] != null) {
        List userIds = widget.snapshot.data['upvotedUsers'];
        if (userIds.contains(user.uid))
          hasUpvotedPost = true;
        else
          hasUpvotedPost = false;
      }
      currentUser = user;
    });
  }

  Widget build(BuildContext context) {
    containerHeight =
        showFull ? double.infinity : MediaQuery.of(context).size.width - 80;
    return FadeIn(
      delay: 0,
      child: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            GestureDetector(
              child: Container(
                margin: EdgeInsets.only(bottom: 15.0),
                constraints: BoxConstraints(
                  maxHeight: containerHeight,
                ),
                child: Text(
                  widget.snapshot.data['writeup'],
                  style: Theme.of(context).textTheme.display1,
                  textAlign: TextAlign.justify,
                  softWrap: true,
                  overflow: TextOverflow.fade,
                ),
              ),
              onTap: () {
                setState(() {
                  showFull = !showFull;
                });
              },
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Align(
                  alignment: Alignment.centerLeft,
                  child: GestureDetector(
                    child: Text(
                      widget.snapshot.data['name'].toString().toUpperCase(),
                      style: Theme.of(context).textTheme.subtitle,
                    ),
                    onTap: () {
                      openUserProfile();
                    },
                  ),
                ),
                SizedBox(
                  height: 15,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    GestureDetector(
                      child: getUpIcon(widget.snapshot.documentID),
                      onTap: () => {
                        upVote(widget.snapshot.documentID),
                      },
                    ),
                    SizedBox(
                      width: 6,
                    ),
                    Text(
                      widget.snapshot.data["upvotes"].toString(),
                      style: Theme.of(context).textTheme.display2,
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget getUpIcon(String documentID) {
    IconData upIcon;
    if (currentUser != null) {
      if (hasUpvotedPost)
        upIcon = FontAwesomeIcons.solidHeart;
      else
        upIcon = FontAwesomeIcons.heart;
      return Icon(
        upIcon,
        color: Theme.of(context).accentColor,
        size: 22,
      );
    } else {
      return FutureBuilder(
        future: getUpvotedUserList(documentID),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.data['upvotedUsers'] != null) {
              List userIds = snapshot.data['upvotedUsers'];
              if (userIds.contains(currentUser.uid))
                upIcon = FontAwesomeIcons.solidHeart;
              else
                upIcon = FontAwesomeIcons.heart;
            }
          } else {
            upIcon = FontAwesomeIcons.heart;
          }
          return Icon(
            upIcon,
            color: Theme.of(context).accentColor,
            size: 22,
          );
        },
      );
    }
  }

  Future<DocumentSnapshot> getUpvotedUserList(String documentID) {
    return databaseReference.DatabaseReferences()
        .posts
        .document(documentID)
        .get();
  }

  void upVote(String documentID) async {
    DocumentReference postRef =
        databaseReference.DatabaseReferences().posts.document(documentID);
    if (hasUpvotedPost) {
      hasUpvotedPost = false;
      postRef.updateData({
        "upvotes": FieldValue.increment(-1),
        "upvotedUsers": FieldValue.arrayRemove([currentUser.uid]),
      }).then((value) {
        return true;
      }).catchError((error) {
        return false;
      });
    } else {
      hasUpvotedPost = true;
      postRef.updateData({
        "upvotes": FieldValue.increment(1),
        "upvotedUsers": FieldValue.arrayUnion([currentUser.uid]),
      }).then((value) {
        return true;
      }).catchError((error) {
        return false;
      });
    }
  }

  void updateLikeDB(String documentID, bool status) {}

  void openUserProfile() {
    String uid = widget.snapshot.data["uid"];
    databaseReference.DatabaseReferences()
        .users
        .where("uid", isEqualTo: uid)
        .getDocuments()
        .then(
          (query) => {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    UserProfilePage(query.documents[0].documentID),
              ),
            ),
          },
        );
  }
}
