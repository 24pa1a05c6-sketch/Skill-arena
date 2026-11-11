import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';

/// Centralized Enterprise Notification Service for push notifications & FCM message streams.
class NotificationService {
  static NotificationService? _instance;
  FirebaseMessaging? _messaging;

  NotificationService._();

  static NotificationService get instance => _instance ??= NotificationService._();

  Future<void> initialize() async {
    try {
      _messaging = FirebaseMessaging.instance;
      final settings = await _messaging?.requestPermission();

      debugPrint('[NotificationService] Permission status: ${settings?.authorizationStatus}');

      FirebaseMessaging.onMessage.listen((RemoteMessage message) {
        debugPrint('[NotificationService] Foreground message received: ${message.notification?.title}');
      });

      FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
        debugPrint('[NotificationService] Notification opened app: ${message.data}');
      });
    } catch (e) {
      debugPrint('[NotificationService] Init fallback: $e');
    }
  }

  Future<String?> getFcmToken() async {
    try {
      return await _messaging?.getToken();
    } catch (_) {
      return null;
    }
  }

  Future<void> subscribeToTopic(String topic) async {
    try {
      await _messaging?.subscribeToTopic(topic);
    } catch (_) {}
  }

  Future<void> unsubscribeFromTopic(String topic) async {
    try {
      await _messaging?.unsubscribeFromTopic(topic);
    } catch (_) {}
  }
}
