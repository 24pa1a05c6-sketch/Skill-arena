import 'package:flutter/services.dart';

/// Provides haptic feedback utilities.
abstract final class HapticService {
  /// Provides a light haptic tap.
  static Future<void> lightTap() => HapticFeedback.lightImpact();

  /// Provides a selection click haptic feedback.
  static Future<void> selectionTap() => HapticFeedback.selectionClick();

  /// Provides a heavy haptic tap.
  static Future<void> heavyTap() => HapticFeedback.heavyImpact();

  /// Vibrates the device.
  static Future<void> vibrate() => HapticFeedback.vibrate();
}
