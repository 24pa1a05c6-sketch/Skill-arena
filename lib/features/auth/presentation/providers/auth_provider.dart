import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:skill_arena/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:skill_arena/features/auth/domain/entities/user_entity.dart';
import 'package:skill_arena/features/auth/domain/repositories/auth_repository.dart';

enum AuthStatus { unauthenticated, loading, authenticated, error }

class AuthState {
  const AuthState({
    this.status = AuthStatus.unauthenticated,
    this.currentUser,
    this.errorMessage,
  });

  final AuthStatus status;
  final UserEntity? currentUser;
  final String? errorMessage;

  AuthState copyWith({
    AuthStatus? status,
    UserEntity? currentUser,
    String? errorMessage,
  }) {
    return AuthState(
      status: status ?? this.status,
      currentUser: currentUser ?? this.currentUser,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepositoryImpl();
});

final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  return AuthNotifier(ref.watch(authRepositoryProvider));
});

class AuthNotifier extends StateNotifier<AuthState> {
  AuthNotifier(this._repository) : super(const AuthState()) {
    _init();
  }

  final AuthRepository _repository;

  Future<void> _init() async {
    state = state.copyWith(status: AuthStatus.loading);
    try {
      final user = await _repository.getCurrentUser();
      if (user != null) {
        state = state.copyWith(status: AuthStatus.authenticated, currentUser: user);
      } else {
        state = state.copyWith(status: AuthStatus.unauthenticated);
      }
    } catch (e) {
      state = state.copyWith(status: AuthStatus.error, errorMessage: e.toString());
    }
  }

  Future<void> loginWithEmail(String email, String password) async {
    state = state.copyWith(status: AuthStatus.loading);
    try {
      final user = await _repository.loginWithEmail(email, password);
      state = state.copyWith(status: AuthStatus.authenticated, currentUser: user);
    } catch (e) {
      state = state.copyWith(status: AuthStatus.error, errorMessage: e.toString());
    }
  }

  Future<void> registerWithEmail(String name, String email, String password) async {
    state = state.copyWith(status: AuthStatus.loading);
    try {
      final user = await _repository.registerWithEmail(name, email, password);
      state = state.copyWith(status: AuthStatus.authenticated, currentUser: user);
    } catch (e) {
      state = state.copyWith(status: AuthStatus.error, errorMessage: e.toString());
    }
  }

  Future<void> loginWithGoogle() async {
    state = state.copyWith(status: AuthStatus.loading);
    try {
      final user = await _repository.loginWithGoogle();
      state = state.copyWith(status: AuthStatus.authenticated, currentUser: user);
    } catch (e) {
      state = state.copyWith(status: AuthStatus.error, errorMessage: e.toString());
    }
  }

  Future<void> loginAsGuest() async {
    state = state.copyWith(status: AuthStatus.loading);
    try {
      final user = await _repository.loginAsGuest();
      state = state.copyWith(status: AuthStatus.authenticated, currentUser: user);
    } catch (e) {
      state = state.copyWith(status: AuthStatus.error, errorMessage: e.toString());
    }
  }

  void updateUserMode(dynamic mode) {
    if (state.currentUser != null) {
      final updated = state.currentUser!.copyWith(mode: mode);
      state = state.copyWith(currentUser: updated);
    }
  }

  void updateProfile({String? name, String? username, String? bio}) {
    if (state.currentUser != null) {
      final updated = state.currentUser!.copyWith(
        name: name,
        username: username,
        bio: bio,
      );
      state = state.copyWith(currentUser: updated);
    }
  }
}
