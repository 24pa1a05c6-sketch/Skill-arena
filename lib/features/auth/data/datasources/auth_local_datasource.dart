import 'package:skill_arena/core/services/storage_service.dart';

/// Production-ready AuthLocalDatasource interacting with persistent StorageService.
class AuthLocalDatasource {
  Future<Map<String, dynamic>?> getSavedSession() async {
    final storage = await StorageService.getInstance();
    return storage.getUserSession();
  }

  Future<void> saveSession(Map<String, dynamic> userMap) async {
    final storage = await StorageService.getInstance();
    await storage.saveUserSession(userMap);
  }

  Future<void> clearSession() async {
    final storage = await StorageService.getInstance();
    await storage.clearUserSession();
  }
}
