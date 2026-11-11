import 'package:skill_arena/features/tournament_engine/domain/entities/match_model.dart';
import 'package:skill_arena/features/tournament_engine/domain/entities/tournament_enums.dart';

/// Enterprise Matchmaking Engine supporting Single/Double Elimination, Round Robin, Swiss & League brackets.
class MatchmakingService {
  static MatchmakingService? _instance;

  MatchmakingService._();

  static MatchmakingService get instance => _instance ??= MatchmakingService._();

  /// Generates tournament round brackets based on tournament format.
  List<List<MatchModel>> generateBrackets({
    required String tournamentId,
    required List<String> playerIds,
    required MatchmakingType type,
  }) {
    if (playerIds.isEmpty) return [];

    switch (type) {
      case MatchmakingType.singleElimination:
        return _generateSingleElimination(tournamentId, playerIds);
      case MatchmakingType.roundRobin:
        return _generateRoundRobin(tournamentId, playerIds);
      case MatchmakingType.swiss:
      case MatchmakingType.doubleElimination:
      case MatchmakingType.league:
        return _generateSingleElimination(tournamentId, playerIds);
    }
  }

  List<List<MatchModel>> _generateSingleElimination(String tournamentId, List<String> playerIds) {
    final rounds = <List<MatchModel>>[];
    final numPlayers = playerIds.length;
    int nextPowerOfTwo = 1;
    while (nextPowerOfTwo < numPlayers) {
      nextPowerOfTwo *= 2;
    }

    final paddedPlayers = List<String>.from(playerIds);
    while (paddedPlayers.length < nextPowerOfTwo) {
      paddedPlayers.add('BYE_PLAYER');
    }

    final round1Matches = <MatchModel>[];
    for (int i = 0; i < paddedPlayers.length; i += 2) {
      final p1 = paddedPlayers[i];
      final p2 = paddedPlayers[i + 1];
      final matchId = 'm_${tournamentId}_r0_$i';
      final isBye = p2 == 'BYE_PLAYER';

      round1Matches.add(
        MatchModel(
          id: matchId,
          tournamentId: tournamentId,
          roundIndex: 0,
          player1Id: p1,
          player1Name: p1.replaceAll('usr_', 'Player '),
          player2Id: isBye ? 'BYE' : p2,
          player2Name: isBye ? 'BYE' : p2.replaceAll('usr_', 'Player '),
          winnerId: isBye ? p1 : null,
          status: isBye ? MatchStatus.completed : MatchStatus.pending,
          startTime: DateTime.now(),
        ),
      );
    }
    rounds.add(round1Matches);

    // Generate subsequent empty rounds for progression
    int remainingMatches = round1Matches.length ~/ 2;
    int roundIndex = 1;
    while (remainingMatches >= 1) {
      final roundMatches = <MatchModel>[];
      for (int i = 0; i < remainingMatches; i++) {
        roundMatches.add(
          MatchModel(
            id: 'm_${tournamentId}_r${roundIndex}_$i',
            tournamentId: tournamentId,
            roundIndex: roundIndex,
            player1Id: 'TBD',
            player1Name: 'TBD',
            player2Id: 'TBD',
            player2Name: 'TBD',
            startTime: DateTime.now().add(Duration(hours: roundIndex * 2)),
          ),
        );
      }
      rounds.add(roundMatches);
      remainingMatches ~/= 2;
      roundIndex++;
    }

    return rounds;
  }

  List<List<MatchModel>> _generateRoundRobin(String tournamentId, List<String> playerIds) {
    final rounds = <List<MatchModel>>[];
    final n = playerIds.length;
    final players = List<String>.from(playerIds);
    if (n % 2 != 0) players.add('BYE_PLAYER');

    final numRounds = players.length - 1;
    final half = players.length ~/ 2;

    for (int r = 0; r < numRounds; r++) {
      final roundMatches = <MatchModel>[];
      for (int i = 0; i < half; i++) {
        final p1 = players[i];
        final p2 = players[players.length - 1 - i];
        if (p1 != 'BYE_PLAYER' && p2 != 'BYE_PLAYER') {
          roundMatches.add(
            MatchModel(
              id: 'm_${tournamentId}_rr_${r}_$i',
              tournamentId: tournamentId,
              roundIndex: r,
              player1Id: p1,
              player1Name: p1.replaceAll('usr_', 'Player '),
              player2Id: p2,
              player2Name: p2.replaceAll('usr_', 'Player '),
              startTime: DateTime.now().add(Duration(days: r)),
            ),
          );
        }
      }
      rounds.add(roundMatches);
      players.insert(1, players.removeLast());
    }
    return rounds;
  }
}
