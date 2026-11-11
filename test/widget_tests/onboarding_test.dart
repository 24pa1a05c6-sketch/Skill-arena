import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:skill_arena/core/theme/app_theme.dart';
import 'package:skill_arena/features/onboarding/presentation/screens/onboarding_screen.dart';

Widget _wrapWithApp(Widget child) {
  return ProviderScope(
    child: MaterialApp(
      theme: AppTheme.darkTheme,
      home: child,
    ),
  );
}

Future<void> _pumpPageTransition(WidgetTester tester) async {
  for (int i = 0; i < 10; i++) {
    await tester.pump(const Duration(milliseconds: 100));
  }
}

void main() {
  group('Genesis Portal Onboarding Tests', () {
    testWidgets('OnboardingScreen renders initial slide and branding', (tester) async {
      await tester.pumpWidget(_wrapWithApp(const OnboardingScreen()));
      await _pumpPageTransition(tester);

      expect(find.text('SKILL ARENA'), findsOneWidget);
      expect(find.text('Learn. Compete. Prove. Grow.'), findsOneWidget);
      expect(find.text('ENTER ARENA'), findsOneWidget);
      expect(find.text('SKIP'), findsOneWidget);
    });

    testWidgets('Tapping NEXT STEP advances through slides', (tester) async {
      await tester.pumpWidget(_wrapWithApp(const OnboardingScreen()));
      await _pumpPageTransition(tester);

      // Slide 1 (Welcome) -> Click ENTER ARENA
      await tester.tap(find.text('ENTER ARENA'));
      await _pumpPageTransition(tester);

      // Slide 2 (Learn)
      expect(find.text('Master Futuristic Stacks'), findsOneWidget);
      expect(find.text('NEXT STEP'), findsOneWidget);

      // Slide 2 -> Click NEXT STEP -> Slide 3 (Compete)
      await tester.tap(find.text('NEXT STEP'));
      await _pumpPageTransition(tester);
      expect(find.text('High-Stakes Tournaments'), findsOneWidget);
    });

    testWidgets('Final slide displays Create Account and Continue as Guest buttons', (tester) async {
      await tester.pumpWidget(_wrapWithApp(const OnboardingScreen()));
      await _pumpPageTransition(tester);

      // Tap SKIP to go to final slide
      await tester.tap(find.text('SKIP'));
      await _pumpPageTransition(tester);

      expect(find.text('CREATE ACCOUNT'), findsOneWidget);
      expect(find.text('CONTINUE AS GUEST'), findsOneWidget);
    });
  });
}
