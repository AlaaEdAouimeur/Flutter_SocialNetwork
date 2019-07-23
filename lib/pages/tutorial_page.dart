import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../viewModel/userProfileTab.dart';
import '../animations/slideAnimation.dart';
import '../animations/dialogBoxAnimation.dart';
import 'package:flutter/services.dart';

class TutorialPage extends StatefulWidget {
  final ViewModel viewModel;

  TutorialPage(this.viewModel);

  TutorialPageState createState() => TutorialPageState(viewModel);
}

class TutorialPageState extends State<TutorialPage> {
  ViewModel viewModel;

  TutorialPageState(this.viewModel);

  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
  }

  Widget build(BuildContext context) {
    TextStyle introTextStyle = TextStyle(
      color: Colors.white,
      fontSize: 20.0,
    );

    return Material(
      child: Container(
          width: MediaQuery.of(context).size.width,
          color: Colors.black,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              ShowUp(
                delay: 100,
                child: Image.asset(
                  'assets/images/logo.png',
                  width: 70,
                ),
              ),
              SizedBox(height: 30.0,),
              ShowUp(
                delay: 1300,
                child: Container(
                  child: Text(
                    "READ STORIES",
                    style: introTextStyle,
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              ShowUp(
                delay: 2400,
                child: Container(
                  width: MediaQuery.of(context).size.width / 2,
                  margin: EdgeInsets.only(top: 5.0, bottom: 5.0),
                  child: Divider(
                    color: Colors.white,
                  ),
                ),
              ),
              ShowUp(
                delay: 2500,
                child: Container(
                  child: Text(
                    "BLOGS ON \nMULTIPLE TOPICS",
                    style: introTextStyle,
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              ShowUp(
                delay: 3600,
                child: Container(
                  width: MediaQuery.of(context).size.width / 1.5,
                  margin: EdgeInsets.only(top: 5.0, bottom: 5.0),
                  child: Divider(
                    color: Colors.white,
                  ),
                ),
              ),
              ShowUp(
                delay: 3700,
                child: Container(
                  width: MediaQuery.of(context).size.width / 1.5,
                  child: Text(
                    "WRITE TALES, BLOGS AND STORIES",
                    style: introTextStyle,
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              ShowUp(
                delay: 4800,
                child: Container(
                  width: MediaQuery.of(context).size.width / 2,
                  margin: EdgeInsets.only(top: 5.0, bottom: 5.0),
                  child: Divider(
                    color: Colors.white,
                  ),
                ),
              ),
              ShowUp(
                delay: 4900,
                child: Container(
                  child: Text(
                    "FOLLOW WRITERS",
                    style: introTextStyle,
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              ShowUp(
                delay: 6100,
                child: Container(
                  width: MediaQuery.of(context).size.width / 2,
                  margin: EdgeInsets.only(top: 5.0, bottom: 5.0),
                  child: Divider(
                    color: Colors.white,
                  ),
                ),
              ),
              ShowUp(
                delay: 6200,
                child: RaisedButton(
                  color: Colors.teal,
                  child: Text(
                    "LOGIN TO CONTINUE",
                    style: TextStyle(color: Colors.white),
                  ),
                  onPressed: () => {
                        print("Pressed"),
                        SharedPreferences.getInstance().then((prefs) => {
//                              prefs.setBool("firstUse", false),
//                              viewModel.changeFirstTimeState(false),
                              showDialog(context: context, builder: (BuildContext context) {
                                return DialogBox();
                              })
                            }),
                      },
                ),
              ),
            ],
          )),
    );
  }
}
