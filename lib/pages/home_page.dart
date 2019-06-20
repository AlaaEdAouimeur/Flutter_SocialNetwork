import 'package:flutter/material.dart';
import '../widgets/tab_view_controller.dart' as tabController;
import 'package:redux_example/appColors.dart' as AppColor;

class HomePage extends StatefulWidget {
  HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: tabController.TabViewController().showBody(_selectedIndex),
      bottomNavigationBar: bottomNavigator(),
      backgroundColor: AppColor.offWhite,
    );
  }

  Widget appBar() {
    return PreferredSize(
      preferredSize: Size.fromHeight(20.0),
      child: Container(
        width: 100,
        height: 50,
        color: Colors.red,
        child: AppBar(
          title: Text(
            "The Project Quote",
            style: TextStyle(
              fontSize: 12.0,
              letterSpacing: 0.5,
              wordSpacing: 1.0,
              color: AppColor.brightRed,
            ),
            textAlign: TextAlign.center,
          ),
          backgroundColor: AppColor.offWhite,
          elevation: 0,
        ),
      ),
    );
  }

  Widget bottomNavigator() {
    return new PreferredSize(
      preferredSize: Size.fromHeight(40.0),
      child: BottomNavigationBar(
        selectedItemColor: Colors.white,
        backgroundColor: Colors.black,
        unselectedItemColor: Colors.white30,
        iconSize: 15,
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            title: Text("Home"),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.book),
            title: Text("Blog"),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.note_add),
            title: Text("Write"),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            title: Text("Search"),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            title: Text("User"),
          ),
        ],
        currentIndex: _selectedIndex,
        type: BottomNavigationBarType.fixed,
        onTap: itemTapped,
      ),
    );
  }

  void itemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }
}
