/// Tournament Lifecycle Status.
enum TournamentStatus {
  draft,
  scheduled,
  registrationOpen,
  registrationClosed,
  live,
  roundComplete,
  semiFinals,
  finals,
  completed,
  archived,
  cancelled,
}

/// Matchmaking Algorithm Type.
enum MatchmakingType {
  singleElimination,
  doubleElimination,
  roundRobin,
  swiss,
  league,
}

/// Competitive Rank Tiers based on ELO.
enum RankTier {
  bronze,
  silver,
  gold,
  platinum,
  diamond,
  master,
  grandmaster,
  legend,
}

/// Helper methods for Rank Tier string names & badges.
extension RankTierExtension on RankTier {
  String get displayName {
    switch (this) {
      case RankTier.bronze:
        return 'BRONZE';
      case RankTier.silver:
        return 'SILVER';
      case RankTier.gold:
        return 'GOLD';
      case RankTier.platinum:
        return 'PLATINUM';
      case RankTier.diamond:
        return 'DIAMOND';
      case RankTier.master:
        return 'MASTER';
      case RankTier.grandmaster:
        return 'GRANDMASTER';
      case RankTier.legend:
        return 'LEGEND';
    }
  }

  static RankTier fromElo(int elo) {
    if (elo < 1200) return RankTier.bronze;
    if (elo < 1400) return RankTier.silver;
    if (elo < 1600) return RankTier.gold;
    if (elo < 1800) return RankTier.platinum;
    if (elo < 2000) return RankTier.diamond;
    if (elo < 2200) return RankTier.master;
    if (elo < 2400) return RankTier.grandmaster;
    return RankTier.legend;
  }
}
