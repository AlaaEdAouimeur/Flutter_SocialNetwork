import 'dart:async';
import 'package:flutter/material.dart';

class FadeIn extends StatefulWidget {
  final Widget child;
  final int delay;

  FadeIn({@required this.child, this.delay});

  @override
  _FadeInState createState() => _FadeInState();
}

class _FadeInState extends State<FadeIn> with TickerProviderStateMixin {
  AnimationController _animController;

  @override
  void initState() {
    super.initState();

    _animController = AnimationController(vsync: this, duration: Duration(seconds: 1));

    if (widget.delay == null) {
      _animController.forward();
    } else {
      Timer(Duration(milliseconds: widget.delay), () {
        _animController.forward();
      });
    }
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      child: widget.child,
      opacity: _animController,
    );
  }
}