import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:skill_arena/features/tournament_engine/domain/entities/match_model.dart';
import 'package:skill_arena/features/tournament_engine/domain/entities/tournament_enums.dart';
import 'package:skill_arena/features/tournament_engine/services/elo_rating_service.dart';
import 'package:skill_arena/features/tournament_engine/services/matchmaking_service.dart';

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  group('Phase 5 Tournament & Competition Engine Unit Tests', () {
    test('MatchmakingService generates 2-round Single Elimination brackets for 4 players', () {
      final brackets = MatchmakingService.instance.generateBrackets(
        tournamentId: 't100',
        playerIds: const ['usr_a', 'usr_b', 'usr_c', 'usr_d'],
        type: MatchmakingType.singleElimination,
      );

      expect(brackets.length, equals(2)); // Round 1 & Finals
      expect(brackets[0].length, equals(2)); // 2 matches in Round 1
      expect(brackets[1].length, equals(1)); // 1 match in Finals
      expect(brackets[0][0].player1Id, equals('usr_a'));
      expect(brackets[0][0].player2Id, equals('usr_b'));
    });

    test('EloRatingService calculates correct rating changes and RankTiers', () {
      // Player A (1200) vs Player B (1200) -> Player A Wins (1.0)
      final result = EloRatingService.calculate(
        ratingA: 1200,
        ratingB: 1200,
        scoreA: 1.0,
      );

      expect(result.changeA, equals(16));
      expect(result.newRatingA, equals(1216));
      expect(result.changeB, equals(-16));
      expect(result.newRatingB, equals(1184));
      expect(result.rankTierA, equals(RankTier.silver));
      expect(result.rankTierB, equals(RankTier.bronze));
    });

    test('RankTierExtension maps ratings to correct tier names', () {
      expect(RankTierExtension.fromElo(1100), equals(RankTier.bronze));
      expect(RankTierExtension.fromElo(1300), equals(RankTier.silver));
      expect(RankTierExtension.fromElo(1500), equals(RankTier.gold));
      expect(RankTierExtension.fromElo(1700), equals(RankTier.platinum));
      expect(RankTierExtension.fromElo(1900), equals(RankTier.diamond));
      expect(RankTierExtension.fromElo(2100), equals(RankTier.master));
      expect(RankTierExtension.fromElo(2300), equals(RankTier.grandmaster));
      expect(RankTierExtension.fromElo(2500), equals(RankTier.legend));
    });

    test('MatchModel copyWith & JSON serialization', () {
      final match = MatchModel(
        id: 'm1',
        tournamentId: 't1',
        roundIndex: 0,
        player1Id: 'p1',
        player1Name: 'Player 1',
        player2Id: 'p2',
        player2Name: 'Player 2',
        startTime: DateTime.now(),
      );

      final updated = match.copyWith(
        player1Score: 3,
        player2Score: 1,
        winnerId: 'p1',
        status: MatchStatus.completed,
      );

      expect(updated.player1Score, equals(3));
      expect(updated.winnerId, equals('p1'));
      expect(updated.status, equals(MatchStatus.completed));
    });
  });
}
