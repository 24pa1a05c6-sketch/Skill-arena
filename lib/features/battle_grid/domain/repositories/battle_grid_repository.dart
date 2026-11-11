import '../entities/tournament.dart';

/// Contract for Battle Grid data operations.
abstract class BattleGridRepository {
  /// Fetches a list of tournaments.
  Future<List<Tournament>> getTournaments();

  /// Fetches details for a specific tournament.
  Future<Tournament> getTournamentDetails(String id);

  /// Joins a tournament.
  Future<void> joinTournament(String id);

  /// Fetches the top leaderboard entries.
  Future<List<Map<String, dynamic>>> getLeaderboard();
}
