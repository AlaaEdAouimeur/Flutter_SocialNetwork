import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';


class PostCategoryhelper{
  static const postCategories = <String>[
    'Microtale',
"Short story",
"Snippet",
"Quote",
"Blog",
  ];
  String valueplaceholder = 'Microtale';

  String getDropdownValue() {
  
    return valueplaceholder;
  }

  void setDropdownValue(String dropdownValue) {
    valueplaceholder = dropdownValue;
  }
}
class Postcategory extends StatefulWidget {
PostCategoryhelper postCategoryhelper = new PostCategoryhelper();

  _PostcategoryState createState() => _PostcategoryState();
}

class _PostcategoryState extends State<Postcategory> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      height: 50.0,
      padding: EdgeInsets.only(left: 15.0, right: 15.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text("Pick a Category :",style:TextStyle(fontWeight: FontWeight.bold)),
          Container(
            padding: EdgeInsets.only(left: 10.0, right: 10.0),
            margin: EdgeInsets.only(top: 8.0, bottom: 8.0),
            decoration: BoxDecoration(
              color: Color.fromRGBO(0, 128, 128, 0.2),
              borderRadius: BorderRadius.circular(5.0),
            ),
            child: DropdownButton<String>(
              value: widget.postCategoryhelper.valueplaceholder,
              style: TextStyle(
                color: Colors.teal,
              ),
              icon: Icon(
                EvaIcons.arrowIosDownward,
                color: Colors.teal,
              ),
              underline: Container(),
              onChanged: (String newValue) {
               
                setState(() {
                widget.postCategoryhelper.setDropdownValue(newValue);
                });
              },
              items: PostCategoryhelper.postCategories.map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}