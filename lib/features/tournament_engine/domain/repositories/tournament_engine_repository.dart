import 'package:skill_arena/features/tournament_engine/domain/entities/match_model.dart';
import 'package:skill_arena/features/tournament_engine/domain/entities/tournament_enums.dart';

/// Repository contract interface for the Phase 5 Tournament & Competition Engine.
abstract class TournamentEngineRepository {
  /// Fetches matches for a given tournament.
  Future<List<List<MatchModel>>> getTournamentBrackets(String tournamentId);

  /// Generates tournament brackets using Matchmaking Engine.
  Future<List<List<MatchModel>>> generateBrackets({
    required String tournamentId,
    required List<String> playerIds,
    required MatchmakingType type,
  });

  /// Submits match outcome, updates scores, and calculates ELO rating adjustments.
  Future<void> submitMatchResult({
    required String matchId,
    required String winnerId,
    required int score1,
    required int score2,
  });

  /// Advances tournament to the next lifecycle stage (e.g. live -> roundComplete -> finals -> completed).
  Future<void> updateTournamentStatus({
    required String tournamentId,
    required TournamentStatus newStatus,
  });

  /// Fetches ELO ratings and rank tier for a user.
  Future<Map<String, dynamic>> getUserRating(String userId);

  /// Submits evidence or dispute for a match.
  Future<void> submitDispute({
    required String matchId,
    required String reason,
    required String evidenceUrl,
  });
}
