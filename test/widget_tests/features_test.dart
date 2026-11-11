import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:skill_arena/core/theme/app_theme.dart';
import 'package:skill_arena/features/academy_core/presentation/screens/academy_core_screen.dart';
import 'package:skill_arena/features/auth/domain/entities/user_entity.dart';
import 'package:skill_arena/features/auth/domain/repositories/auth_repository.dart';
import 'package:skill_arena/features/auth/presentation/providers/auth_provider.dart';
import 'package:skill_arena/features/auth/presentation/screens/auth_screen.dart';
import 'package:skill_arena/features/battle_grid/presentation/screens/battle_grid_screen.dart';
import 'package:skill_arena/features/identity_hub/presentation/screens/identity_hub_screen.dart';
import 'package:skill_arena/features/nexus/presentation/screens/nexus_screen.dart';

Widget _wrapWithApp(Widget child) {
  return ProviderScope(
    child: MaterialApp(
      theme: AppTheme.darkTheme,
      home: child,
    ),
  );
}

Future<void> _pumpFrames(WidgetTester tester) async {
  for (int i = 0; i < 20; i++) {
    await tester.pump(const Duration(milliseconds: 100));
  }
}

class FakeAuthRepository implements AuthRepository {
  @override
  Future<UserEntity?> getCurrentUser() async => null;

  @override
  Future<UserEntity> loginAsGuest() async => const UserEntity(id: 'g', name: 'Guest', email: '', avatarUrl: '', level: 1, xp: 0, arenaTokens: 0, isGuest: true);

  @override
  Future<UserEntity> loginWithEmail(String email, String password) async => const UserEntity(id: 'u', name: 'User', email: 'u@test.com', avatarUrl: '', level: 1, xp: 0, arenaTokens: 0);

  @override
  Future<UserEntity> loginWithGoogle() async => const UserEntity(id: 'g', name: 'Google User', email: 'g@test.com', avatarUrl: '', level: 1, xp: 0, arenaTokens: 0);

  @override
  Future<void> logout() async {}

  @override
  Future<UserEntity> registerWithEmail(String name, String email, String password) async => const UserEntity(id: 'r', name: 'Reg User', email: 'r@test.com', avatarUrl: '', level: 1, xp: 0, arenaTokens: 0);

  @override
  Future<UserEntity> upgradeGuestAccount(String email, String password) async => const UserEntity(id: 'up', name: 'Upgraded', email: 'up@test.com', avatarUrl: '', level: 1, xp: 0, arenaTokens: 0);
}

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  group('Stage 3 Integrated Sprint Feature Tests', () {
    testWidgets('AuthScreen renders access terminal and credentials fields', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            authRepositoryProvider.overrideWithValue(FakeAuthRepository()),
          ],
          child: MaterialApp(
            theme: AppTheme.darkTheme,
            home: const AuthScreen(),
          ),
        ),
      );
      await tester.pump(const Duration(milliseconds: 200));

      expect(find.text('ACCESS TERMINAL'), findsOneWidget);
      expect(find.text('Neural Link (Email)'), findsOneWidget);
      expect(find.text('Passphrase'), findsOneWidget);
      expect(find.text('AUTHORIZE'), findsOneWidget);
      expect(find.text('SIGN IN WITH GOOGLE'), findsOneWidget);
    });

    testWidgets('NexusScreen renders header, level badge and quick actions', (tester) async {
      await tester.pumpWidget(_wrapWithApp(const NexusScreen()));
      await _pumpFrames(tester);

      expect(find.text('NEXUS DASHBOARD'), findsOneWidget);
      expect(find.text('SPOTLIGHT TOURNAMENT'), findsOneWidget);
      expect(find.text('QUICK ACTIONS'), findsOneWidget);
      expect(find.text('Battle Grid'), findsOneWidget);
    });

    testWidgets('BattleGridScreen renders search, leaderboard and tournaments', (tester) async {
      await tester.pumpWidget(_wrapWithApp(const BattleGridScreen()));
      await _pumpFrames(tester);

      expect(find.text('BATTLE GRID'), findsOneWidget);
      expect(find.text('TOP VANGUARD LEADERBOARD'), findsOneWidget);
      expect(find.text('ALL'), findsOneWidget);
      expect(find.text('LIVE'), findsWidgets);
    });

    testWidgets('AcademyCoreScreen renders streak header and skill tracks', (tester) async {
      await tester.pumpWidget(_wrapWithApp(const AcademyCoreScreen()));
      await _pumpFrames(tester);

      expect(find.text('ACADEMY CORE'), findsOneWidget);
      expect(find.text('Daily Streak'), findsOneWidget);
      expect(find.text('SKILL TRACKS'), findsOneWidget);
    });

    testWidgets('IdentityHubScreen renders user profile and skill radar matrix', (tester) async {
      await tester.pumpWidget(_wrapWithApp(const IdentityHubScreen()));
      await _pumpFrames(tester);

      expect(find.text('IDENTITY HUB'), findsOneWidget);
      expect(find.text('Cyber Vanguard'), findsOneWidget);
      expect(find.text('VERIFIABLE SKILL MATRIX'), findsOneWidget);
      expect(find.text('BADGES & TROPHIES'), findsOneWidget);
    });
  });
}
