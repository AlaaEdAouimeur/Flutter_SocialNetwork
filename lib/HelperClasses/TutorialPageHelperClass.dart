import '../animations/slideAnimation.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../animations/dialogBoxAnimation.dart';

class TutorialPageHelperClass {
  TextStyle introTextStyle = TextStyle(
    color: Colors.white,
    fontSize: 20.0,
  );

  ShowUp tutorialPageText(int delay, String tutorialText) {
    return ShowUp(
      delay: delay,
      child: Container(
        width: 200,
        child: Text(
          tutorialText,
          style: introTextStyle,
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  ShowUp tutorialPageDivider(int delay) {
    return ShowUp(
      delay: delay,
      child: Container(
        width: 200,
        margin: EdgeInsets.only(top: 5.0, bottom: 5.0),
        child: Divider(
          color: Colors.white,
        ),
      ),
    );
  }

  ShowUp tutorialPageLoginButton(int delay, BuildContext context) {
    return ShowUp(
      delay: delay,
      child: RaisedButton(
        color: Colors.teal,
        child: Text(
          "LOGIN TO CONTINUE",
          style: TextStyle(color: Colors.white),
        ),
        onPressed: () => {
          SharedPreferences.getInstance().then((prefs) => {
//                              prefs.setBool("firstUse", false),
//                              viewModel.changeFirstTimeState(false),
            showDialog(
                context: context,
                builder: (BuildContext context) {
                  return DialogBox();
                })
          }),
        },
      ),
    );
  }
}