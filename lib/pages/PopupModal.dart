import 'package:flutter/material.dart';

class PopupModal extends ModalRoute<Map<String, dynamic>> {
  Color background;
  Widget child;

  PopupModal({
    @required this.child,
    this.background = const Color.fromRGBO(0, 0, 0, 0.5),
  });

  @override
  Color get barrierColor => background;

  @override
  bool get barrierDismissible => false;

  @override
  String get barrierLabel => null;

  @override
  bool get maintainState => false;

  @override
  bool get opaque => false;

  @override
  Duration get transitionDuration => Duration(milliseconds: 500);

  @override
  Widget buildPage(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation) {
    return Material(
      type: MaterialType.transparency,
      child: Container(
        child: child
      ),
    );
  }

  @override
  Widget buildTransitions(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation, Widget child) {
    return FadeTransition(
      opacity: animation,
      child: ScaleTransition(
        scale: animation,
        child: child,
      ),
    );
  }
}
