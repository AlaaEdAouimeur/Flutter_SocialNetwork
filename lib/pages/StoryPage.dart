import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class StoryPage extends StatefulWidget {
  final String collectionName;
  final DocumentSnapshot snapshot;

  StoryPage({
    this.collectionName,
    this.snapshot,
  });

  @override
  _StoryPageState createState() => _StoryPageState();
}

class _StoryPageState extends State<StoryPage> {
  FirebaseUser currentUser;
  bool hasUpvotedBlog = false;

  @override
  void initState() {
    super.initState();
    FirebaseAuth.instance.currentUser().then((user) {
      currentUser = user;
    });
  }

// JUST A TESTING STORY PAGE

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Container(
          child: SingleChildScrollView(
            child: Container(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Text(
                    'Dummy Title',
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
                  Text(
                    "by " + 'dummy_author',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                      letterSpacing: 0.2,
                      fontSize: 16,
                    ),
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  Text(
                    'This is the dummy body of the dummy story. When implemented actually, they will send collection name and snapshot which will be used to display the actual content using stream builder.',
                    textAlign: TextAlign.start,
                    style: TextStyle(
                      color: Colors.white,
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
                        child: Icon(
                          FontAwesomeIcons.grinHearts,
                          color: Colors.white,
                          size: 24.0,
                        ),
                      ),
                      SizedBox(
                        width: 10.0,
                      ),
                      Text(
                        '0',
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
          ),
        ),
      ),
    );
  }

// MAIN STORY PAGE WITH BACKEND
  // @override
  // Widget build(BuildContext context) {
  //   return Scaffold(
  //     backgroundColor: Colors.black,
  //     body: SafeArea(
  //       child: Container(
  //         child: StreamBuilder(
  //           stream: Firestore.instance
  //               .collection(widget.collectionName)
  //               .document(widget.snapshot.documentID)
  //               .snapshots(),
  //           builder: (context, snapshot) {
  //             switch (snapshot.connectionState) {
  //               case ConnectionState.waiting:
  //                 print("waiting");
  //                 return new Container(
  //                   width: MediaQuery.of(context).size.width,
  //                   child: Container(
  //                     color: Colors.black,
  //                     child: Center(
  //                       child: CircularProgressIndicator(),
  //                     ),
  //                   ),
  //                 );
  //                 break;

  //               default:
  //                 return SingleChildScrollView(
  //                   child: Container(
  //                     padding: const EdgeInsets.all(20.0),
  //                     child: Column(
  //                       crossAxisAlignment: CrossAxisAlignment.start,
  //                       children: <Widget>[
  //                         Text(
  //                           snapshot.data['title'],
  //                           style: TextStyle(
  //                             fontWeight: FontWeight.w600,
  //                             color: Colors.white,
  //                             letterSpacing: 0.2,
  //                             fontSize: 25,
  //                           ),
  //                         ),
  //                         SizedBox(
  //                           height: 20.0,
  //                         ),
  //                         Text(
  //                           "by " + snapshot.data['user_display_name'],
  //                           style: TextStyle(
  //                             fontWeight: FontWeight.w600,
  //                             color: Colors.white,
  //                             letterSpacing: 0.2,
  //                             fontSize: 16,
  //                           ),
  //                         ),
  //                         SizedBox(
  //                           height: 20.0,
  //                         ),
  //                         Text(
  //                           snapshot.data['content'],
  //                           textAlign: TextAlign.start,
  //                           style: TextStyle(
  //                             color: Colors.white,
  //                             fontSize: 18,
  //                             height: 1.1,
  //                             letterSpacing: 0.3,
  //                           ),
  //                         ),
  //                         SizedBox(
  //                           height: 40.0,
  //                         ),
  //                         Row(
  //                           mainAxisAlignment: MainAxisAlignment.start,
  //                           children: <Widget>[
  //                             GestureDetector(
  //                               child: getUpIcon(widget.snapshot.documentID),
  //                               onTap: () => {
  //                                 upVote(widget.snapshot.documentID),
  //                               },
  //                             ),
  //                             SizedBox(
  //                               width: 10.0,
  //                             ),
  //                             Text(
  //                               snapshot.data['upvoted_users'] == null
  //                                   ? '0'
  //                                   : snapshot.data['upvoted_users'].length
  //                                       .toString(),
  //                               style: TextStyle(
  //                                   color: Colors.white,
  //                                   fontSize: 20.0,
  //                                   fontWeight: FontWeight.bold),
  //                             ),
  //                           ],
  //                         ),
  //                       ],
  //                     ),
  //                   ),
  //                 );
  //             }
  //           },
  //         ),
  //       ),
  //     ),
  //   );
  // }

  Future<DocumentSnapshot> getUpvotedUserList(String documentID) {
    return Firestore.instance
        .collection(widget.collectionName)
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
    DocumentReference storyRef = Firestore.instance
        .collection(widget.collectionName)
        .document(documentID);
    if (hasUpvotedBlog) {
      hasUpvotedBlog = false;
      storyRef.updateData({
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
      storyRef.updateData({
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
