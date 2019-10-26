import 'package:flutter/material.dart';
import 'PostBody.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DoubleHolder {
  static double value = 0.0;
}

class PostList extends StatefulWidget {
  final AsyncSnapshot<QuerySnapshot> snapshot;

  PostList(this.snapshot, {Key key}) : super(key: key);

  double getOffsetMethod() {
    return DoubleHolder.value;
  }

  void setOffsetMethod(double val) {
    DoubleHolder.value = val;
  }

  @override
  PostListState createState() => new PostListState();
}

class PostListState extends State<PostList> {
  ScrollController scrollController;

  @override
  void initState() {
    super.initState();
    scrollController =
        new ScrollController(initialScrollOffset: widget.getOffsetMethod());
  }

  Widget build(BuildContext context) {
    return NotificationListener(
        child: ListView.builder(
          controller: scrollController,
          itemCount: widget.snapshot.data.documents.length,
          itemBuilder: (context, index) {
            return Column(
              children: <Widget>[
                new Container(
                  color: Theme.of(context).cardColor,
                  margin: EdgeInsets.all(15.0),
                  padding: EdgeInsets.all(15.0),
                  child: PostBody(widget.snapshot.data.documents[index]),
                ),
              ],
            );
          },
        ),
        onNotification: (notification) {
          if (notification is ScrollNotification) {
            widget.setOffsetMethod(notification.metrics.pixels);
          }
          return true;
        });
  }
}
