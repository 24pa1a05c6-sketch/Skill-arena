import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:skill_arena/core/theme/app_theme.dart';
import 'package:skill_arena/core/widgets/aurora_background.dart';
import 'package:skill_arena/core/widgets/skill_avatar.dart';
import 'package:skill_arena/core/widgets/skill_badge.dart';
import 'package:skill_arena/core/widgets/skill_empty_state.dart';
import 'package:skill_arena/core/widgets/skill_glass_card.dart';
import 'package:skill_arena/core/widgets/skill_glow_button.dart';
import 'package:skill_arena/core/widgets/skill_input_field.dart';
import 'package:skill_arena/core/widgets/skill_radar_chart.dart';
import 'package:skill_arena/core/widgets/skill_skeleton_loader.dart';

Widget _wrapWithApp(Widget child) {
  return ProviderScope(
    child: MaterialApp(
      theme: AppTheme.darkTheme,
      home: Scaffold(
        body: child,
      ),
    ),
  );
}

void main() {
  group('Skill Arena Design System Component Tests', () {
    testWidgets('AuroraBackground renders child widget', (tester) async {
      await tester.pumpWidget(
        _wrapWithApp(
          const AuroraBackground(
            child: Text('Aurora Content'),
          ),
        ),
      );
      expect(find.text('Aurora Content'), findsOneWidget);
    });

    testWidgets('SkillGlassCard renders and responds to tap', (tester) async {
      bool tapped = false;
      await tester.pumpWidget(
        _wrapWithApp(
          SkillGlassCard(
            onTap: () => tapped = true,
            child: const Text('Glass Card'),
          ),
        ),
      );

      expect(find.text('Glass Card'), findsOneWidget);
      await tester.tap(find.text('Glass Card'));
      expect(tapped, isTrue);
    });

    testWidgets('SkillGlowButton renders label and triggers onPressed', (tester) async {
      bool pressed = false;
      await tester.pumpWidget(
        _wrapWithApp(
          SkillGlowButton(
            label: 'Enter Arena',
            onPressed: () => pressed = true,
          ),
        ),
      );

      expect(find.text('Enter Arena'), findsOneWidget);
      await tester.tap(find.text('Enter Arena'));
      expect(pressed, isTrue);
    });

    testWidgets('SkillInputField accepts text input', (tester) async {
      final controller = TextEditingController();
      await tester.pumpWidget(
        _wrapWithApp(
          SkillInputField(
            label: 'Username',
            controller: controller,
          ),
        ),
      );

      expect(find.text('Username'), findsOneWidget);
      await tester.enterText(find.byType(EditableText), 'CyberPlayer');
      expect(controller.text, 'CyberPlayer');
    });

    testWidgets('SkillBadge renders variant and label', (tester) async {
      await tester.pumpWidget(
        _wrapWithApp(
          const SkillBadge(
            label: 'LIVE MATCH',
            variant: SkillBadgeVariant.live,
            showPulse: true,
          ),
        ),
      );

      expect(find.text('LIVE MATCH'), findsOneWidget);
    });

    testWidgets('SkillAvatar renders initials and level badge', (tester) async {
      await tester.pumpWidget(
        _wrapWithApp(
          const SkillAvatar(
            initials: 'SA',
            level: 10,
            showStatusRing: true,
            status: SkillAvatarStatus.online,
          ),
        ),
      );

      expect(find.text('SA'), findsOneWidget);
      expect(find.text('10'), findsOneWidget);
    });

    testWidgets('SkillRadarChart renders CustomPaint canvas', (tester) async {
      await tester.pumpWidget(
        _wrapWithApp(
          const SkillRadarChart(
            data: {'Code': 0.8, 'Design': 0.6, 'Speed': 0.9},
            animate: false,
          ),
        ),
      );

      expect(find.byType(SkillRadarChart), findsOneWidget);
      expect(find.byType(CustomPaint), findsWidgets);
    });

    testWidgets('SkillSkeletonLoader renders shimmer placeholder', (tester) async {
      await tester.pumpWidget(
        _wrapWithApp(
          const SkillSkeletonCard(lines: 2, showAvatar: true),
        ),
      );

      expect(find.byType(SkillSkeletonCard), findsOneWidget);
      expect(find.byType(SkillSkeletonLoader), findsNWidgets(3));
    });

    testWidgets('SkillEmptyState renders title, message and CTA button', (tester) async {
      bool actionClicked = false;
      await tester.pumpWidget(
        _wrapWithApp(
          SkillEmptyState(
            title: 'No Matches',
            message: 'Your arena queue is clear.',
            actionLabel: 'Find Match',
            onAction: () => actionClicked = true,
          ),
        ),
      );

      expect(find.text('No Matches'), findsOneWidget);
      expect(find.text('Your arena queue is clear.'), findsOneWidget);
      expect(find.text('Find Match'), findsOneWidget);

      await tester.tap(find.text('Find Match'));
      expect(actionClicked, isTrue);
    });
  });
}
