import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:redux_example/database/databaseReferences.dart'
    as databaseReference;
import 'package:redux_example/pages/PopupModal.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

// This is the main function which is used to show popup, take input and return map of input.
class FirstLoginHelper {
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

  final usernameController = TextEditingController();
  final birthdayController = TextEditingController();
  final locationController = TextEditingController();
  final bioController = TextEditingController();

  List<String> usernames = [];
  bool showForm = false;
  DateTime selectedDate = (DateTime.now()).subtract(Duration(days: 365));
  String username, dob, location, bio;
  PageController _pageController;
  int _currentPage = 0;
  int _numberOfForms = 4;
  bool usernameNextButton,
      birthdayNextButton,
      locationNextButton,
      bioNextButton;

  TextStyle titleStyle = TextStyle(
    fontSize: 20.0,
    fontWeight: FontWeight.bold,
  );

  @override
  void initState() {
    birthdayController.text = DateFormat.yMd().format(selectedDate);
    _pageController = PageController(
      initialPage: _currentPage,
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
    usernameNextButton = false;
    birthdayNextButton = false;
    locationNextButton = false;
    bioNextButton = false;
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
        bool dateCurrentState = _birthdayKey.currentState.validate();
        if (dateCurrentState != birthdayNextButton) {
          setState(() {
            birthdayNextButton = dateCurrentState;
          });
        }
      });
    }
  }

  void _nextForm() {
    if (_currentPage == _numberOfForms) {
      Map<String, dynamic> userUpdate = {
        'username': username,
        'birthday': dob,
        'location': location,
        'bio': bio,
      };
      Navigator.pop(context, userUpdate);
    } else {
      _currentPage++;
      _pageController.animateToPage(
        _currentPage,
        duration: Duration(milliseconds: 200),
        curve: Curves.easeIn,
      );
    }
  }

  void _previousForm() {
    if (_currentPage == 0)
      Navigator.of(context).pop();
    else {
      _currentPage--;
      _pageController.animateToPage(
        _currentPage,
        duration: Duration(milliseconds: 200),
        curve: Curves.easeIn,
      );
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
          'assets/images/logo.png',
          height: 80,
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
              'To provide personalized experience, we would like to know few details about you',
              style: TextStyle(
                fontSize: 16.0,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
        SizedBox(height: 10.0),
        Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            IconButton(
              icon: Icon(
                FontAwesomeIcons.chevronCircleRight,
                size: 30,
                color: Colors.teal,
              ),
              onPressed: () {
                setState(() {
                  _nextForm();
                });
              },
            ),
          ],
        ),
      ],
    );
  }

  // Username Page
  Widget _page1() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Form(
              key: _userNameKey,
              child: TextFormField(
                controller: usernameController,
                keyboardType: TextInputType.text,
                validator: (String s) {
                  if (s.isEmpty) {
                    return 'Username cannot be empty';
                  } else if (s.trim().length < 3) {
                    return 'Username too short';
                  } else if (usernames.contains(s.trim())) {
                    return "Username already exists";
                  } else {
                    return null;
                  }
                },
                decoration: InputDecoration(
                  labelText: 'username',
                ),
                onChanged: (value) {
                  bool nameCurrentState = _userNameKey.currentState.validate();
                  if (nameCurrentState != usernameNextButton) {
                    setState(() {
                      usernameNextButton = nameCurrentState;
                    });
                  }
                },
              ),
            ),
          ],
        ),
        SizedBox(
          height: 10.0,
        ),
        Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            IconButton(
              icon: Icon(
                FontAwesomeIcons.chevronCircleLeft,
                color: Colors.teal,
                size: 30,
              ),
              onPressed: () {
                setState(() {
                  _previousForm();
                });
              },
            ),
            IconButton(
              icon: Icon(
                FontAwesomeIcons.chevronCircleRight,
                color: usernameNextButton ? Colors.teal : Colors.grey,
                size: 30,
              ),
              onPressed: usernameNextButton
                  ? () {
                      setState(() {
                        if (_userNameKey.currentState.validate()) {
                          username = usernameController.text;
                          _nextForm();
                        }
                      });
                    }
                  : null,
            ),
          ],
        ),
      ],
    );
  }

  // Date of birth page
  Widget _page2() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Date Of Birth',
              style: TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 20.0),
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
                        return "Enter your birthdate";
                      else if (DateTime.now().difference(selectedDate).inDays <
                          365 * 13)
                        return "You should be atleast 13 years old.";
                      return null;
                    },
                    decoration: InputDecoration(
                      prefixIcon: Icon(
                        FontAwesomeIcons.solidCalendarAlt,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
        SizedBox(
          height: 10.0,
        ),
        Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            IconButton(
              icon: Icon(
                FontAwesomeIcons.chevronCircleLeft,
                color: Colors.teal,
                size: 30,
              ),
              onPressed: () {
                setState(() {
                  _previousForm();
                });
              },
            ),
            IconButton(
              icon: Icon(
                FontAwesomeIcons.chevronCircleRight,
                color: birthdayNextButton ? Colors.teal : Colors.grey,
                size: 30,
              ),
              onPressed: birthdayNextButton
                  ? () {
                      setState(() {
                        dob = DateFormat.yMd().format(selectedDate);
                        birthdayController.text = dob;
                        if (_birthdayKey.currentState.validate()) {
                          _nextForm();
                        }
                      });
                    }
                  : null,
            ),
          ],
        ),
      ],
    );
  }

  // Location Page
  Widget _page3() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
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
                  prefixIcon: Icon(
                    FontAwesomeIcons.mapPin,
                    color: Colors.black,
                  ),
                  labelText: 'Location',
                ),
                onChanged: (val) {
                  bool locationCurrentState =
                      _locationKey.currentState.validate();
                  if (locationCurrentState != locationNextButton) {
                    setState(() {
                      locationNextButton = locationCurrentState;
                    });
                  }
                },
              ),
            ),
          ],
        ),
        SizedBox(
          height: 10.0,
        ),
        Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            IconButton(
              icon: Icon(
                FontAwesomeIcons.chevronCircleLeft,
                color: Colors.teal,
                size: 30,
              ),
              onPressed: () {
                setState(() {
                  _previousForm();
                });
              },
            ),
            IconButton(
              icon: Icon(
                FontAwesomeIcons.chevronCircleRight,
                color: locationNextButton ? Colors.teal : Colors.grey,
                size: 30,
              ),
              onPressed: locationNextButton
                  ? () {
                      setState(() {
                        if (_locationKey.currentState.validate()) {
                          location = locationController.text;
                          _nextForm();
                        }
                      });
                    }
                  : null,
            ),
          ],
        ),
      ],
    );
  }

  // Bio Page
  Widget _page4() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Tell us something about you',
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
                    return 'People want to know about you, tell them!';
                  else if (s.trim().length < 5)
                    return "Don't be shy! Tell us someting more.";
                  else
                    return null;
                },
                decoration: InputDecoration(
                  prefixIcon: Icon(
                    FontAwesomeIcons.userEdit,
                    color: Colors.black,
                  ),
                  labelText: 'Bio',
                ),
                onChanged: (val) {
                  bool bioCurrentState = _bioKey.currentState.validate();
                  if (bioCurrentState != bioNextButton) {
                    setState(() {
                      bioNextButton = bioCurrentState;
                    });
                  }
                },
              ),
            ),
          ],
        ),
        SizedBox(height: 10.0),
        Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            IconButton(
              icon: Icon(
                FontAwesomeIcons.chevronCircleLeft,
                color: Colors.teal,
                size: 30,
              ),
              onPressed: () {
                setState(() {
                  _previousForm();
                });
              },
            ),
            IconButton(
              color: Colors.green,
              icon: Icon(
                FontAwesomeIcons.solidCheckCircle,
                color: bioNextButton ? Colors.teal : Colors.grey,
                size: 30,
              ),
              onPressed: bioNextButton
                  ? () {
                      setState(() {
                        if (_bioKey.currentState.validate()) {
                          bio = bioController.text;
                          _nextForm();
                        }
                      });
                    }
                  : null,
            ),
          ],
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Colors.black,
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
                      EdgeInsets.symmetric(horizontal: 10.0, vertical: 20.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                  child: _page0(),
                ),
              ),
              Align(
                alignment: Alignment.center,
                child: Container(
                  padding:
                      EdgeInsets.symmetric(horizontal: 10.0, vertical: 20.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                  child: _page1(),
                ),
              ),
              Align(
                alignment: Alignment.center,
                child: Container(
                  padding:
                      EdgeInsets.symmetric(horizontal: 10.0, vertical: 20.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                  child: _page2(),
                ),
              ),
              Align(
                alignment: Alignment.center,
                child: Container(
                  padding:
                      EdgeInsets.symmetric(horizontal: 10.0, vertical: 20.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                  child: _page3(),
                ),
              ),
              Align(
                alignment: Alignment.center,
                child: Container(
                  padding:
                      EdgeInsets.symmetric(horizontal: 10.0, vertical: 20.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(5.0),
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
