import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:skill_arena/core/services/analytics_service.dart';
import 'package:skill_arena/core/services/crashlytics_service.dart';
import 'package:skill_arena/core/services/notification_service.dart';
import 'package:skill_arena/core/services/remote_config_service.dart';

/// Centralized Enterprise Firebase Initialization & Core Service Manager.
class FirebaseService {
  static FirebaseService? _instance;
  static bool _isInitialized = false;

  FirebaseService._();

  static FirebaseService get instance => _instance ??= FirebaseService._();

  static bool get isInitialized => _isInitialized;

  /// Initializes all Enterprise Firebase Services with offline cache & error guards.
  static Future<void> initialize() async {
    if (_isInitialized) return;
    try {
      // 1. Core Firebase App
      await Firebase.initializeApp();

      // 2. Firestore Offline Persistence
      FirebaseFirestore.instance.settings = const Settings(
        persistenceEnabled: true,
        cacheSizeBytes: Settings.CACHE_SIZE_UNLIMITED,
      );

      // 3. Subsidiary Services
      await CrashlyticsService.instance.initialize();
      await AnalyticsService.instance.initialize();
      await RemoteConfigService.instance.initialize();
      await NotificationService.instance.initialize();

      _isInitialized = true;
      debugPrint('[FirebaseService] Successfully initialized Firebase Enterprise Stack.');
    } catch (e, stack) {
      debugPrint('[FirebaseService] Firebase init fallback mode: $e');
      CrashlyticsService.instance.logException(e, stack, reason: 'Firebase initialization fallback');
    }
  }
}
