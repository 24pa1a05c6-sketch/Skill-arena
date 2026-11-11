import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:skill_arena/features/identity_hub/data/datasources/firestore_identity_datasource.dart';
import 'package:skill_arena/features/identity_hub/domain/entities/user_profile.dart';

final firestoreIdentityDataSourceProvider = Provider<FirestoreIdentityDatasource>((ref) {
  return FirestoreIdentityDatasource();
});

class IdentityNotifier extends StateNotifier<UserProfile> {
  final FirestoreIdentityDatasource _datasource;

  IdentityNotifier(this._datasource)
      : super(
          const UserProfile(
            name: 'Cyber Vanguard',
            handle: '@vanguard_2030',
            rankTitle: 'Top 1% Global Architect',
            level: 12,
            xp: 45000,
            skillStats: {
              'Code': 0.90,
              'Design': 0.85,
              'Strategy': 0.80,
              'Sec': 0.88,
              'Speed': 0.92,
            },
            badges: [
              'Master Architect',
              '7-Day Streak',
              'Tournament Champion',
              'Bug Hunter',
            ],
            certificatesCount: 4,
            winRate: 78,
            arenaEarned: 12450,
          ),
        ) {
    _init();
  }

  Future<void> _init() async {
    final profile = await _datasource.getUserProfile('vanguard_2030');
    state = profile;
  }

  Future<void> toggleRecruiterView(bool isEnabled) async {
    state = state.copyWith(isRecruiterView: isEnabled);
    await _datasource.updateRecruiterView(isEnabled);
  }

  Future<void> updateSkillStats(Map<String, double> newStats) async {
    state = state.copyWith(skillStats: newStats);
    await _datasource.updateSkillStats('vanguard_2030', newStats);
  }
}

final identityProvider = StateNotifierProvider<IdentityNotifier, UserProfile>((ref) {
  final datasource = ref.watch(firestoreIdentityDataSourceProvider);
  return IdentityNotifier(datasource);
});
