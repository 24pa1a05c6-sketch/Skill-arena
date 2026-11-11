import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:skill_arena/core/theme/tokens/app_colors.dart';

enum AppThemeMode {
  darkObsidian,
  cyberAmber,
  synthEmerald,
  royalPurple,
}

class AppThemeState {
  final AppThemeMode mode;
  final Color primaryAccent;
  final Color background;
  final String name;

  const AppThemeState({
    required this.mode,
    required this.primaryAccent,
    required this.background,
    required this.name,
  });
}

class ThemeNotifier extends StateNotifier<AppThemeState> {
  ThemeNotifier()
      : super(const AppThemeState(
          mode: AppThemeMode.darkObsidian,
          primaryAccent: AppColors.electricBlue,
          background: AppColors.deepSpaceObsidian,
          name: 'Dark Obsidian',
        ));

  void setTheme(AppThemeMode mode) {
    switch (mode) {
      case AppThemeMode.darkObsidian:
        state = const AppThemeState(
          mode: AppThemeMode.darkObsidian,
          primaryAccent: AppColors.electricBlue,
          background: AppColors.deepSpaceObsidian,
          name: 'Dark Obsidian',
        );
        break;
      case AppThemeMode.cyberAmber:
        state = const AppThemeState(
          mode: AppThemeMode.cyberAmber,
          primaryAccent: AppColors.cyberAmber,
          background: Color(0xFF140F06),
          name: 'Cyber Amber',
        );
        break;
      case AppThemeMode.synthEmerald:
        state = const AppThemeState(
          mode: AppThemeMode.synthEmerald,
          primaryAccent: AppColors.synthEmerald,
          background: Color(0xFF06140E),
          name: 'Synth Emerald',
        );
        break;
      case AppThemeMode.royalPurple:
        state = const AppThemeState(
          mode: AppThemeMode.royalPurple,
          primaryAccent: AppColors.royalPurple,
          background: Color(0xFF0F0614),
          name: 'Royal Purple',
        );
        break;
    }
  }
}

final themeProvider = StateNotifierProvider<ThemeNotifier, AppThemeState>((ref) {
  return ThemeNotifier();
});
