import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:skill_arena/core/theme/tokens/app_colors.dart';
import 'package:skill_arena/features/navigation/presentation/widgets/floating_glass_nav_bar.dart';

/// Main shell for navigation with bottom nav bar.
class MainNavigationShell extends StatelessWidget {
  final StatefulNavigationShell navigationShell;

  const MainNavigationShell({
    super.key,
    required this.navigationShell,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      backgroundColor: AppColors.deepSpaceObsidian,
      body: navigationShell,
      bottomNavigationBar: FloatingGlassNavBar(
        currentIndex: navigationShell.currentIndex,
        onTap: (index) => navigationShell.goBranch(index),
      ),
    );
  }
}
