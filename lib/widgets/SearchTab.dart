import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:redux_example/pages/StoryPage.dart';
import '../HelperClasses/SearchTabHelperClass.dart';
import '../database/databaseReferences.dart' as databaseReference;
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class SearchTab extends StatefulWidget {
  SearchTab({Key key}) : super(key: key);

  @override
  SearchTabState createState() => SearchTabState();
}

class SearchTabState extends State<SearchTab> {
  double widthOfContainer;
  static FirebaseUser currentUser;
  SearchTabHelperClass helperClass = new SearchTabHelperClass();

  @override
  void initState() {
    super.initState();
  }

  Widget build(BuildContext context) {
    widthOfContainer = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.all(5),
          child: Column(
            children: <Widget>[
              Center(
                child: Container(
                  width: widthOfContainer,
                  margin: EdgeInsets.all(10.0),
                  padding: EdgeInsets.all(10.0),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Theme.of(context).accentColor,
                      style: BorderStyle.solid,
                      width: 1.0,
                    ),
                    borderRadius: BorderRadius.all(
                      Radius.circular(5),
                    ),
                  ),
                  child: GestureDetector(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Icon(
                          FontAwesomeIcons.search,
                          color: Theme.of(context).accentColor,
                        ),
                        Text(
                          "  Search",
                          style: TextStyle(
                            color: Theme.of(context).accentColor,
                            fontSize: 18.0,
                            fontWeight: FontWeight.w100,
                          ),
                        ),
                      ],
                    ),
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
      ),
    );
  }

  Widget categoryList(double widthOfContainer) {
    return StreamBuilder<QuerySnapshot>(
      stream: databaseReference.DatabaseReferences().category.snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.waiting:
            return new Container(
              color: Theme.of(context).backgroundColor,
              width: widthOfContainer,
              child: Center(
                child: CircularProgressIndicator(),
              ),
            );
            break;
          default:
            return Container(
              padding: EdgeInsets.all(10.0),
              child: ScrollConfiguration(
                behavior: NoGlowScroll(),
                child: ListView.builder(
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  itemCount: snapshot.data.documents.length,
                  itemBuilder: (context, index) {
                    return categoryListBuilder(snapshot.data.documents[index]);
                  },
                ),
              ),
            );
            break;
        }
      },
    );
  }

  Widget categoryListBuilder(DocumentSnapshot snapshot) {
    return new Container(
      margin: EdgeInsets.only(bottom: 20.0),
      padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 15.0),
      decoration: BoxDecoration(
        border: Border.all(
          color: Theme.of(context).accentColor,
        ),
        borderRadius: BorderRadius.circular(5.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            "TOP ${snapshot['category_name'].toString().toUpperCase()}",
            textAlign: TextAlign.start,
            style: TextStyle(color: Theme.of(context).accentColor),
          ),
          SizedBox(
            height: 20.0,
          ),
          Container(
            width: MediaQuery.of(context).size.width,
            height: 100.0,
            child: ScrollConfiguration(
              behavior: NoGlowScroll(),
              child: ListView.builder(
                itemCount: 5,
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => StoryPage(),
                          ),
                        );
                      },
                      child: Image.network(
                        'http://via.placeholder.com/200',
                        height: 100.0,
                        width: 100.0,
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class UserSearch extends SearchDelegate<String> {
  SearchTabHelperClass helperClass = new SearchTabHelperClass();
  FirebaseUser currentUser = SearchTabState.currentUser;

  @override
  List<Widget> buildActions(BuildContext context) {
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
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return Container(
      child: Text("Build result"),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return Container(
      child: helperClass.suggestionList(query),
    );
  }
}

class NoGlowScroll extends ScrollBehavior {
  @override
  Widget buildViewportChrome(
      BuildContext context, Widget child, AxisDirection axisDirection) {
    return child;
  }
}
