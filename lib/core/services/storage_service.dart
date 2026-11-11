import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

/// Production-ready persistent storage service.
class StorageService {
  static StorageService? _instance;
  static SharedPreferences? _prefs;

  StorageService._();

  static Future<StorageService> getInstance() async {
    _instance ??= StorageService._();
    _prefs ??= await SharedPreferences.getInstance();
    return _instance!;
  }

  // Keys
  static const String _keyUserSession = 'sa_user_session';
  static const String _keyJoinedTournaments = 'sa_joined_tournaments';
  static const String _keyCourseProgress = 'sa_course_progress';
  static const String _keyDailyStreak = 'sa_daily_streak';
  static const String _keyLastStreakDate = 'sa_last_streak_date';
  static const String _keyXpEarnedToday = 'sa_xp_earned_today';
  static const String _keyRecruiterMode = 'sa_recruiter_mode';
  static const String _keyUserSkills = 'sa_user_skills';

  // --- Auth Session ---
  Future<void> saveUserSession(Map<String, dynamic> userMap) async {
    await _prefs?.setString(_keyUserSession, jsonEncode(userMap));
  }

  Map<String, dynamic>? getUserSession() {
    final raw = _prefs?.getString(_keyUserSession);
    if (raw == null || raw.isEmpty) return null;
    try {
      return jsonDecode(raw) as Map<String, dynamic>;
    } catch (_) {
      return null;
    }
  }

  Future<void> clearUserSession() async {
    await _prefs?.remove(_keyUserSession);
  }

  // --- Joined Tournaments ---
  Future<void> saveJoinedTournament(String tournamentId) async {
    final list = getJoinedTournaments().toSet()..add(tournamentId);
    await _prefs?.setStringList(_keyJoinedTournaments, list.toList());
  }

  List<String> getJoinedTournaments() {
    return _prefs?.getStringList(_keyJoinedTournaments) ?? [];
  }

  // --- Course Progress ---
  Future<void> saveCourseProgress(String courseId, double progress, int completedModules) async {
    final raw = _prefs?.getString(_keyCourseProgress);
    Map<String, dynamic> map = {};
    if (raw != null && raw.isNotEmpty) {
      try {
        map = jsonDecode(raw) as Map<String, dynamic>;
      } catch (_) {}
    }
    map[courseId] = {
      'progress': progress,
      'completedModules': completedModules,
      'updatedAt': DateTime.now().toIso8601String(),
    };
    await _prefs?.setString(_keyCourseProgress, jsonEncode(map));
  }

  Map<String, dynamic> getCourseProgress(String courseId) {
    final raw = _prefs?.getString(_keyCourseProgress);
    if (raw == null || raw.isEmpty) return {};
    try {
      final map = jsonDecode(raw) as Map<String, dynamic>;
      return (map[courseId] as Map<String, dynamic>?) ?? {};
    } catch (_) {
      return {};
    }
  }

  // --- Daily Streak & XP ---
  Future<int> updateDailyStreak() async {
    final lastDateStr = _prefs?.getString(_keyLastStreakDate);
    final now = DateTime.now();
    final todayStr = '${now.year}-${now.month}-${now.day}';

    int currentStreak = _prefs?.getInt(_keyDailyStreak) ?? 1;

    if (lastDateStr == null) {
      currentStreak = 1;
      await _prefs?.setString(_keyLastStreakDate, todayStr);
      await _prefs?.setInt(_keyDailyStreak, currentStreak);
    } else if (lastDateStr != todayStr) {
      final lastDate = DateTime.parse(lastDateStr);
      final difference = now.difference(lastDate).inDays;
      if (difference == 1) {
        currentStreak += 1;
      } else if (difference > 1) {
        currentStreak = 1;
      }
      await _prefs?.setString(_keyLastStreakDate, todayStr);
      await _prefs?.setInt(_keyDailyStreak, currentStreak);
      await _prefs?.setInt(_keyXpEarnedToday, 0); // Reset daily XP tracker
    }
    return currentStreak;
  }

  int getDailyStreak() => _prefs?.getInt(_keyDailyStreak) ?? 7;

  Future<void> addXpEarnedToday(int xp) async {
    final current = _prefs?.getInt(_keyXpEarnedToday) ?? 350;
    await _prefs?.setInt(_keyXpEarnedToday, current + xp);
  }

  int getXpEarnedToday() => _prefs?.getInt(_keyXpEarnedToday) ?? 350;

  // --- Recruiter View Mode ---
  Future<void> setRecruiterMode(bool enabled) async {
    await _prefs?.setBool(_keyRecruiterMode, enabled);
  }

  bool getRecruiterMode() => _prefs?.getBool(_keyRecruiterMode) ?? false;

  // --- Skill Stats ---
  Future<void> saveUserSkills(Map<String, double> skills) async {
    await _prefs?.setString(_keyUserSkills, jsonEncode(skills));
  }

  Map<String, double> getUserSkills() {
    final raw = _prefs?.getString(_keyUserSkills);
    if (raw == null || raw.isEmpty) {
      return const {
        'Code': 0.90,
        'Design': 0.85,
        'Strategy': 0.80,
        'Sec': 0.88,
        'Speed': 0.92,
      };
    }
    try {
      final map = jsonDecode(raw) as Map<String, dynamic>;
      return map.map((key, value) => MapEntry(key, (value as num).toDouble()));
    } catch (_) {
      return const {
        'Code': 0.90,
        'Design': 0.85,
        'Strategy': 0.80,
        'Sec': 0.88,
        'Speed': 0.92,
      };
    }
  }
}
