import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:skill_arena/core/firestore/firestore_collections.dart';
import 'package:skill_arena/core/services/analytics_service.dart';
import 'package:skill_arena/core/services/cloud_storage_service.dart';
import 'package:skill_arena/core/services/crashlytics_service.dart';
import 'package:skill_arena/core/services/notification_service.dart';
import 'package:skill_arena/core/services/remote_config_service.dart';

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  group('Phase 4 Firebase Enterprise Integration Tests', () {
    test('FirestoreCollections references all 11 enterprise collections', () {
      expect(FirestoreCollections.users, equals('users'));
      expect(FirestoreCollections.tournaments, equals('tournaments'));
      expect(FirestoreCollections.courses, equals('courses'));
      expect(FirestoreCollections.registrations, equals('registrations'));
      expect(FirestoreCollections.badges, equals('badges'));
      expect(FirestoreCollections.notifications, equals('notifications'));
      expect(FirestoreCollections.leaderboards, equals('leaderboards'));
      expect(FirestoreCollections.xpLogs, equals('xp_logs'));
      expect(FirestoreCollections.wallet, equals('wallet'));
      expect(FirestoreCollections.skills, equals('skills'));
      expect(FirestoreCollections.analyticsEvents, equals('analytics_events'));
    });

    test('AnalyticsService initializes and exposes event loggers', () async {
      final analytics = AnalyticsService.instance;
      await analytics.initialize();
      await analytics.logAppOpen();
      await analytics.logLogin('email');
      await analytics.logTournamentJoined('t1', 'Cyber Battle', 0);
      await analytics.logCourseCompleted('c1', 'Flutter Masterclass', 500);
      expect(analytics, isNotNull);
    });

    test('CrashlyticsService initializes and records custom exceptions', () async {
      final crashlytics = CrashlyticsService.instance;
      await crashlytics.initialize();
      crashlytics
        ..setUserIdentifier('usr_test_123')
        ..logCustom('Test diagnostic message')
        ..logException('Test Exception', StackTrace.current, reason: 'Unit Test Verification');
      expect(crashlytics, isNotNull);
    });

    test('RemoteConfigService exposes default feature flags and config defaults', () async {
      final remoteConfig = RemoteConfigService.instance;
      await remoteConfig.initialize();
      expect(remoteConfig.isMaintenanceMode, isFalse);
      expect(remoteConfig.tournamentXpMultiplier, equals(1.5));
      expect(remoteConfig.seasonTheme, equals('cyber_2030'));
      expect(remoteConfig.minAppVersion, equals('1.0.0'));
      expect(remoteConfig.enableWalletBeta, isTrue);
      expect(remoteConfig.enableAiMentorBeta, isTrue);
    });

    test('CloudStorageService initializes safely', () {
      final storage = CloudStorageService.instance..initialize();
      expect(storage, isNotNull);
    });

    test('NotificationService initializes safely', () async {
      final notification = NotificationService.instance;
      await notification.initialize();
      expect(notification, isNotNull);
    });
  });
}
