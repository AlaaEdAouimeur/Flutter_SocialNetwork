import 'package:flutter/material.dart';
import '../database/databaseReferences.dart' as databaseReference;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:strings/strings.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SearchTab extends StatefulWidget {
  SearchTab({Key key}) : super(key: key);

  @override
  SearchTabState createState() => SearchTabState();
}

class SearchTabState extends State<SearchTab> {
  double widthOfContainer;
  static FirebaseUser currentUser;

  @override
  void initState() {
    super.initState();
    getCurrentUser().then((user) => setCurrentUser(user));
  }

  setCurrentUser(user) {
    setState(() {
      currentUser = user;
    });
  }

  Widget build(BuildContext context) {
    widthOfContainer = MediaQuery.of(context).size.width;
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: <Widget>[
            Center(
              child: Container(
                height: 40,
                width: widthOfContainer,
                margin: EdgeInsets.all(10.0),
                padding: EdgeInsets.all(10.0),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.black12,
                    style: BorderStyle.solid,
                    width: 1.0,
                  ),
                  borderRadius: BorderRadius.all(
                    Radius.circular(5),
                  ),
                ),
                child: GestureDetector(
                  child: Text("Search"),
                  onTap: () =>
                      showSearch(context: context, delegate: UserSearch()),
                ),
              ),
            ),
            Flexible(
              child: categoryList(widthOfContainer),
            ),
          ],
        ),
      ),
    );
  }

  Widget categoryList(double widthOfContainer) {
    return StreamBuilder<QuerySnapshot>(
        stream: databaseReference.DatabaseReferences()
            .categoryDatabaseReference
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
              return new Container(
                width: widthOfContainer,
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              );
              break;
            default:
              return new ListView.builder(
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  itemCount: snapshot.data.documents.length,
                  itemBuilder: (context, index) {
                    return categoryListBuilder(snapshot.data.documents[index]);
                  });
              break;
          }
        });
  }

  Widget suggestionList(String query) {
    return StreamBuilder<QuerySnapshot>(
        stream: databaseReference.DatabaseReferences()
            .userDatabaseReference
            .where('name', isGreaterThanOrEqualTo: query)
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
              return new Container(
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              );
              break;
            default:
              return new ListView.builder(
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  itemCount: snapshot.data.documents.length,
                  itemBuilder: (context, index) {
                    return suggestionsListBuilder(
                        snapshot.data.documents[index], context);
                  });
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
          Container(
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
                        image: new NetworkImage(snapshot["profilePictureUrl"]),
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

  Future<QuerySnapshot> getCurrentUserDbReference() async {
    FirebaseUser currentUser = await getCurrentUser();
    return databaseReference.DatabaseReferences()
        .userDatabaseReference
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
        ? unfollowUser(documentID, snapshot)
        : followUser(documentID, snapshot);
  }

  followUser(String documentID, snapshot) async {
    print("Follow");
    databaseReference.DatabaseReferences()
        .userDatabaseReference
        .document(documentID)
        .updateData({
      "followers_uid": FieldValue.arrayUnion([currentUser.uid])
    });
    databaseReference.DatabaseReferences()
        .userDatabaseReference
        .where('uid', isEqualTo: currentUser.uid)
        .getDocuments()
        .then((query) => {
              databaseReference.DatabaseReferences()
                  .userDatabaseReference
                  .document(query.documents[0].documentID)
                  .updateData({
                "followings_uid": FieldValue.arrayUnion([snapshot["uid"]])
              }),
            });
  }

  unfollowUser(String documentID, snapshot) async {
    print("HERE");
    databaseReference.DatabaseReferences()
        .userDatabaseReference
        .document(documentID)
        .updateData({
      "followers_uid": FieldValue.arrayRemove([currentUser.uid])
    });
    databaseReference.DatabaseReferences()
        .userDatabaseReference
        .where('uid', isEqualTo: currentUser.uid)
        .getDocuments()
        .then((query) => {
              databaseReference.DatabaseReferences()
                  .userDatabaseReference
                  .document(query.documents[0].documentID)
                  .updateData({
                "followings_uid": FieldValue.arrayRemove([snapshot["uid"]])
              }),
            });
  }

  Widget categoryListBuilder(DocumentSnapshot snapshot) {
    return new Container(
      child: Text(snapshot["category_name"] == null
          ? "Null"
          : snapshot["category_name"]),
    );
  }
}

class UserSearch extends SearchDelegate<String> {
  SearchTabState searchTabState = new SearchTabState();
  FirebaseUser currentUser = SearchTabState.currentUser;

  @override
  List<Widget> buildActions(BuildContext context) {
    // TODO: implement buildActions
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = "";
        },
      )
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    // TODO: implement buildLeading
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    // TODO: implement buildResults
    return null;
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    // TODO: implement buildSuggestions
    return Container(
      child: searchTabState.suggestionList(query),
    );
  }
}
