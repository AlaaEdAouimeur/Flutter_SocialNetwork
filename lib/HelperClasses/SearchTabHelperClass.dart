import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../database/databaseReferences.dart' as databaseReference;
import 'package:strings/strings.dart';
import '../pages/UserProfilePage.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SearchTabHelperClass {
  FirebaseUser currentUser;

  SearchTabHelperClass() {
    getCurrentUser().then((user) => currentUser = user);
  }

  Widget suggestionList(String query) {
    return StreamBuilder<QuerySnapshot>(
        stream: databaseReference.DatabaseReferences().users.snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
              return new Container(
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              );
              break;
            case ConnectionState.active:
              List userList = new List();
              for (int i = 0; i < snapshot.data.documents.length; i++) {
                userList.add(snapshot.data.documents[i]);
                print(snapshot.data.documents[i]["name"]);
              }
              List filteredList = filterList(userList, query);
              return new ListView.builder(
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  itemCount: filteredList.length,
                  itemBuilder: (context, index) {
                    return suggestionsListBuilder(filteredList[index], context);
                  });
              break;

            default:
              return new Container(
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              );
              break;
          }
        });
  }

  Widget suggestionsListBuilder(DocumentSnapshot snapshot, context) {
    return new Container(
      width: MediaQuery.of(context).size.width - 20,
      margin: EdgeInsets.only(left: 10.0, right: 10.0, top: 5.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          GestureDetector(
            child: Container(
              width: MediaQuery.of(context).size.width - 130,
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        image: new DecorationImage(
                          fit: BoxFit.fill,
                          image:
                              new NetworkImage(snapshot["profilePictureUrl"]),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 10.0,
                    ),
                    Expanded(
                      child: Text(
                        camelize(snapshot["name"]),
                        style: TextStyle(),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                    ),
                  ]),
            ),
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => UserProfilePage(snapshot.documentID),
              ),
            ),
          ),
          SizedBox(
            width: 10.0,
          ),
          Container(
            width: 100.0,
            child: FlatButton(
              child: Text(
                getFollowButtonText(snapshot),
                style: TextStyle(
                  color: Colors.blue,
                  fontWeight: FontWeight.bold,
                ),
              ),
              onPressed: () {
                followButtonTap(snapshot.documentID, snapshot);
              },
            ),
          )
        ],
      ),
    );
  }

  filterList(List userList, String query) {
    List filteredList = new List();
    for (int i = 0; i < userList.length; i++) {
      if ((userList[i]["name"].toString().contains(query) ||
              userList[i]["username"].toString().contains(query)) &&
          userList[i]["uid"].toString() != currentUser.uid) {
        filteredList.add(userList[i]);
      }
    }
    return filteredList;
  }

  Future<QuerySnapshot> getCurrentUserDbReference() async {
    FirebaseUser currentUser = await getCurrentUser();
    return databaseReference.DatabaseReferences()
        .users
        .where('uid', isEqualTo: currentUser.uid)
        .getDocuments();
  }

  isFollowing(snapshot) {
    List followersUid = snapshot["followers_uid"] == null
        ? new List()
        : snapshot["followers_uid"];
    return followersUid.contains(currentUser.uid);
  }

  getFollowButtonText(snapshot) {
    return isFollowing(snapshot) ? "Unfollow" : "Follow";
  }

  Future<FirebaseUser> getCurrentUser() {
    return FirebaseAuth.instance.currentUser();
  }

  followButtonTap(documentID, snapshot) {
    isFollowing(snapshot)
        ? unFollowUser(documentID, snapshot)
        : followUser(documentID, snapshot);
  }

  followUser(String documentID, snapshot) async {
    databaseReference.DatabaseReferences()
        .users
        .document(documentID)
        .updateData({
      "followers_uid": FieldValue.arrayUnion([currentUser.uid]),
      "followers": FieldValue.increment(1),
    });
    databaseReference.DatabaseReferences()
        .users
        .where('uid', isEqualTo: currentUser.uid)
        .getDocuments()
        .then((query) => {
              databaseReference.DatabaseReferences()
                  .users
                  .document(query.documents[0].documentID)
                  .updateData({
                "followings_uid": FieldValue.arrayUnion([snapshot["uid"]]),
                "followings": FieldValue.increment(1),
              }),
            });
    databaseReference.DatabaseReferences()
        .posts
        .where("uid", isEqualTo: snapshot["uid"])
        .getDocuments()
        .then((posts) => {
              addVisibleToId(posts),
            });
  }

  addVisibleToId(QuerySnapshot posts) {
    for (int i = 0; i < posts.documents.length; i++) {
      databaseReference.DatabaseReferences()
          .posts
          .document(posts.documents[i].documentID)
          .updateData({
        "visibleTo": FieldValue.arrayUnion([currentUser.uid]),
      });
    }
  }

  removeVisibleToId(QuerySnapshot posts) {
    for (int i = 0; i < posts.documents.length; i++) {
      databaseReference.DatabaseReferences()
          .posts
          .document(posts.documents[i].documentID)
          .updateData({
        "visibleTo": FieldValue.arrayRemove([currentUser.uid]),
      });
    }
  }

  unFollowUser(String documentID, snapshot) async {
    print("HERE");
    databaseReference.DatabaseReferences()
        .users
        .document(documentID)
        .updateData({
      "followers_uid": FieldValue.arrayRemove([currentUser.uid]),
      "followers": FieldValue.increment(-1),
    });
    databaseReference.DatabaseReferences()
        .users
        .where('uid', isEqualTo: currentUser.uid)
        .getDocuments()
        .then((query) => {
              databaseReference.DatabaseReferences()
                  .users
                  .document(query.documents[0].documentID)
                  .updateData({
                "followings_uid": FieldValue.arrayRemove([snapshot["uid"]]),
                "followings": FieldValue.increment(-1),
              }),
            });
    databaseReference.DatabaseReferences()
        .posts
        .where("uid", isEqualTo: snapshot["uid"])
        .getDocuments()
        .then((posts) => {
              removeVisibleToId(posts),
            });
  }
}
