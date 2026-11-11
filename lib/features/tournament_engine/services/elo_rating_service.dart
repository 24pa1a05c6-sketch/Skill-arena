import 'dart:math';
import 'package:skill_arena/features/tournament_engine/domain/entities/tournament_enums.dart';

/// Calculation result of an ELO rating update.
class EloResult {
  final int newRatingA;
  final int newRatingB;
  final int changeA;
  final int changeB;
  final RankTier rankTierA;
  final RankTier rankTierB;

  const EloResult({
    required this.newRatingA,
    required this.newRatingB,
    required this.changeA,
    required this.changeB,
    required this.rankTierA,
    required this.rankTierB,
  });
}

/// Enterprise ELO / Skill Rating Calculation Engine.
class EloRatingService {
  static const int kFactorDefault = 32;
  static const int kFactorHighTier = 16;
  static const int initialRating = 1200;

  /// Calculates new ELO ratings after a match between Player A and Player B.
  /// [scoreA] = 1.0 for Win, 0.5 for Draw, 0.0 for Loss.
  static EloResult calculate({
    required int ratingA,
    required int ratingB,
    required double scoreA,
    int kFactor = kFactorDefault,
  }) {
    final expectedA = 1.0 / (1.0 + pow(10.0, (ratingB - ratingA) / 400.0));
    final expectedB = 1.0 - expectedA;
    final scoreB = 1.0 - scoreA;

    final changeA = (kFactor * (scoreA - expectedA)).round();
    final changeB = (kFactor * (scoreB - expectedB)).round();

    final newA = max(100, ratingA + changeA);
    final newB = max(100, ratingB + changeB);

    return EloResult(
      newRatingA: newA,
      newRatingB: newB,
      changeA: changeA,
      changeB: changeB,
      rankTierA: RankTierExtension.fromElo(newA),
      rankTierB: RankTierExtension.fromElo(newB),
    );
  }
}
