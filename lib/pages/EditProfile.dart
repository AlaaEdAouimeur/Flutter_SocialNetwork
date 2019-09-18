import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:redux_example/database/databaseReferences.dart'
    as databaseReference;

class EditProfile extends StatefulWidget {
  final String documentID;

  EditProfile({
    @required this.documentID,
  });
  @override
  _EditProfileState createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  DocumentSnapshot userProfile;
  var _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    databaseReference.DatabaseReferences()
        .users
        .document(widget.documentID)
        .get()
        .then((DocumentSnapshot snapshot) {
      setState(() {
        userProfile = snapshot;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: userProfile != null
          ? Container(
              child: getForm(),
            )
          : CircularProgressIndicator(),
    );
  }

  Widget getForm() {
    TextEditingController _username = TextEditingController();
    TextEditingController _birthday = TextEditingController();
    TextEditingController _location = TextEditingController();
    TextEditingController _bio = TextEditingController();

    _username.text = userProfile['username'];
    _birthday.text = userProfile['birthday'];
    _location.text = userProfile['location'];
    _bio.text = userProfile['bio'];

    TextStyle titleStyle = TextStyle(
      color: Colors.white,
      fontSize: 20.0,
      fontWeight: FontWeight.bold,
    );
    TextStyle labelStyle = TextStyle(
      color: Colors.white,
    );
    OutlineInputBorder enabledBorder = OutlineInputBorder(
      borderSide: BorderSide(width: 1, color: Colors.white,),
      borderRadius: BorderRadius.circular(10.0),
    );

    OutlineInputBorder focusedBorder = OutlineInputBorder(
      borderSide: BorderSide(width: 1, color: Colors.orange,),
      borderRadius: BorderRadius.circular(10.0),
    );

    return Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.only(top:50, left: 20, right: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                'Enter new Username:',
                style: titleStyle,
              ),
              SizedBox(height: 20.0,),
              TextFormField(
                keyboardType: TextInputType.text,
                controller: _username,
                style: labelStyle,
                validator: (val){
                  if(val.isEmpty) return "Name cannot be empty";
                  else if(val.trim().length < 3) return "Name too short";
                  return null;
                },
                decoration: InputDecoration(
                  enabledBorder: enabledBorder,
                  focusedBorder: focusedBorder,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide: BorderSide(color: Colors.white),
                  ),
                ),
              ),
              SizedBox(height: 40.0,),
              Text(
                'Enter your new Location:',
                style: titleStyle,
              ),
              SizedBox(height: 20.0,),
              TextFormField(
                keyboardType: TextInputType.text,
                controller: _location,
                style: labelStyle,
                validator: (val){
                  if(val.isEmpty) return "Please enter your location";
                  else if(val.trim().length < 3) return "Please enter proper location";
                  return null;
                },
                decoration: InputDecoration(
                  enabledBorder: enabledBorder,
                  focusedBorder: focusedBorder,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide: BorderSide(color: Colors.white),
                  ),
                ),
              ),

              SizedBox(height: 40.0,),
              Text(
                'Write something about you:',
                style: titleStyle,
              ),
              SizedBox(height: 20.0,),
              TextFormField(
                keyboardType: TextInputType.text,
                controller: _bio,
                style: labelStyle,
                validator: (val){
                  if(val.isEmpty) return "Please enter your bio";
                  else if(val.trim().length < 3) return "Please write some more things.";
                  return null;
                },
                decoration: InputDecoration(
                  enabledBorder: enabledBorder,
                  focusedBorder: focusedBorder,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide: BorderSide(color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
