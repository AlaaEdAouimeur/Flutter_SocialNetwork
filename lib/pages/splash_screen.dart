import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  Tween<double> radiusTween = new Tween<double>(begin: 0.0, end: 60.0);
  AnimationController _animatedController;
  Animation _animation;

  @override
  void initState() {
    super.initState();
    _animatedController = new AnimationController(
      vsync: this,
      duration: new Duration(milliseconds: 700),
    );

    _animation = new Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(_animatedController)
      ..addListener(() {
        setState(() {});
      });

    _animatedController.forward();
  }

  @override
  dispose() {
    _animatedController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          Container(
            decoration: BoxDecoration(color: Colors.black),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Expanded(
                flex: 2,
                child: Container(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Opacity(
                        child: CircleAvatar(
                          backgroundImage: AssetImage('assets/images/T.png'),
                          backgroundColor: Colors.black,
                          radius: 80.0,
                        ),
                        opacity: _animation.value,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
