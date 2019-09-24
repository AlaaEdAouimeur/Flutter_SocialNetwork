import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:redux_example/database/databaseReferences.dart'
    as databaseReference;
import 'package:redux_example/pages/PopupModal.dart';

// This is the main function which is used to show popup, take input and return map of input.
class FirstLoginHelper {
  static const int NEW = 1;
  static const int OLD_WITHOUT = 2;
  static const int OLD_WITH = 3;
  static Future<Map<String, dynamic>> showPopup(BuildContext context) {
    return Navigator.of(context).push(
      PopupModal(
        background: Color.fromRGBO(0, 0, 0, 0.3),
        child: _FirstLoginForm(),
      ),
    );
  }
}

//This contains four forms in pageView to take input.
class _FirstLoginForm extends StatefulWidget {
  @override
  _FirstLoginFormState createState() => _FirstLoginFormState();
}

class _FirstLoginFormState extends State<_FirstLoginForm> {
  var _userNameKey = GlobalKey<FormState>();
  var _birthdayKey = GlobalKey<FormState>();
  var _locationKey = GlobalKey<FormState>();
  var _bioKey = GlobalKey<FormState>();

  List<String> usernames = [];
  bool showForm = false;
  DateTime selectedDate = (DateTime.now()).subtract(Duration(days: 365));
  final usernameController = TextEditingController();
  final birthdayController = TextEditingController();
  final locationController = TextEditingController();
  final bioController = TextEditingController();
  String username, dob, location, bio;
  PageController _pageController;

  TextStyle buttonStyle = TextStyle(
    fontSize: 16,
    color: Colors.green,
    fontWeight: FontWeight.bold,
  );
  TextStyle titleStyle = TextStyle(
    fontSize: 25.0,
    fontWeight: FontWeight.bold,
  );

