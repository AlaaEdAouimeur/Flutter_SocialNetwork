import 'package:flutter/material.dart';
import '../animations/slideAnimation.dart';
import '../HelperClasses/TutorialPageHelperClass.dart';
import 'package:flutter/services.dart';

class TutorialPage extends StatefulWidget {
  TutorialPage() {
    print("Tutorial Page");
  }
  TutorialPageState createState() => TutorialPageState();
}

class TutorialPageState extends State<TutorialPage> {
  TutorialPageState();
  TutorialPageHelperClass tutorialPageHelperClass;

  @override
  void initState() {
    super.initState();
    tutorialPageHelperClass = new TutorialPageHelperClass();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp
    ]);
  }

  @override
  void dispose() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
    super.dispose();
  }

  Widget build(BuildContext context) {

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
              SizedBox(
                height: 30.0,
              ),
              tutorialPageHelperClass.tutorialPageText(1300,  "READ STORIES"),
              tutorialPageHelperClass.tutorialPageDivider(2400),
              tutorialPageHelperClass.tutorialPageText(2500,  "BLOGS ON MULTIPLE TOPICS"),
              tutorialPageHelperClass.tutorialPageDivider(3600),
              tutorialPageHelperClass.tutorialPageText(3700,  "WRITE TALES, BLOGS AND STORIES"),
              tutorialPageHelperClass.tutorialPageDivider(4800),
              tutorialPageHelperClass.tutorialPageText(4900,  "FOLLOW WRITERS"),
              tutorialPageHelperClass.tutorialPageDivider(6100),
              tutorialPageHelperClass.tutorialPageLoginButton(6200, context),
              
            ],
          )),
    );
  }
}
