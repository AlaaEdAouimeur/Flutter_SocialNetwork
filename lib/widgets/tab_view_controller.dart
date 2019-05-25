import 'package:flutter/material.dart';
import 'homeTab.dart';
import 'userProfileTab.dart';
import 'writeTab.dart';

class TabViewController {
  Widget showBody(index) {
    switch (index) {
      case 0:
        return HomeTab();
        break;

      case 1:
        return Text("Blog");
        break;

      case 2:
        return WriteTab();
        break;

      case 3:
        return Text("Search");
        break;

      case 4:
        return UserProfileTab();
        break;

      default:
        return HomeTab();
    }
  }
}
