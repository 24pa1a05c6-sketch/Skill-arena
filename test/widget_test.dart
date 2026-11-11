import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:skill_arena/main.dart';

void main() {
  testWidgets('SkillArenaApp renders without crashing', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      const ProviderScope(
        child: SkillArenaApp(),
      ),
    );

    expect(find.byType(MaterialApp), findsOneWidget);
  });
}
