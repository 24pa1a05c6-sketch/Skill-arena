import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/foundation.dart';

/// Centralized Remote Config Service for feature flags, maintenance mode, tournament multipliers & theme overrides.
class RemoteConfigService {
  static RemoteConfigService? _instance;
  FirebaseRemoteConfig? _remoteConfig;

  RemoteConfigService._();

  static RemoteConfigService get instance => _instance ??= RemoteConfigService._();

  Future<void> initialize() async {
    try {
      _remoteConfig = FirebaseRemoteConfig.instance;
      await _remoteConfig?.setConfigSettings(RemoteConfigSettings(
        fetchTimeout: const Duration(seconds: 10),
        minimumFetchInterval: const Duration(hours: 1),
      ));

      await _remoteConfig?.setDefaults(const {
        'is_maintenance_mode': false,
        'tournament_xp_multiplier': 1.5,
        'season_theme': 'cyber_2030',
        'min_app_version': '1.0.0',
        'announcement_banner': '',
        'enable_wallet_beta': true,
        'enable_ai_mentor_beta': true,
      });

      await _remoteConfig?.fetchAndActivate();
    } catch (e) {
      debugPrint('[RemoteConfigService] Init fallback: $e');
    }
  }

  bool get isMaintenanceMode => _remoteConfig?.getBool('is_maintenance_mode') ?? false;

  double get tournamentXpMultiplier => _remoteConfig?.getDouble('tournament_xp_multiplier') ?? 1.5;

  String get seasonTheme => _remoteConfig?.getString('season_theme') ?? 'cyber_2030';

  String get minAppVersion => _remoteConfig?.getString('min_app_version') ?? '1.0.0';

  String get announcementBanner => _remoteConfig?.getString('announcement_banner') ?? '';

  bool get enableWalletBeta => _remoteConfig?.getBool('enable_wallet_beta') ?? true;

  bool get enableAiMentorBeta => _remoteConfig?.getBool('enable_ai_mentor_beta') ?? true;
}
