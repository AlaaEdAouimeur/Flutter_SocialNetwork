import 'package:flutter/material.dart';
import '../database/databaseReferences.dart' as databaseReference;
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
      appBar: appBar(),
      body: tabController.TabViewController().showBody(_selectedIndex),
      bottomNavigationBar: bottomNavigator(),
      backgroundColor: AppColor.offWhite,
    );
  }

  void deleteBox(String user) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Delete!"),
            content:
                Text("Do you really want to delete this entry from database?"),
            actions: <Widget>[
              FlatButton(
                child: Text("Delete"),
                onPressed: () {
                  databaseReference.DatabaseReferences()
                      .parentReference
                      .child(user)
                      .remove()
                      .then((_) => {
                            print("user deleted"),
                            Navigator.of(context).pop(),
                          });
                },
              ),
              FlatButton(
                  child: Text("Back"),
                  onPressed: () {
                    Navigator.of(context).pop();
                  }),
            ],
          );
        });
  }

  Widget appBar() {
    return PreferredSize(
      preferredSize: Size.fromHeight(40.0),
      child: AppBar(
        title: Text(
          "The Project Quote",
          style: TextStyle(
            fontSize: 12.0,
            letterSpacing: 1.0,
            wordSpacing: 1.0,
            color: AppColor.brightRed,
          ),
        ),
        backgroundColor: AppColor.offWhite,
        elevation: 0,
      ),
    );
  }

  Widget bottomNavigator() {
    return new Theme(
      data: ThemeData(
        canvasColor: AppColor.brown,
      ),
      child: PreferredSize(
        preferredSize: Size.fromHeight(20.0),
        child: BottomNavigationBar(
          items: <BottomNavigationBarItem>[
            BottomNavigationBarItem(
                icon: Icon(Icons.home), title: Text("Home")),
            BottomNavigationBarItem(
                icon: Icon(Icons.book), title: Text("Blog")),
            BottomNavigationBarItem(
                icon: Icon(Icons.note_add), title: Text("Write")),
            BottomNavigationBarItem(
                icon: Icon(Icons.person), title: Text("User")),
          ],
          currentIndex: _selectedIndex,
          type: BottomNavigationBarType.shifting,
          onTap: itemTapped,
        ),
      ),
    );
  }

  void itemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }
}
