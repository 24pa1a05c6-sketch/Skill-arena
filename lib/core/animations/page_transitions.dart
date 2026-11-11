import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:skill_arena/core/theme/tokens/app_curves.dart';
import 'package:skill_arena/core/theme/tokens/app_durations.dart';

/// A subtle glass-like page transition that fades and scales up.
class GlassPageTransition<T> extends CustomTransitionPage<T> {
  /// Creates a [GlassPageTransition].
  GlassPageTransition({
    required super.child,
    super.key,
  }) : super(
          transitionDuration: AppDurations.pageTransition,
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            final curve = CurvedAnimation(
              parent: animation,
              curve: AppCurves.medium,
            );

            return FadeTransition(
              opacity: curve,
              child: ScaleTransition(
                scale: Tween<double>(begin: 0.95, end: 1.0).animate(curve),
                child: child,
              ),
            );
          },
        );
}

/// A page transition that slides up from the bottom with a fade effect.
class SlideUpPageTransition<T> extends CustomTransitionPage<T> {
  /// Creates a [SlideUpPageTransition].
  SlideUpPageTransition({
    required super.child,
    super.key,
  }) : super(
          transitionDuration: AppDurations.pageTransition,
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            final curve = CurvedAnimation(
              parent: animation,
              curve: AppCurves.medium,
            );

            return FadeTransition(
              opacity: curve,
              child: SlideTransition(
                position: Tween<Offset>(
                  begin: const Offset(0.0, 0.1),
                  end: Offset.zero,
                ).animate(curve),
                child: child,
              ),
            );
          },
        );
}
