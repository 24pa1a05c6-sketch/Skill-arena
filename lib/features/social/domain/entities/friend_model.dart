import 'package:equatable/equatable.dart';

enum FriendStatus { friend, pendingIncoming, pendingOutgoing, blocked, none }

enum UserPresenceStatus { online, offline, inMatch, learning, away, dnd }

class FriendModel extends Equatable {
  final String userId;
  final String userName;
  final String avatarUrl;
  final String rankTier;
  final UserPresenceStatus presence;
  final DateTime lastSeen;
  final int mutualFriendsCount;
  final FriendStatus status;

  const FriendModel({
    required this.userId,
    required this.userName,
    this.avatarUrl = '',
    this.rankTier = 'GOLD',
    this.presence = UserPresenceStatus.online,
    required this.lastSeen,
    this.mutualFriendsCount = 5,
    this.status = FriendStatus.friend,
  });

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'userName': userName,
      'avatarUrl': avatarUrl,
      'rankTier': rankTier,
      'presence': presence.name,
      'lastSeen': lastSeen.toIso8601String(),
      'mutualFriendsCount': mutualFriendsCount,
      'status': status.name,
    };
  }

  factory FriendModel.fromMap(Map<String, dynamic> map) {
    return FriendModel(
      userId: map['userId'] as String? ?? '',
      userName: map['userName'] as String? ?? 'Cyber Vanguard',
      avatarUrl: map['avatarUrl'] as String? ?? '',
      rankTier: map['rankTier'] as String? ?? 'GOLD',
      presence: UserPresenceStatus.values.firstWhere((e) => e.name == map['presence'], orElse: () => UserPresenceStatus.offline),
      lastSeen: map['lastSeen'] != null ? DateTime.parse(map['lastSeen'] as String) : DateTime.now(),
      mutualFriendsCount: map['mutualFriendsCount'] as int? ?? 5,
      status: FriendStatus.values.firstWhere((e) => e.name == map['status'], orElse: () => FriendStatus.friend),
    );
  }

  @override
  List<Object?> get props => [userId, userName, presence, status];
}
