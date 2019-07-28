import 'package:flutter/material.dart';
import '../widgets/homeTab.dart';
import '../widgets/SearchTab.dart';
import '../widgets/userProfileTab.dart';
import '../widgets/writeTab.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with SingleTickerProviderStateMixin {
  int _selectedIndex = 0;
  PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = new PageController();
  }

  @override
  void dispose() {
    super.dispose();
    _pageController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      bottomNavigationBar: bottomNavigator(),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.border_color),
        backgroundColor: Colors.orange,
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => WriteTab(),
          ),
        ),
      ),
      body: PageView(
        onPageChanged: onPageChanged,
        controller: _pageController,
        children: <Widget>[
          HomeTab(),
          SearchTab(),
          UserProfileTab(),
        ],
      ),
    );
  }

  Widget bottomNavigator() {
    return BottomNavigationBar(
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
          icon: Icon(Icons.search),
          title: Text("Discover"),
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person),
          title: Text("Profile"),
        ),
      ],
      currentIndex: _selectedIndex,
      type: BottomNavigationBarType.fixed,
      onTap: itemTapped,
    );
  }

  void itemTapped(int index) {
    _pageController.jumpToPage(index);
  }

  void onPageChanged(int value) {
    setState(() {
      this._selectedIndex = value;
    });
  }
}
