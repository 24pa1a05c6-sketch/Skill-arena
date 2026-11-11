import 'package:equatable/equatable.dart';

enum GuildRole { leader, officer, member }

class GuildMemberModel extends Equatable {
  final String userId;
  final String userName;
  final String userAvatar;
  final GuildRole role;
  final int xpContributed;
  final DateTime joinedAt;

  const GuildMemberModel({
    required this.userId,
    required this.userName,
    this.userAvatar = '',
    this.role = GuildRole.member,
    this.xpContributed = 0,
    required this.joinedAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'userName': userName,
      'userAvatar': userAvatar,
      'role': role.name,
      'xpContributed': xpContributed,
      'joinedAt': joinedAt.toIso8601String(),
    };
  }

  factory GuildMemberModel.fromMap(Map<String, dynamic> map) {
    return GuildMemberModel(
      userId: map['userId'] as String? ?? '',
      userName: map['userName'] as String? ?? 'Vanguard Member',
      userAvatar: map['userAvatar'] as String? ?? '',
      role: GuildRole.values.firstWhere((e) => e.name == map['role'], orElse: () => GuildRole.member),
      xpContributed: map['xpContributed'] as int? ?? 0,
      joinedAt: map['joinedAt'] != null ? DateTime.parse(map['joinedAt'] as String) : DateTime.now(),
    );
  }

  @override
  List<Object?> get props => [userId, userName, role, xpContributed];
}

class GuildModel extends Equatable {
  final String id;
  final String name;
  final String tag;
  final String description;
  final String logoUrl;
  final String bannerUrl;
  final int level;
  final int xp;
  final String leaderId;
  final int memberCount;
  final int maxMembers;
  final List<String> achievements;

  const GuildModel({
    required this.id,
    required this.name,
    required this.tag,
    required this.description,
    this.logoUrl = '',
    this.bannerUrl = '',
    this.level = 5,
    this.xp = 42500,
    required this.leaderId,
    this.memberCount = 18,
    this.maxMembers = 50,
    this.achievements = const ['Top 10 Global', 'Tournament Champions 2030', '100k XP Club'],
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'tag': tag,
      'description': description,
      'logoUrl': logoUrl,
      'bannerUrl': bannerUrl,
      'level': level,
      'xp': xp,
      'leaderId': leaderId,
      'memberCount': memberCount,
      'maxMembers': maxMembers,
      'achievements': achievements,
    };
  }

  factory GuildModel.fromMap(Map<String, dynamic> map) {
    return GuildModel(
      id: map['id'] as String? ?? '',
      name: map['name'] as String? ?? 'Cyber Vanguards',
      tag: map['tag'] as String? ?? 'VNGD',
      description: map['description'] as String? ?? 'Elite Competitive Software Guild',
      logoUrl: map['logoUrl'] as String? ?? '',
      bannerUrl: map['bannerUrl'] as String? ?? '',
      level: map['level'] as int? ?? 5,
      xp: map['xp'] as int? ?? 42500,
      leaderId: map['leaderId'] as String? ?? '',
      memberCount: map['memberCount'] as int? ?? 18,
      maxMembers: map['maxMembers'] as int? ?? 50,
      achievements: (map['achievements'] as List<dynamic>?)?.map((e) => e.toString()).toList() ?? const [],
    );
  }

  int get eloScore => level * 350 + 92;
  int get membersCount => memberCount;

  @override
  List<Object?> get props => [id, name, tag, level, xp, memberCount];
}
