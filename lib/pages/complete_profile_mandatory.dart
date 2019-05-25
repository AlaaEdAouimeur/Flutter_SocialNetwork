import 'package:flutter/material.dart';
import '../viewModel/userProfileTab.dart';

class CompleteProfile extends StatelessWidget {
  final ViewModel vm;
  CompleteProfile(this.vm);
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        padding: EdgeInsets.only(left: 20, right: 20),
        child: Column(
          children: <Widget>[
            Text("Choose Username"),
            TextField(
              
            ),
          ],
        ),
      ),
    );
  }
}