import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:redux_example/pages/PopupModal.dart';

// This is the main function which is used to show popup, take input and return map of input.
class FirstLoginHelper {
  static const int NEW = 1;
  static const int OLD_WITHOUT = 2;
  static const int OLD_WITH = 3;
  static Future<Map<String, dynamic>> showPopup(BuildContext context) {
    return Navigator.of(context).push(
      PopupModal(
        top: 100,
        bottom: 100,
        left: 50,
        right: 50,
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
  var _locationKey = GlobalKey<FormState>();
  var _bioKey = GlobalKey<FormState>();

  DateTime selectedDate = (DateTime.now()).subtract(Duration(days: 365));
  final usernameController = TextEditingController();
  final locationController = TextEditingController();
  final bioController = TextEditingController();
  String username, dob, location, bio;
  PageController _pageController;
  String dobError = '';

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
    _pageController = PageController(initialPage: 0);
    super.initState();
  }

  Future<Null> _selectDate() async {
    final DateTime picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(1950),
      lastDate: DateTime.now(),
    );
    print(picked);
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }


  // Welcome Page
  Widget _page0(){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Expanded(
            flex: 1,
            child: Image.asset(
              'assets/images/popper.png',
            )),
        SizedBox(
          height: 20.0,
        ),
        Expanded(
          flex: 2,
          child: Column(
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
              ),
            ],
          ),
        ),
        Container(
          alignment: Alignment.topRight,
          child: FlatButton(
            textColor: Colors.green,
            child: Text(
              'Continue',
              style: buttonStyle,
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
  Widget _page1(){
    return Column(
      children: <Widget>[
        Container(
          padding: EdgeInsets.symmetric(vertical: 20.0),
          child: Text(
            'Username',
            style: titleStyle,
          ),
        ),
        Expanded(
          flex: 1,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                'Enter your name:',
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
                    else
                      return null;
                  },
                  decoration: InputDecoration(
                    labelText: 'Username',
                    hintText: 'Your Name',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        Container(
          alignment: Alignment.topRight,
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
  Widget _page2(){
    return Column(
      children: <Widget>[
        Container(
          padding: EdgeInsets.symmetric(vertical: 20.0),
          child: Text(
            'Birthday',
            style: titleStyle,
          ),
        ),
        Expanded(
          flex: 1,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                'Enter your Date of Birth:',
                style: TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 30.0),
              GestureDetector(
                onTap: (){
                  _selectDate();
                },
                child: Container(
                  padding: EdgeInsets.all(10.0),
                  height: 60.0,
                  alignment: Alignment.centerLeft,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16.0),
                    border: Border.all(color: Colors.blue),
                  ),
                  child: Text(DateFormat.yMd().format(selectedDate), style: TextStyle(fontSize: 18.0),),
                ),
              ),
              Text(dobError, style: TextStyle(color: Colors.red,),),
            ],
          ),
        ),
        Container(
          alignment: Alignment.topRight,
          child: FlatButton(
            child: Text(
              'Next',
              style: buttonStyle,
            ),
            onPressed: () {
              setState(() {
                if (selectedDate != null) {
                  dob = DateFormat.yMd().format(selectedDate);
                  _pageController.animateToPage(
                    3,
                    duration: Duration(milliseconds: 200),
                    curve: Curves.easeIn,
                  );
                }
                else dobError = "Invalid date";
              });
            },
          ),
        )
      ],
    );
  }

  // Location Page
  Widget _page3(){
    return Column(
      children: <Widget>[
        Container(
          padding: EdgeInsets.symmetric(vertical: 20.0),
          child: Text(
            'Location',
            style: titleStyle,
          ),
        ),
        Expanded(
          flex: 1,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                'Enter your Address:',
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
                      return 'Please enter your location';
                    else if (s.trim().length < 5)
                      return 'Location too short';
                    else
                      return null;
                  },
                  decoration: InputDecoration(
                    labelText: 'Location',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        Container(
          alignment: Alignment.topRight,
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
  Widget _page4(){
    return Column(
      children: <Widget>[
        Container(
          padding: EdgeInsets.symmetric(vertical: 20.0),
          child: Text(
            'Bio',
            style: titleStyle,
          ),
        ),
        Expanded(
          flex: 1,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                'Write something about you:',
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
                    labelText: 'Bio',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        Container(
          alignment: Alignment.topRight,
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
      backgroundColor: Colors.transparent,
      resizeToAvoidBottomPadding: false,
      body: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10.0),
        ),
        padding: const EdgeInsets.all(16.0),
        child: PageView(
          controller: _pageController,
          physics: NeverScrollableScrollPhysics(),
          children: <Widget>[
            _page0(),
            _page1(),
            _page2(),
            _page3(),
            _page4(),
          ],
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