import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/foundation.dart';

/// Centralized Enterprise Analytics Service for tracking user lifecycle & gameplay events.
class AnalyticsService {
  static AnalyticsService? _instance;
  FirebaseAnalytics? _analytics;

  AnalyticsService._();

  static AnalyticsService get instance => _instance ??= AnalyticsService._();

  Future<void> initialize() async {
    try {
      _analytics = FirebaseAnalytics.instance;
      await _analytics?.setAnalyticsCollectionEnabled(true);
    } catch (e) {
      debugPrint('[AnalyticsService] Init fallback: $e');
    }
  }

  Future<void> logAppOpen() async {
    try {
      await _analytics?.logAppOpen();
    } catch (_) {}
  }

  Future<void> logLogin(String method) async {
    try {
      await _analytics?.logLogin(loginMethod: method);
    } catch (_) {}
  }

  Future<void> logRegister(String method) async {
    try {
      await _analytics?.logSignUp(signUpMethod: method);
    } catch (_) {}
  }

  Future<void> logGuestLogin() async {
    try {
      await _analytics?.logEvent(name: 'guest_login');
    } catch (_) {}
  }

  Future<void> logCourseStarted(String courseId, String courseTitle) async {
    try {
      await _analytics?.logEvent(
        name: 'course_started',
        parameters: {'course_id': courseId, 'course_title': courseTitle},
      );
    } catch (_) {}
  }

  Future<void> logCourseCompleted(String courseId, String courseTitle, int xpEarned) async {
    try {
      await _analytics?.logEvent(
        name: 'course_completed',
        parameters: {'course_id': courseId, 'course_title': courseTitle, 'xp_earned': xpEarned},
      );
    } catch (_) {}
  }

  Future<void> logTournamentJoined(String tournamentId, String title, int fee) async {
    try {
      await _analytics?.logEvent(
        name: 'tournament_joined',
        parameters: {'tournament_id': tournamentId, 'title': title, 'fee': fee},
      );
    } catch (_) {}
  }

  Future<void> logTournamentWon(String tournamentId, int prizeTokens) async {
    try {
      await _analytics?.logEvent(
        name: 'tournament_won',
        parameters: {'tournament_id': tournamentId, 'prize_tokens': prizeTokens},
      );
    } catch (_) {}
  }

  Future<void> logBadgeUnlocked(String badgeName) async {
    try {
      await _analytics?.logEvent(
        name: 'badge_unlocked',
        parameters: {'badge_name': badgeName},
      );
    } catch (_) {}
  }

  Future<void> logProfileUpdated() async {
    try {
      await _analytics?.logEvent(name: 'profile_updated');
    } catch (_) {}
  }

  Future<void> logWalletTransaction(String txType, double amount, String currency) async {
    try {
      await _analytics?.logEvent(
        name: 'wallet_transaction',
        parameters: {'tx_type': txType, 'amount': amount, 'currency': currency},
      );
    } catch (_) {}
  }

  Future<void> logLogout() async {
    try {
      await _analytics?.logEvent(name: 'logout');
    } catch (_) {}
  }
}