  @override
  void initState() {
    birthdayController.text = DateFormat.yMd().format(selectedDate);
    _pageController = PageController(
      initialPage: 0,
    );
    databaseReference.DatabaseReferences()
        .users
        .getDocuments()
        .then((QuerySnapshot users) {
      users.documents.forEach((DocumentSnapshot user) {
        if (user['username'] != null) usernames.add(user['username']);
      });
      setState(() {
        showForm = true;
      });
    });
    super.initState();
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
        birthdayController.text = DateFormat.yMd().format(selectedDate);
      });
    }
  }

  // Welcome Page
  Widget _page0() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Image.asset(
          'assets/images/popper.png',
          height: 150,
        ),
        SizedBox(
          height: 20.0,
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Container(
              child: Text(
                'Welcome to\nThe Project Quote',
                style: titleStyle,
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(
              height: 20.0,
            ),
            Text(
              'To provide better experience, we would like to know something about you',
              style: TextStyle(
                fontSize: 16.0,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
        SizedBox(height: 20.0),
        Container(
          child: FlatButton(
            textColor: Colors.green,
            child: Text(
              'Continue',
              style: buttonStyle,
              textAlign: TextAlign.center,
            ),
            onPressed: () {
              setState(() {
                _pageController.animateToPage(
                  1,
                  duration: Duration(milliseconds: 200),
                  curve: Curves.easeIn,
                );
              });
            },
          ),
        ),
      ],
    );
  }

  // Username Page
  Widget _page1() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Container(
          padding: EdgeInsets.symmetric(vertical: 20.0),
          child: Text(
            'Username',
            style: titleStyle,
            textAlign: TextAlign.center,
          ),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text(
              'Choose your username',
              style: TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 20.0),
            Form(
              key: _userNameKey,
              child: TextFormField(
                controller: usernameController,
                keyboardType: TextInputType.text,
                validator: (String s) {
                  if (s.isEmpty)
                    return 'Username cannot be empty';
                  else if (s.trim().length < 3)
                    return 'Username too short';
                  else if (usernames.contains(s.trim()))
                    return "Username already exists";
                  else
                    return null;
                },
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.supervised_user_circle),
                  labelText: 'Username',
                  hintText: 'Your username',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
              ),
            ),
          ],
        ),
        SizedBox(
          height: 20.0,
        ),
        Container(
          child: FlatButton(
            child: Text(
              'Next',
              style: buttonStyle,
            ),
            onPressed: () {
              setState(() {
                if (_userNameKey.currentState.validate()) {
                  username = usernameController.text;
                  _pageController.animateToPage(
                    2,
                    duration: Duration(milliseconds: 200),
                    curve: Curves.easeIn,
                  );
                }
              });
            },
          ),
        )
      ],
    );
  }

  // Date of birth page
  Widget _page2() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Container(
          padding: EdgeInsets.symmetric(vertical: 20.0),
          child: Text(
            'Birthday',
            style: titleStyle,
          ),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Date of Birth',
              style: TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 30.0),
            GestureDetector(
              onTap: () {
                _selectDate();
              },
              child: AbsorbPointer(
                child: Form(
                  key: _birthdayKey,
                  child: TextFormField(
                    readOnly: true,
                    keyboardType: TextInputType.datetime,
                    controller: birthdayController,
                    validator: (val) {
                      if (val.isEmpty)
                        return "Enter your birthday";
                      else if (DateTime.now().difference(selectedDate).inDays <
                          365 * 13)
                        return "You should be atleast 13 years old.";
                      return null;
                    },
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.calendar_today),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        borderSide: BorderSide(color: Colors.white),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
        SizedBox(
          height: 20.0,
        ),
        Container(
          child: FlatButton(
            child: Text(
              'Next',
              style: buttonStyle,
            ),
            onPressed: () {
              setState(() {
                dob = DateFormat.yMd().format(selectedDate);
                birthdayController.text = dob;
                if (_birthdayKey.currentState.validate()) {
                  _pageController.animateToPage(
                    3,
                    duration: Duration(milliseconds: 200),
                    curve: Curves.easeIn,
                  );
                }
              });
            },
          ),
        )
      ],
    );
  }

  // Location Page
  Widget _page3() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Container(
          padding: EdgeInsets.symmetric(vertical: 20.0),
          child: Text(
            'Location',
            style: titleStyle,
          ),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'City',
              style: TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 20.0),
            Form(
              key: _locationKey,
              child: TextFormField(
                controller: locationController,
                keyboardType: TextInputType.text,
                validator: (String s) {
                  if (s.isEmpty)
                    return 'Please enter your city';
                  else if (s.trim().length < 5)
                    return 'Location too short';
                  else
                    return null;
                },
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.location_on),
                  labelText: 'Location',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
              ),
            ),
          ],
        ),
        SizedBox(
          height: 20.0,
        ),
        Container(
          child: FlatButton(
            child: Text(
              'Next',
              style: buttonStyle,
            ),
            onPressed: () {
              setState(() {
                if (_locationKey.currentState.validate()) {
                  location = locationController.text;
                  _pageController.animateToPage(
                    4,
                    duration: Duration(milliseconds: 200),
                    curve: Curves.easeIn,
                  );
                }
              });
            },
          ),
        )
      ],
    );
  }

  // Bio Page
  Widget _page4() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Container(
          padding: EdgeInsets.symmetric(vertical: 20.0),
          child: Text(
            'Bio',
            style: titleStyle,
          ),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Write something about you',
              style: TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 20.0),
            Form(
              key: _bioKey,
              child: TextFormField(
                controller: bioController,
                keyboardType: TextInputType.text,
                validator: (String s) {
                  if (s.isEmpty)
                    return 'Please enter your short bio';
                  else if (s.trim().length < 5)
                    return 'Bio is too short';
                  else
                    return null;
                },
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.edit),
                  labelText: 'Bio',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 20.0),
        Container(
          child: FlatButton(
            child: Text(
              'Done',
              style: buttonStyle,
            ),
            onPressed: () {
              setState(() {
                if (_bioKey.currentState.validate()) {
                  bio = bioController.text;
                  Map<String, dynamic> userUpdate = {
                    'username': username,
                    'birthday': dob,
                    'location': location,
                    'bio': bio,
                  };
                  Navigator.pop(context, userUpdate);
                }
              });
            },
          ),
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Colors.transparent,
      body: Align(
        alignment: Alignment.center,
        child: Container(
          width: MediaQuery.of(context).size.width / 1.3,
          child: PageView(
            controller: _pageController,
            physics: NeverScrollableScrollPhysics(),
            children: <Widget>[
              Align(
                alignment: Alignment.center,
                child: Container(
                  padding:
                      EdgeInsets.symmetric(horizontal: 10.0, vertical: 50.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: _page0(),
                ),
              ),
              Align(
                alignment: Alignment.center,
                child: Container(
                  padding:
                      EdgeInsets.symmetric(horizontal: 10.0, vertical: 50.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: _page1(),
                ),
              ),
              Align(
                alignment: Alignment.center,
                child: Container(
                  padding:
                      EdgeInsets.symmetric(horizontal: 10.0, vertical: 50.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: _page2(),
                ),
              ),
              Align(
                alignment: Alignment.center,
                child: Container(
                  padding:
                      EdgeInsets.symmetric(horizontal: 10.0, vertical: 50.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: _page3(),
                ),
              ),
              Align(
                alignment: Alignment.center,
                child: Container(
                  padding:
                      EdgeInsets.symmetric(horizontal: 10.0, vertical: 50.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: _page4(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    usernameController.dispose();
    locationController.dispose();
    bioController.dispose();
    super.dispose();
  }
}

class NoGlowScroll extends ScrollBehavior {
  @override
  Widget buildViewportChrome(
      BuildContext context, Widget child, AxisDirection axisDirection) {
    return child;
  }
}
