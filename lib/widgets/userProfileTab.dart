import 'dart:io';

import 'package:flutter/material.dart';
import 'package:redux_example/pages/EditProfile.dart';
import 'package:redux_example/widgets/userPostList.dart';
import '../functions/login_functions.dart' as loginFunctions;
import 'package:firebase_auth/firebase_auth.dart';
import '../database/databaseReferences.dart' as databaseReference;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:strings/strings.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';

class UserProfileTab extends StatefulWidget {
  UserProfileTab();

  UserProfileTabState createState() => UserProfileTabState();
}

class UserProfileTabState extends State<UserProfileTab> {
  FirebaseUser currentUser;
  File userimg;
  bool darkTheme = true;
  @override
  void initState() {
    super.initState();
    getCurrentUser();
  }

  void getCurrentUser() async {
    FirebaseUser user = await FirebaseAuth.instance.currentUser();
    setState(() {
      currentUser = user;
    });
  }

  Future pickImg() async {
    File _file;
    _file = await ImagePicker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 50,
    );
    setState(() {
      userimg = _file;
    });
  }

  Widget build(BuildContext context) {
    if (currentUser == null) {
      return new Container(
        width: MediaQuery.of(context).size.width,
        child: Center(
          child: CircularProgressIndicator(),
        ),
      );
    } else {
      return Container(
        decoration: BoxDecoration(
          color: Colors.black,
        ),
        child: StreamBuilder<QuerySnapshot>(
            stream: databaseReference.DatabaseReferences()
                .users
                .where("uid", isEqualTo: currentUser.uid)
                .limit(1)
                .snapshots(),
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> query) {
              if (query.connectionState == ConnectionState.waiting) {
                return new Container(
                  width: MediaQuery.of(context).size.width,
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                );
              } else {
                DocumentSnapshot snapshot = query.data.documents[0];

                return SafeArea(
                  child: Scaffold(
                    body: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          userDetail(snapshot),
                          userBio(snapshot),
                          socialIcons(),
                          flowWidget(snapshot),
                          editProfileButton(snapshot),
                          logoutButton(),
                          themeSwitch(),
                        ],
                      ),
                    ),
                  ),
                );
              }
            }),
      );
    }
  }

  Container themeSwitch() {
    return Container(
      margin: EdgeInsets.only(top: 10.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text("Light Theme"),
          Switch(
              value: darkTheme,
              activeColor: Colors.black,
              onChanged: (value) {
                setState(() {
                  darkTheme = !darkTheme;
                });
                print("Value: " + darkTheme.toString());
              }),
          Text("Dark Theme"),
        ],
      ),
    );
  }

  Container socialIcons() {
    return Container(
      margin: EdgeInsets.only(top: 20.0),
      width: 150,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          IconButton(
            icon: Icon(FontAwesomeIcons.facebookF),
            color: Colors
                .blueAccent, //TODO Gray icon if user is not connected to Facebook
            onPressed: () {
              //TODO Connection/Disconnection button for Facebook
            },
          ),
          IconButton(
            icon: Icon(FontAwesomeIcons.twitter),
            color: Colors
                .lightBlue, //TODO Gray icon if user is not connected to Twitter
            onPressed: () {
              //TODO Connection/Disconnection for Twitter
            },
          ),
          IconButton(
            icon: Icon(FontAwesomeIcons.instagram),
            color: Colors
                .red, //TODO Gray icon if user is not connected to Instagram
            onPressed: () {
              //TODO Connection/Disconnection for Instagram
            },
          ),
        ],
      ),
    );
  }

  Container userDetail(DocumentSnapshot snapshot) {
    print('trying Hard ${snapshot["uid"]}');
    return Container(
      width: MediaQuery.of(context).size.width,
      child: Column(
        children: <Widget>[
          Stack(
            alignment: Alignment.bottomRight,
            children: <Widget>[
              CircleAvatar(
                  radius: 50,
                  backgroundImage: userimg == null
                      ? NetworkImage(
                          snapshot["profilePictureUrl"],
                        )
                      : FileImage(userimg)),
              InkWell(
                child: CircleAvatar(
                  backgroundColor: Colors.orange,
                  child: Icon(
                    Icons.edit,
                    color: Colors.white,
                  ),
                  radius: 12,
                ),
                onTap: () {
                  pickImg();
                },
              )
            ],
          ),
          SizedBox(
            height: 10,
          ),
          Container(
            child: Text(
              camelize(snapshot["name"]),
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color.fromRGBO(0, 0, 0, 0.8),
                letterSpacing: 1,
              ),
            ),
          ),
          /*Loaction*/
          Container(
            child: snapshot["location"] != null
                ? Text(
                    snapshot["location"],
                    style: TextStyle(
                        fontSize: 18,
                        color: Color.fromRGBO(0, 0, 0, 0.6),
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.5),
                  )
                : GestureDetector(
                    child: Text(
                      "Add Location",
                      style: TextStyle(
                        fontSize: 18,
                        letterSpacing: 0.5,
                      ),
                    ),
                    onTap: () {
                      //TODO: Open edit profile page
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Container userBio(DocumentSnapshot snapshot) {
    return Container(
      margin: EdgeInsets.only(top: 20.0, bottom: 20.0),
      width: 300,
      child: Center(
        child: snapshot["bio"] != null
            ? Text(
                snapshot["bio"],
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 18,
                    color: Color.fromRGBO(0, 0, 0, 0.8),
                    fontWeight: FontWeight.bold),
              )
            : GestureDetector(
                child: Text(
                  'Add Your Bio',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 18,
                    color: Color.fromRGBO(0, 0, 0, 0.8),
                  ),
                ),
              ),
      ),
    );
  }

  Container editProfileButton(DocumentSnapshot snapshot) {
    return Container(
      width: 200,
      margin: EdgeInsets.only(
        top: 20,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(50),
        color: Color.fromRGBO(0, 168, 107, 1),
      ),
      padding: EdgeInsets.only(
        left: 20,
        right: 20,
      ),
      child: FlatButton(
        child: Text(
          "Edit Profile",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        onPressed: () => {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => EditProfile(
                documentID: snapshot.documentID,
              ),
            ),
          ),
        },
      ),
    );
  }

  Container logoutButton() {
    return Container(
      width: 200,
      margin: EdgeInsets.only(top: 6),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(50),
        color: Color.fromRGBO(234, 60, 83, 1),
      ),
      padding: EdgeInsets.only(
        left: 20,
        right: 20,
      ),
      child: FlatButton(
        child: Text(
          "Logout",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        onPressed: () => loginFunctions.LoginFunctions().logout(),
      ),
    );
  }

  Container flowWidget(DocumentSnapshot snapshot) {
    var textStyle = TextStyle(
      fontSize: 18,
      fontWeight: FontWeight.bold,
      color: Color.fromRGBO(0, 0, 0, 0.8),
    );
    var iconsColor = Color.fromRGBO(0, 0, 0, 0.7);
    return Container(
      height: 100,
      margin: EdgeInsets.only(top: 20.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          Container(
            width: MediaQuery.of(context).size.width / 2.5,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: <Widget>[
                GestureDetector(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      Text(
                        snapshot["followers"].toString() + " Followers",
                        style: textStyle,
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      Icon(
                        FontAwesomeIcons.userTie,
                        color: iconsColor,
                      ),
                    ],
                  ),
                  onTap: () {
                    //TODO: Opens a list of all followers
                  },
                ),
                GestureDetector(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        Text(
                          snapshot["blogs"].toString() + " Blogs",
                          style: textStyle,
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        Icon(
                          FontAwesomeIcons.solidStickyNote,
                          color: iconsColor,
                        ),
                      ],
                    ),
                    onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => Userpostlist(
                              type: 'Blogs',
                              snapshot: snapshot,
                            ),
                          ),
                        ))
              ],
            ),
          ),
          Container(
            height: 80,
            child: VerticalDivider(
              width: 3.0,
              color: Colors.black87,
            ),
          ),
          Container(
            width: MediaQuery.of(context).size.width / 2.5,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                GestureDetector(
                  child: Row(
                    children: <Widget>[
                      Icon(
                        FontAwesomeIcons.userNinja,
                        color: iconsColor,
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      Text(
                        snapshot["followings"].toString() + " Following",
                        style: textStyle,
                      ),
                    ],
                  ),
                  onTap: () {
                    //TODO: Opens a list of users followerd by current user
                  },
                ),
                GestureDetector(
                    child: Row(
                      children: <Widget>[
                        Icon(
                          FontAwesomeIcons.penNib,
                          color: iconsColor,
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        Text(
                          snapshot["posts"].toString() + " Posts",
                          style: textStyle,
                        ),
                      ],
                    ),
                    onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => Userpostlist(
                              type: 'Posts',
                              snapshot: snapshot,
                            ),
                          ),
                        )),
              ],
            ),
          )
        ],
      ),
    );
  }
}
