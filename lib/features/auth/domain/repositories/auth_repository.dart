import 'package:skill_arena/features/auth/domain/entities/user_entity.dart';

/// Contract for authentication operations.
abstract class AuthRepository {
  Future<UserEntity> loginWithEmail(String email, String password);
  Future<UserEntity> registerWithEmail(String name, String email, String password);
  Future<UserEntity> loginWithGoogle();
  Future<UserEntity> loginAsGuest();
  Future<UserEntity> upgradeGuestAccount(String email, String password);
  Future<void> logout();
  Future<UserEntity?> getCurrentUser();
}
