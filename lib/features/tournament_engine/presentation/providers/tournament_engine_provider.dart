import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:skill_arena/features/tournament_engine/data/datasources/firestore_tournament_engine_datasource.dart';
import 'package:skill_arena/features/tournament_engine/data/repositories/tournament_engine_repository_impl.dart';
import 'package:skill_arena/features/tournament_engine/domain/entities/match_model.dart';
import 'package:skill_arena/features/tournament_engine/domain/entities/tournament_enums.dart';
import 'package:skill_arena/features/tournament_engine/domain/repositories/tournament_engine_repository.dart';
import 'package:skill_arena/features/tournament_engine/services/rewards_engine_service.dart';

class TournamentEngineState {
  final List<List<MatchModel>> rounds;
  final TournamentStatus status;
  final bool isLoading;
  final String? errorMessage;
  final Map<String, dynamic> userRating;

  const TournamentEngineState({
    this.rounds = const [],
    this.status = TournamentStatus.live,
    this.isLoading = false,
    this.errorMessage,
    this.userRating = const {},
  });

  TournamentEngineState copyWith({
    List<List<MatchModel>>? rounds,
    TournamentStatus? status,
    bool? isLoading,
    String? errorMessage,
    Map<String, dynamic>? userRating,
  }) {
    return TournamentEngineState(
      rounds: rounds ?? this.rounds,
      status: status ?? this.status,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
      userRating: userRating ?? this.userRating,
    );
  }
}

final firestoreTournamentEngineDataSourceProvider =
    Provider<FirestoreTournamentEngineDatasource>((ref) {
  return FirestoreTournamentEngineDatasource();
});

final tournamentEngineRepositoryProvider =
    Provider<TournamentEngineRepository>((ref) {
  final ds = ref.watch(firestoreTournamentEngineDataSourceProvider);
  return TournamentEngineRepositoryImpl(ds);
});

final tournamentEngineProvider =
    StateNotifierProvider<TournamentEngineNotifier, TournamentEngineState>((ref) {
  final repo = ref.watch(tournamentEngineRepositoryProvider);
  return TournamentEngineNotifier(repo);
});

class TournamentEngineNotifier extends StateNotifier<TournamentEngineState> {
  final TournamentEngineRepository _repository;

  TournamentEngineNotifier(this._repository) : super(const TournamentEngineState()) {
    loadBrackets('t1');
    loadUserRating('vanguard_2030');
  }

  Future<void> loadBrackets(String tournamentId) async {
    state = state.copyWith(isLoading: true);
    try {
      final rounds = await _repository.getTournamentBrackets(tournamentId);
      state = state.copyWith(rounds: rounds, isLoading: false);
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: e.toString());
    }
  }

  Future<void> generateBrackets({
    required String tournamentId,
    required List<String> playerIds,
    required MatchmakingType type,
  }) async {
    state = state.copyWith(isLoading: true);
    final rounds = await _repository.generateBrackets(
      tournamentId: tournamentId,
      playerIds: playerIds,
      type: type,
    );
    state = state.copyWith(rounds: rounds, isLoading: false);
  }

  Future<void> submitResult({
    required String matchId,
    required String winnerId,
    required int score1,
    required int score2,
  }) async {
    await _repository.submitMatchResult(
      matchId: matchId,
      winnerId: winnerId,
      score1: score1,
      score2: score2,
    );
    await loadBrackets('t1');
  }

  Future<void> updateStatus(String tournamentId, TournamentStatus status) async {
    await _repository.updateTournamentStatus(tournamentId: tournamentId, newStatus: status);
    state = state.copyWith(status: status);
  }

  Future<void> loadUserRating(String userId) async {
    final rating = await _repository.getUserRating(userId);
    state = state.copyWith(userRating: rating);
  }

  Future<void> distributeRewards({
    required String tournamentId,
    required String winnerId,
    required String winnerName,
    required int prizePool,
    required int xpBonus,
  }) async {
    await RewardsEngineService.instance.distributeTournamentRewards(
      tournamentId: tournamentId,
      winnerId: winnerId,
      winnerName: winnerName,
      prizePool: prizePool,
      xpBonus: xpBonus,
    );
  }
}
