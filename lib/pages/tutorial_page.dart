import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../viewModel/userProfileTab.dart';
import '../pages/login_page.dart';

class TutorialPage extends StatefulWidget {
  final ViewModel viewModel;
  TutorialPage(this.viewModel);
  TutorialPageState createState() => TutorialPageState(viewModel);
}

class TutorialPageState extends State<TutorialPage> {
  int _currentIndex = 0;
  Widget widgetToShow;
  ViewModel viewModel;
  TutorialPageState(this.viewModel);
  List<Widget> introWidgetList;

  @override
  void initState() {
    super.initState();
  }

  void loadNextPage() {}

  Widget build(BuildContext context) {
    introWidgetList = [
      Text("Read stories"),
      Text("Blogs on multiple topics"),
      Text("Write your own tales, stories and blogs"),
      Text("Follow writers"),
      RaisedButton(
        color: Colors.red,
        child: Text("Login To Continue"),
        onPressed: () => {
              print("Pressed"),
              SharedPreferences.getInstance().then((prefs) => {
                    prefs.setBool("firstUse", false),
                    viewModel.changeFirstTimeState(false),
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => LoginPage()),
                    ),
                  }),
            },
      ),
    ];

    return Material(
      child: Container(
          color: Colors.teal,
          child: Stack(
            children: <Widget>[
              CarouselSlider(
                onPageChanged: (index) {
                  setState(() {
                    _currentIndex = index;
                  });
                },
                height: double.infinity,
                viewportFraction: 1.0,
                items: [0, 1, 2, 3, 4].map((i) {
                  return Builder(
                    builder: (BuildContext context) {
                      return Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: [
                                  Colors.orangeAccent,
                                  Colors.greenAccent
                                ]),
                          ),
                          child: Center(
                            child: introWidgetList[i],
                          ));
                    },
                  );
                }).toList(),
              ),
              Positioned(
                  bottom: 10.0,
                  left: 0.0,
                  right: 0.0,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [0, 1, 2, 3, 4].map<Widget>((index) {
                      return Container(
                        width: 8.0,
                        height: 8.0,
                        margin: EdgeInsets.symmetric(
                            vertical: 10.0, horizontal: 2.0),
                        decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: _currentIndex == index
                                ? Color.fromRGBO(0, 0, 0, 0.9)
                                : Color.fromRGBO(0, 0, 0, 0.4)),
                      );
                    }).toList(),
                  )),
            ],
          )),
    );
  }
}
