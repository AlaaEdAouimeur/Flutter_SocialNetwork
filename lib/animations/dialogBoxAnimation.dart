import 'package:flutter/material.dart';
import '../HelperClasses/DatabaseHelperClass.dart';
import '../widgets/FacebookLoginButton.dart';
import '../widgets/GoogleLoginButton.dart';

class DialogBox extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => DialogBoxState();
}

class DialogBoxState extends State<DialogBox>
    with SingleTickerProviderStateMixin {
  AnimationController controller;
  Animation<double> scaleAnimation;
  DatabaseHelperClass databaseHelperClass = new DatabaseHelperClass();

  @override
  void initState() {
    super.initState();

    controller =
        AnimationController(vsync: this, duration: Duration(milliseconds: 800));
    scaleAnimation =
        CurvedAnimation(parent: controller, curve: Curves.easeOutQuint);

    controller.addListener(() {
      setState(() {});
    });

    controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Material(
        color: Colors.transparent,
        child: ScaleTransition(
          scale: scaleAnimation,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.white,
                  blurRadius: 5.0,
                ),
              ],
              borderRadius: BorderRadius.circular(10.0),
            ),
            child: Padding(
              padding: const EdgeInsets.only(
                  top: 30, bottom: 30, left: 20, right: 20),
              child: IntrinsicHeight(
                child: Column(
                  children: <Widget>[
                    FacebookLoginButton(),
                    SizedBox(
                      height: 10.0,
                    ),
                    GoogleLoginButton(),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
