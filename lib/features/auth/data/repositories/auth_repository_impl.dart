import 'package:skill_arena/core/services/analytics_service.dart';
import 'package:skill_arena/core/services/crashlytics_service.dart';
import 'package:skill_arena/core/services/storage_service.dart';
import 'package:skill_arena/features/auth/data/datasources/auth_local_datasource.dart';
import 'package:skill_arena/features/auth/data/datasources/firebase_auth_datasource.dart';
import 'package:skill_arena/features/auth/domain/entities/user_entity.dart';
import 'package:skill_arena/features/auth/domain/repositories/auth_repository.dart';

/// Production implementation of [AuthRepository] combining Firebase Auth & StorageService fallback.
class AuthRepositoryImpl implements AuthRepository {
  final FirebaseAuthDatasource _firebaseDatasource = FirebaseAuthDatasource();
  final AuthLocalDatasource _localDatasource = AuthLocalDatasource();

  @override
  Future<UserEntity?> getCurrentUser() async {
    final firebaseUser = await _firebaseDatasource.getCurrentUser();
    if (firebaseUser != null) {
      await _localDatasource.saveSession(_toMap(firebaseUser));
      CrashlyticsService.instance.setUserIdentifier(firebaseUser.id);
      return firebaseUser;
    }

    final sessionMap = await _localDatasource.getSavedSession();
    if (sessionMap == null) return null;

    return UserEntity(
      id: sessionMap['id'] as String? ?? 'vanguard_1',
      name: sessionMap['name'] as String? ?? 'Cyber Vanguard',
      email: sessionMap['email'] as String? ?? 'vanguard@skillarena.io',
      avatarUrl: sessionMap['avatarUrl'] as String? ?? '',
      level: sessionMap['level'] as int? ?? 12,
      xp: sessionMap['xp'] as int? ?? 4850,
      arenaTokens: sessionMap['arenaTokens'] as int? ?? 1250,
      isGuest: sessionMap['isGuest'] as bool? ?? false,
    );
  }

  @override
  Future<UserEntity> loginWithEmail(String email, String password) async {
    try {
      final user = await _firebaseDatasource.loginWithEmail(email, password);
      await _localDatasource.saveSession(_toMap(user));
      AnalyticsService.instance.logLogin('email');
      CrashlyticsService.instance.setUserIdentifier(user.id);
      return user;
    } catch (e, stack) {
      CrashlyticsService.instance.logException(e, stack, reason: 'loginWithEmail failed');
      rethrow;
    }
  }

  @override
  Future<UserEntity> registerWithEmail(String name, String email, String password) async {
    try {
      final user = await _firebaseDatasource.registerWithEmail(name, email, password);
      await _localDatasource.saveSession(_toMap(user));
      AnalyticsService.instance.logRegister('email');
      CrashlyticsService.instance.setUserIdentifier(user.id);
      return user;
    } catch (e, stack) {
      CrashlyticsService.instance.logException(e, stack, reason: 'registerWithEmail failed');
      rethrow;
    }
  }

  @override
  Future<UserEntity> loginWithGoogle() async {
    try {
      final user = await _firebaseDatasource.loginWithGoogle();
      await _localDatasource.saveSession(_toMap(user));
      AnalyticsService.instance.logLogin('google');
      CrashlyticsService.instance.setUserIdentifier(user.id);
      return user;
    } catch (e, stack) {
      CrashlyticsService.instance.logException(e, stack, reason: 'loginWithGoogle failed');
      rethrow;
    }
  }

  @override
  Future<UserEntity> loginAsGuest() async {
    try {
      final user = await _firebaseDatasource.loginAsGuest();
      await _localDatasource.saveSession(_toMap(user));
      AnalyticsService.instance.logGuestLogin();
      CrashlyticsService.instance.setUserIdentifier(user.id);
      return user;
    } catch (e, stack) {
      CrashlyticsService.instance.logException(e, stack, reason: 'loginAsGuest failed');
      rethrow;
    }
  }

  @override
  Future<UserEntity> upgradeGuestAccount(String email, String password) async {
    final current = await getCurrentUser();
    final upgraded = UserEntity(
      id: current?.id ?? 'usr_upgraded',
      name: email.split('@').first.toUpperCase(),
      email: email,
      avatarUrl: current?.avatarUrl ?? '',
      level: current?.level ?? 1,
      xp: (current?.xp ?? 150) + 500,
      arenaTokens: (current?.arenaTokens ?? 50) + 250,
    );

    await _localDatasource.saveSession(_toMap(upgraded));
    AnalyticsService.instance.logRegister('guest_upgrade');
    return upgraded;
  }

  @override
  Future<void> logout() async {
    await _firebaseDatasource.logout();
    await _localDatasource.clearSession();
    final storage = await StorageService.getInstance();
    await storage.clearUserSession();
    AnalyticsService.instance.logLogout();
  }

  Map<String, dynamic> _toMap(UserEntity user) {
    return {
      'id': user.id,
      'name': user.name,
      'email': user.email,
      'avatarUrl': user.avatarUrl,
      'level': user.level,
      'xp': user.xp,
      'arenaTokens': user.arenaTokens,
      'isGuest': user.isGuest,
    };
  }
}
