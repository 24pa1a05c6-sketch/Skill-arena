import 'package:flutter/animation.dart';

/// Defines the core animation curves for the application.
abstract final class AppCurves {
  static const Curve fast = Curves.fastOutSlowIn;
  static const Curve medium = Curves.easeInOutCubic;
  static const Curve slow = Curves.decelerate;
  static const Curve spring = Curves.elasticOut;
  static const Curve smooth = Curves.easeOutQuart;
}
