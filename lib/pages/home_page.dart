import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../widgets/homeTab.dart';
import '../widgets/SearchTab.dart';
import '../widgets/blogTab.dart';
import '../widgets/userProfileTab.dart';
import '../widgets/writeTab.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
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
      backgroundColor: Theme.of(context).backgroundColor,
      bottomNavigationBar: bottomNavigator(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        child: Icon(
          FontAwesomeIcons.penNib,
          size: 20,
        ),
        backgroundColor: Theme.of(context).accentColor,
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
          BlogTab(),
          UserProfileTab(),
        ],
      ),
    );
  }

  Widget bottomNavigator() {
    return BottomNavigationBar(
      selectedItemColor: Colors.red,
      backgroundColor: Theme.of(context).backgroundColor,
      unselectedItemColor: Theme.of(context).accentColor,
      iconSize: 20,
      items: <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(FontAwesomeIcons.stream),
          title: Text(
            "Stream",
            style: Theme.of(context).textTheme.subhead,
          ),
        ),
        BottomNavigationBarItem(
          icon: Icon(FontAwesomeIcons.search),
          title: Text(
            "Discover",
            style: Theme.of(context).textTheme.subhead,
          ),
        ),
        BottomNavigationBarItem(
          icon: Icon(FontAwesomeIcons.blog),
          title: Text(
            "Blogs",
            style: Theme.of(context).textTheme.subhead,
          ),
        ),
        BottomNavigationBarItem(
          icon: Icon(FontAwesomeIcons.solidIdBadge),
          title: Text(
            "Profile",
            style: Theme.of(context).textTheme.subhead,
          ),
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
