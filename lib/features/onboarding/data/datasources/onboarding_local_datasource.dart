import 'package:shared_preferences/shared_preferences.dart';

/// Local datasource responsible for persisting onboarding completion status.
class OnboardingLocalDatasource {
  static const String _keyOnboardingCompleted = 'key_onboarding_completed';

  Future<bool> isOnboardingCompleted() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_keyOnboardingCompleted) ?? false;
  }

  Future<void> setOnboardingCompleted() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyOnboardingCompleted, true);
  }
}
