import 'package:flutter/material.dart';

/// Convenient extensions on [BuildContext].
extension BuildContextX on BuildContext {
  /// The current [ThemeData].
  ThemeData get theme => Theme.of(this);

  /// The current [TextTheme].
  TextTheme get textTheme => Theme.of(this).textTheme;

  /// The current [ColorScheme].
  ColorScheme get colorScheme => Theme.of(this).colorScheme;

  /// The current [MediaQueryData].
  MediaQueryData get mediaQuery => MediaQuery.of(this);

  /// The logical size of the screen.
  Size get screenSize => MediaQuery.sizeOf(this);

  /// The width of the screen.
  double get screenWidth => MediaQuery.sizeOf(this).width;

  /// The height of the screen.
  double get screenHeight => MediaQuery.sizeOf(this).height;

  /// Returns true if the screen is considered mobile sized.
  bool get isMobile => screenWidth < 600;

  /// Returns true if the screen is considered tablet sized.
  bool get isTablet => screenWidth >= 600 && screenWidth < 1024;

  /// Returns true if the screen is considered desktop sized.
  bool get isDesktop => screenWidth >= 1024;
}
