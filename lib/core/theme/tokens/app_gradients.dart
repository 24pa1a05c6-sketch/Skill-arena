import 'package:flutter/widgets.dart';
import 'package:skill_arena/core/theme/tokens/app_colors.dart';

/// Defines the core gradients for the application.
abstract final class AppGradients {
  static const LinearGradient auroraShimmer = LinearGradient(
    colors: [
      AppColors.electricBlue,
      AppColors.royalPurple,
    ],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient quantumNeon = LinearGradient(
    colors: [
      AppColors.neonCyan,
      AppColors.electricBlue,
    ],
  );

  static const LinearGradient glassEdge = LinearGradient(
    colors: [
      AppColors.glassHighlight,
      AppColors.glassBorderFade,
    ],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient holographicSheen = LinearGradient(
    colors: [
      AppColors.neonCyan,
      AppColors.royalPurple,
      AppColors.electricBlue,
    ],
  );

  static const RadialGradient surfaceGradient = RadialGradient(
    colors: [
      AppColors.cyberBlack,
      AppColors.deepSpaceObsidian,
    ],
    radius: 1.0,
  );
}
