import 'package:flutter/material.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import '../functions/login_functions.dart' as loginFunctions;
import '../HelperClasses/DatabaseHelperClass.dart';
import '../pages/home_page.dart';

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
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.blue),
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      child: FlatButton(
                        child: IntrinsicWidth(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Icon(
                                EvaIcons.facebook,
                                color: Colors.blue,
                              ),
                              SizedBox(
                                width: 10.0,
                              ),
                              Text(
                                "CONTINUE WITH FACEBOOK",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.blue),
                              )
                            ],
                          ),
                        ),
                        onPressed: () {},
                      ),
                    ),
                    SizedBox(
                      height: 10.0,
                    ),
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.red),
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      child: FlatButton(
                        child: IntrinsicWidth(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Icon(
                                EvaIcons.google,
                                color: Colors.red,
                              ),
                              SizedBox(
                                width: 10.0,
                              ),
                              Text(
                                "CONTINUE WITH GOOGLE",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.red),
                              )
                            ],
                          ),
                        ),
                        onPressed: () {
                          loginFunctions.LoginFunctions()
                              .googleLogin()
                              .then((user) => {
                                    databaseHelperClass
                                        .saveUserDataToDatabase(user),
                                  })
                              .then((_) => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => HomePage())))
                              .catchError((e) => print(e));
                        },
                      ),
                    ),
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
