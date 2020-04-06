import 'package:flutter/material.dart';


enum NoteStates {Busy, Idle, Done}

class Data {

  static final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
  static BuildContext buildContext;

  static final Map<int, Color> color = {
    50: Color.fromRGBO(4, 131, 184, .1),
    100: Color.fromRGBO(4, 131, 184, .2),
    200: Color.fromRGBO(4, 131, 184, .3),
    300: Color.fromRGBO(4, 131, 184, .4),
    400: Color.fromRGBO(4, 131, 184, .5),
    500: Color.fromRGBO(4, 131, 184, .6),
    600: Color.fromRGBO(4, 131, 184, .7),
    700: Color.fromRGBO(4, 131, 184, .8),
    800: Color.fromRGBO(4, 131, 184, .9),
    900: Color.fromRGBO(4, 131, 184, 1),
  };

  static Route routeSwitcher(BuildContext context, Widget pageToGo) {
    return PageRouteBuilder(
        pageBuilder: (context, animation, secondAnimation) => pageToGo,
        transitionDuration: Duration(milliseconds: 500),
        transitionsBuilder: (context, animation, secondAnimation, child) {
          var begin = Offset(1.0, 0.0);
          var end = Offset.zero;
          final tween = Tween(begin: begin, end: end);
          final animation1 = animation.drive(tween);
          return SlideTransition(
            child: child,
            position: animation1,
          );
        });
  }
}
