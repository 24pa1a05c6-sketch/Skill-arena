import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';

/// Centralized Enterprise Crashlytics Service for exception logging & diagnostic reporting.
class CrashlyticsService {
  static CrashlyticsService? _instance;
  FirebaseCrashlytics? _crashlytics;

  CrashlyticsService._();

  static CrashlyticsService get instance => _instance ??= CrashlyticsService._();

  Future<void> initialize() async {
    try {
      _crashlytics = FirebaseCrashlytics.instance;
      await _crashlytics?.setCrashlyticsCollectionEnabled(!kDebugMode);

      // Pass Flutter errors to Crashlytics
      FlutterError.onError = _crashlytics?.recordFlutterFatalError;
      PlatformDispatcher.instance.onError = (error, stack) {
        _crashlytics?.recordError(error, stack, fatal: true);
        return true;
      };
    } catch (e) {
      debugPrint('[CrashlyticsService] Init fallback: $e');
    }
  }

  void logException(dynamic exception, StackTrace? stack, {String? reason, bool fatal = false}) {
    if (_crashlytics == null) return;
    debugPrint('[CrashlyticsService] Logged Exception: $exception | Reason: $reason');
    try {
      _crashlytics?.recordError(exception, stack, reason: reason, fatal: fatal);
    } catch (_) {}
  }

  void setUserIdentifier(String userId) {
    try {
      _crashlytics?.setUserIdentifier(userId);
    } catch (_) {}
  }

  void logCustom(String message) {
    try {
      _crashlytics?.log(message);
    } catch (_) {}
  }
}
