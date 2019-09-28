import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:redux_example/animations/fadeInAnimation.dart';
import 'package:redux_example/pages/BlogDisplay.dart';

class BlogIntro extends StatefulWidget {
  final DocumentSnapshot snapshot;

  BlogIntro({
    @required this.snapshot,
  });

  @override
  _BlogIntroState createState() => _BlogIntroState();
}

class _BlogIntroState extends State<BlogIntro> {
  @override
  Widget build(BuildContext context) {
    return FadeIn(
      delay: 0,
      child: GestureDetector(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(bottom: 16.0),
              child: Text(
                widget.snapshot.data['title'] == null
                    ? ""
                    : widget.snapshot.data['title'],
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: Colors.teal,
                  letterSpacing: 0.2,
                  height: 1.1,
                  fontSize: 20,
                ),
              ),
            ),
            Text(
              getExcerpt(widget.snapshot.data['content']),
              style: TextStyle(
                color: Theme.of(context).accentColor,
                fontSize: 16.0,
              ),
            ),
            Text(
              widget.snapshot.data['name'] == null
                  ? ""
                  : widget.snapshot.data['name'],
              style: TextStyle(
                color: Theme.of(context).accentColor,
                fontSize: 14.0,
                height: 2,
              ),
            ),
          ],
        ),
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => BlogDisplay(
                snapshot: widget.snapshot,
              ),
            ),
          );
        },
      ),
    );
  }

  String getExcerpt(String content) {
    int wordCount = 0, i;
    for (i = 0; i < content.length && wordCount < 50; i++) {
      if (content[i].contains(' ')) wordCount++;
    }
    String excerpt = content.substring(0, i);
    if (wordCount >= 50) excerpt += ' ...';
    return excerpt;
  }
}
