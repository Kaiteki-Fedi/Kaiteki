import 'package:animations/animations.dart';
import 'package:flutter/widgets.dart';

Widget fadeThrough(Widget c, Animation<double> a, Animation<double> b) {
  return FadeThroughTransition(
    animation: a,
    secondaryAnimation: b,
    child: c,
  );
}
