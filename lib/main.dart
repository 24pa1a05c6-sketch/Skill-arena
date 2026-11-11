import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:skill_arena/core/constants/app_constants.dart';
import 'package:skill_arena/core/router/app_router.dart';
import 'package:skill_arena/core/theme/app_theme.dart';

void main() {
  runApp(
    const ProviderScope(
      child: SkillArenaApp(),
    ),
  );
}

/// Root widget of the application.
class SkillArenaApp extends ConsumerWidget {
  const SkillArenaApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp.router(
      title: AppConstants.appName,
      theme: AppTheme.darkTheme,
      routerConfig: appRouter,
      debugShowCheckedModeBanner: false,
    );
  }
}
