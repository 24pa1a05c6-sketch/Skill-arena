import 'package:skill_arena/features/tournament_engine/data/datasources/firestore_tournament_engine_datasource.dart';
import 'package:skill_arena/features/tournament_engine/domain/entities/match_model.dart';
import 'package:skill_arena/features/tournament_engine/domain/entities/tournament_enums.dart';
import 'package:skill_arena/features/tournament_engine/domain/repositories/tournament_engine_repository.dart';

/// Implementation of [TournamentEngineRepository].
class TournamentEngineRepositoryImpl implements TournamentEngineRepository {
  final FirestoreTournamentEngineDatasource _datasource;

  TournamentEngineRepositoryImpl(this._datasource);

  @override
  Future<List<List<MatchModel>>> getTournamentBrackets(String tournamentId) {
    return _datasource.getTournamentBrackets(tournamentId);
  }

  @override
  Future<List<List<MatchModel>>> generateBrackets({
    required String tournamentId,
    required List<String> playerIds,
    required MatchmakingType type,
  }) {
    return _datasource.generateBrackets(
      tournamentId: tournamentId,
      playerIds: playerIds,
      type: type,
    );
  }

  @override
  Future<void> submitMatchResult({
    required String matchId,
    required String winnerId,
    required int score1,
    required int score2,
  }) {
    return _datasource.submitMatchResult(
      matchId: matchId,
      winnerId: winnerId,
      score1: score1,
      score2: score2,
    );
  }

  @override
  Future<void> updateTournamentStatus({
    required String tournamentId,
    required TournamentStatus newStatus,
  }) {
    return _datasource.updateTournamentStatus(
      tournamentId: tournamentId,
      newStatus: newStatus,
    );
  }

  @override
  Future<Map<String, dynamic>> getUserRating(String userId) {
    return _datasource.getUserRating(userId);
  }

  @override
  Future<void> submitDispute({
    required String matchId,
    required String reason,
    required String evidenceUrl,
  }) {
    return _datasource.submitDispute(
      matchId: matchId,
      reason: reason,
      evidenceUrl: evidenceUrl,
    );
  }
}
