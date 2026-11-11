import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:skill_arena/core/theme/tokens/app_blur.dart';
import 'package:skill_arena/core/theme/tokens/app_colors.dart';
import 'package:skill_arena/core/theme/tokens/app_gradients.dart';
import 'package:skill_arena/core/theme/tokens/app_radius.dart';
import 'package:skill_arena/core/theme/tokens/app_typography.dart';

/// Floating glass navigation bar with frosted backdrop blur and cyber glow styling.
class FloatingGlassNavBar extends StatelessWidget {
  /// The currently active tab index.
  final int currentIndex;

  /// Callback when a tab is tapped.
  final ValueChanged<int> onTap;

  const FloatingGlassNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 16,
      ),
      child: ClipRRect(
        borderRadius: AppRadius.borderXl,
        child: BackdropFilter(
          filter: ImageFilter.blur(
            sigmaX: AppBlur.glass,
            sigmaY: AppBlur.glass,
          ),
          child: Container(
            height: 70,
            decoration: BoxDecoration(
              color: AppColors.cyberBlack.withValues(alpha: 0.85),
              borderRadius: AppRadius.borderXl,
              border: Border.all(
                color: AppColors.electricBlue.withValues(alpha: 0.3),
                width: 1.5,
              ),
              boxShadow: [
                BoxShadow(
                  color: AppColors.electricBlue.withValues(alpha: 0.15),
                  blurRadius: 16,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: Row(
              children: [
                _buildNavItem(0, Icons.hub_rounded, 'NEXUS'),
                _buildNavItem(1, Icons.sports_esports_rounded, 'BATTLE'),
                _buildNavItem(2, Icons.school_rounded, 'ACADEMY'),
                _buildNavItem(3, Icons.person_rounded, 'IDENTITY'),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(int index, IconData icon, String label) {
    final isActive = currentIndex == index;
    return Expanded(
      child: GestureDetector(
        onTap: () => onTap(index),
        behavior: HitTestBehavior.opaque,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeOutCubic,
          margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 6),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            gradient: isActive ? AppGradients.quantumNeon : null,
            boxShadow: isActive
                ? [
                    BoxShadow(
                      color: AppColors.neonCyan.withValues(alpha: 0.35),
                      blurRadius: 12,
                      spreadRadius: 1,
                    ),
                  ]
                : null,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: isActive ? 22 : 20,
                color: isActive ? Colors.white : AppColors.textSecondary,
              ),
              const SizedBox(height: 2),
              Text(
                label,
                style: AppTypography.cyberMonoSmall.copyWith(
                  fontSize: 10,
                  fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
                  color: isActive ? Colors.white : AppColors.textSecondary,
                  letterSpacing: 0.5,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
