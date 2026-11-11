import 'package:flutter/animation.dart';
import 'package:skill_arena/core/theme/tokens/app_curves.dart';
import 'package:skill_arena/core/theme/tokens/app_durations.dart';

/// Motion presets linking durations and curves for standard animations.
abstract final class MotionPresets {
  /// Fast duration for quick animations.
  static Duration get fastDuration => AppDurations.fast;

  /// Medium duration for standard animations.
  static Duration get mediumDuration => AppDurations.medium;

  /// Slow duration for prominent animations.
  static Duration get slowDuration => AppDurations.slow;

  /// Spring duration for physics-based animations.
  static Duration get springDuration => AppDurations.spring;

  /// Fast curve for quick animations.
  static Curve get fastCurve => AppCurves.fast;

  /// Medium curve for standard animations.
  static Curve get mediumCurve => AppCurves.medium;

  /// Slow curve for prominent animations.
  static Curve get slowCurve => AppCurves.slow;

  /// Spring curve for physics-based animations.
  static Curve get springCurve => AppCurves.spring;
}
