import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
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
  DateTime selectedDate;
  List<String> usernames = [];

  TextEditingController _username = TextEditingController();
  TextEditingController _birthday = TextEditingController();
  TextEditingController _location = TextEditingController();
  TextEditingController _bio = TextEditingController();

  @override
  void initState() {
    super.initState();
    databaseReference.DatabaseReferences().users.getDocuments().then(
      (QuerySnapshot data) {
        data.documents.forEach((DocumentSnapshot snapshot) {
          if (snapshot.documentID != widget.documentID) {
            if (snapshot.data['username'] != null) {
              print(snapshot.data['username']);
              usernames.add(
                snapshot.data['username'],
              );
            }
          } else if (snapshot.documentID == widget.documentID) {
            userProfile = snapshot;
            _username.text = userProfile['username'];
            _birthday.text = userProfile['birthday'];
            selectedDate = dateFromString(userProfile['birthday']);
            _location.text = userProfile['location'];
            _bio.text = userProfile['bio'];
          }
        });
        setState(() {});
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Container(
          alignment: Alignment.centerRight,
          padding: EdgeInsets.only(right: 20.0),
          child: Text('Edit Profile', style: TextStyle(
            fontFamily: 'SourceSans',
            fontWeight: FontWeight.bold,
          ),),
        ),
      ),
      backgroundColor: Colors.black,
      body: userProfile != null
          ? Container(
              child: getForm(),
            )
          : Container(
              alignment: Alignment.center,
              child: CircularProgressIndicator(),
            ),
    );
  }

  Widget getForm() {
    TextStyle titleStyle = TextStyle(
      color: Colors.white,
      fontSize: 20.0,
      fontWeight: FontWeight.bold,
    );
    TextStyle labelStyle = TextStyle(
      color: Colors.white,
    );
    TextStyle errorStyle = TextStyle(
      color: Colors.redAccent,
      fontSize: 14.0,
      fontWeight: FontWeight.bold,
    );
    OutlineInputBorder enabledBorder = OutlineInputBorder(
      borderSide: BorderSide(
        width: 1,
        color: Colors.white,
      ),
      borderRadius: BorderRadius.circular(10.0),
    );

    OutlineInputBorder focusedBorder = OutlineInputBorder(
      borderSide: BorderSide(
        width: 2,
        color: Colors.orange,
      ),
      borderRadius: BorderRadius.circular(10.0),
    );

    OutlineInputBorder errorBorder = OutlineInputBorder(
      borderSide: BorderSide(
        width: 2,
        color: Colors.redAccent,
      ),
      borderRadius: BorderRadius.circular(10.0),
    );

    return Form(
      key: _formKey,
      child: ScrollConfiguration(
        behavior: NoGlowScroll(),
        child: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.only(top: 10, left: 20, right: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  'Enter new Username:',
                  style: titleStyle,
                ),
                SizedBox(
                  height: 10.0,
                ),
                TextFormField(
                  keyboardType: TextInputType.text,
                  controller: _username,
                  style: labelStyle,
                  validator: (val) {
                    if (val.isEmpty)
                      return "Name cannot be empty";
                    else if (val.trim().length < 3)
                      return "Name too short";
                    else if (usernames.contains(val))
                      return "Name already exists";
                    return null;
                  },
                  decoration: InputDecoration(
                    enabledBorder: enabledBorder,
                    focusedBorder: focusedBorder,
                    errorBorder: errorBorder,
                    errorStyle: errorStyle,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: BorderSide(color: Colors.white),
                    ),
                  ),
                ),
                SizedBox(
                  height: 40.0,
                ),
                Text(
                  'Enter your Date of Birth:',
                  style: titleStyle,
                ),
                SizedBox(
                  height: 10.0,
                ),
                GestureDetector(
                  onTap: () {
                    _selectDate();
                  },
                  child: AbsorbPointer(
                    child: TextFormField(
                      readOnly: true,
                      keyboardType: TextInputType.datetime,
                      controller: _birthday,
                      style: labelStyle,
                      validator: (val) {
                        if (DateTime.now().difference(selectedDate).inDays <
                            365 * 13)
                          return "You should be atleast 13 years old.";
                        return null;
                      },
                      decoration: InputDecoration(
                        enabledBorder: enabledBorder,
                        focusedBorder: focusedBorder,
                        errorBorder: errorBorder,
                        errorStyle: errorStyle,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide: BorderSide(color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 40.0,
                ),
                Text(
                  'Enter your new Location:',
                  style: titleStyle,
                ),
                SizedBox(
                  height: 10.0,
                ),
                TextFormField(
                  keyboardType: TextInputType.text,
                  controller: _location,
                  style: labelStyle,
                  validator: (val) {
                    if (val.isEmpty)
                      return "Please enter your location";
                    else if (val.trim().length < 3)
                      return "Please enter proper location";
                    return null;
                  },
                  decoration: InputDecoration(
                    enabledBorder: enabledBorder,
                    focusedBorder: focusedBorder,
                    errorBorder: errorBorder,
                    errorStyle: errorStyle,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: BorderSide(color: Colors.white),
                    ),
                  ),
                ),
                SizedBox(
                  height: 40.0,
                ),
                Text(
                  'Write something about you:',
                  style: titleStyle,
                ),
                SizedBox(
                  height: 10.0,
                ),
                TextFormField(
                  keyboardType: TextInputType.text,
                  controller: _bio,
                  style: labelStyle,
                  validator: (val) {
                    if (val.isEmpty) return "Please enter your bio";
                    return null;
                  },
                  decoration: InputDecoration(
                    enabledBorder: enabledBorder,
                    focusedBorder: focusedBorder,
                    errorBorder: errorBorder,
                    errorStyle: errorStyle,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: BorderSide(color: Colors.white),
                    ),
                  ),
                ),
                SizedBox(height: 40),
                Container(
                  alignment: Alignment.center,
                  child: RaisedButton(
                    child: Text('Update', style:TextStyle(
                      color: Colors.white,
                      fontFamily: "SourceSans",
                      fontSize: 16,
                    ),),
                    onPressed: updateUserProfile,
                    color: Colors.orange,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<Null> _selectDate() async {
    final DateTime picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(1950),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
        _birthday.text = DateFormat.yMd().format(selectedDate);
      });
    }
  }

  DateTime dateFromString(String date) {
    //TODO: User birthdate is set to null when user clicks on next without selecting b'day. It is giving error, so adding this condition. This should be removed later
    if(date != null) {
      List<String> a = date.split('/');
      if (a[0].length == 1) a[0] = '0${a[0]}';
      if (a[1].length == 1) a[1] = '0${a[1]}';
      return DateTime.parse('${a[2]}-${a[0]}-${a[1]} 00:00:00.000');
    }
    return null;
  }

  void updateUserProfile() async {
    if (_formKey.currentState.validate()) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return Center(
            child: SizedBox(
              height: 50.0,
              width: 50.0,
              child: CircularProgressIndicator(),
            ),
          );
        },
      );
      await databaseReference.DatabaseReferences()
          .users
          .document(widget.documentID)
          .updateData({
        'username': _username.text,
        'birthday': _birthday.text,
        'location': _location.text,
        'bio': _bio.text,
      }).then((_) {
        Navigator.of(context).pop();
        Navigator.of(context).pop();
      });
    }
  }
}

class NoGlowScroll extends ScrollBehavior {
  @override
  Widget buildViewportChrome(
      BuildContext context, Widget child, AxisDirection axisDirection) {
    return child;
  }
}
