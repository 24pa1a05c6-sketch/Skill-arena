import 'package:flutter/material.dart';
import 'package:skill_arena/core/theme/tokens/app_colors.dart';
import 'package:skill_arena/core/theme/tokens/app_radius.dart';
import 'package:skill_arena/core/theme/tokens/app_spacing.dart';
import 'package:skill_arena/core/theme/tokens/app_typography.dart';

class SkillSnackbar {
  SkillSnackbar._();

  static void showSuccess(BuildContext context, String message) {
    _showSnackbar(context, message, AppColors.synthEmerald, Icons.check_circle);
  }

  static void showError(BuildContext context, String message) {
    _showSnackbar(context, message, AppColors.coralBurst, Icons.error_rounded);
  }

  static void showInfo(BuildContext context, String message) {
    _showSnackbar(context, message, AppColors.electricBlue, Icons.info_rounded);
  }

  static void showWarning(BuildContext context, String message) {
    _showSnackbar(context, message, AppColors.cyberAmber, Icons.warning_rounded);
  }

  static void _showSnackbar(BuildContext context, String message, Color variantColor, IconData icon) {
    final snackBar = SnackBar(
      behavior: SnackBarBehavior.floating,
      backgroundColor: Colors.transparent,
      elevation: 0,
      margin: const EdgeInsets.symmetric(horizontal: AppSpacing.lg, vertical: AppSpacing.md),
      duration: const Duration(seconds: 3),
      content: Container(
        decoration: BoxDecoration(
          color: AppColors.surfaceElevated,
          borderRadius: AppRadius.borderMd,
          border: Border.all(color: variantColor.withValues(alpha: 0.3)),
        ),
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Row(
          children: [
            Icon(icon, color: variantColor),
            const SizedBox(width: AppSpacing.sm),
            Expanded(
              child: Text(
                message,
                style: AppTypography.bodyMedium.copyWith(color: AppColors.textPrimary),
              ),
            ),
          ],
        ),
      ),
    );

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(snackBar);
  }
}
