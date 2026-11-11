/// Entity representing a user's profile in the Identity Hub.
class UserProfile {
  /// The user's display name.
  final String name;

  /// The user's handle.
  final String handle;

  /// The user's rank title.
  final String rankTitle;

  /// The user's current level.
  final int level;

  /// The user's current XP.
  final int xp;

  /// The user's skill statistics (0.0 to 1.0).
  final Map<String, double> skillStats;

  /// Badges earned by the user.
  final List<String> badges;

  /// Number of verified certificates.
  final int certificatesCount;

  /// Win rate as a percentage (0 to 100).
  final int winRate;

  /// Total $ARENA tokens earned.
  final int arenaEarned;

  /// Whether recruiter view is enabled.
  final bool isRecruiterView;

  /// Creates a new [UserProfile] instance.
  const UserProfile({
    required this.name,
    required this.handle,
    required this.rankTitle,
    required this.level,
    required this.xp,
    required this.skillStats,
    required this.badges,
    required this.certificatesCount,
    required this.winRate,
    required this.arenaEarned,
    this.isRecruiterView = false,
  });

  /// Creates a copy of this [UserProfile] with the given fields replaced.
  UserProfile copyWith({
    String? name,
    String? handle,
    String? rankTitle,
    int? level,
    int? xp,
    Map<String, double>? skillStats,
    List<String>? badges,
    int? certificatesCount,
    int? winRate,
    int? arenaEarned,
    bool? isRecruiterView,
  }) {
    return UserProfile(
      name: name ?? this.name,
      handle: handle ?? this.handle,
      rankTitle: rankTitle ?? this.rankTitle,
      level: level ?? this.level,
      xp: xp ?? this.xp,
      skillStats: skillStats ?? this.skillStats,
      badges: badges ?? this.badges,
      certificatesCount: certificatesCount ?? this.certificatesCount,
      winRate: winRate ?? this.winRate,
      arenaEarned: arenaEarned ?? this.arenaEarned,
      isRecruiterView: isRecruiterView ?? this.isRecruiterView,
    );
  }
}
