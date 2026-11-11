import 'package:flutter/painting.dart';

/// Defines the core shadows for the application.
abstract final class AppShadows {
  static const List<BoxShadow> ambientGlow = [
    BoxShadow(
      color: Color(0x99000000),
      offset: Offset(4, 12),
      blurRadius: 24,
    ),
  ];

  static List<BoxShadow> neonGlow(Color color) {
    return [
      BoxShadow(
        color: color.withValues(alpha: 0.3),
        blurRadius: 16,
        spreadRadius: 2,
      ),
    ];
  }

  static const List<BoxShadow> elevatedSurface = [
    BoxShadow(
      color: Color(0x66000000),
      offset: Offset(0, 8),
      blurRadius: 24,
      spreadRadius: 4,
    ),
  ];
}
