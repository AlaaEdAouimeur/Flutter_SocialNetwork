import 'package:flutter/material.dart';
import 'homeTab.dart';
import 'userProfileTab.dart';
import 'writeTab.dart';
import 'SearchTab.dart';

class TabViewController {
  Widget showBody(index) {
    switch (index) {
      case 0:
        return HomeTab();
        break;

      case 7:
        return Text("Blog");
        break;

      case 3:
        return WriteTab();
        break;

      case 1:
        return SearchTab();
        break;

      case 2:
        return UserProfileTab();
        break;

      default:
        return HomeTab();
    }
  }
}
