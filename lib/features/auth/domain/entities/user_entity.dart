import 'package:equatable/equatable.dart';
import 'package:skill_arena/core/enums/user_mode.dart';

/// Represents a user in the Skill Arena.
class UserEntity extends Equatable {
  const UserEntity({
    required this.id,
    required this.name,
    required this.email,
    required this.avatarUrl,
    required this.level,
    required this.xp,
    required this.arenaTokens,
    this.isGuest = false,
    this.mode = UserMode.both,
    this.username = 'vanguard_2030',
    this.bio = 'Cyber Vanguard & Multi-Arena Specialist',
    this.verifiedSkills = const {'Flutter': 0.92, 'DSA': 0.84, 'Gaming': 0.95},
    this.socialLinks = const {'github': 'github.com/vanguard', 'leetcode': 'leetcode.com/vanguard'},
  });

  final String id;
  final String name;
  final String email;
  final String avatarUrl;
  final int level;
  final int xp;
  final int arenaTokens;
  final bool isGuest;
  final UserMode mode;
  final String username;
  final String bio;
  final Map<String, double> verifiedSkills;
  final Map<String, String> socialLinks;

  UserEntity copyWith({
    String? id,
    String? name,
    String? email,
    String? avatarUrl,
    int? level,
    int? xp,
    int? arenaTokens,
    bool? isGuest,
    UserMode? mode,
    String? username,
    String? bio,
    Map<String, double>? verifiedSkills,
    Map<String, String>? socialLinks,
  }) {
    return UserEntity(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      level: level ?? this.level,
      xp: xp ?? this.xp,
      arenaTokens: arenaTokens ?? this.arenaTokens,
      isGuest: isGuest ?? this.isGuest,
      mode: mode ?? this.mode,
      username: username ?? this.username,
      bio: bio ?? this.bio,
      verifiedSkills: verifiedSkills ?? this.verifiedSkills,
      socialLinks: socialLinks ?? this.socialLinks,
    );
  }

  @override
  List<Object?> get props => [
        id,
        name,
        email,
        avatarUrl,
        level,
        xp,
        arenaTokens,
        isGuest,
        mode,
        username,
        bio,
        verifiedSkills,
        socialLinks,
      ];
}
