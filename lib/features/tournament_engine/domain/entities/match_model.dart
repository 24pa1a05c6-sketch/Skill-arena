import 'package:equatable/equatable.dart';

enum MatchStatus { pending, live, completed, disputed }

/// Match Entity representing a tournament competition match between 2 players.
class MatchModel extends Equatable {
  final String id;
  final String tournamentId;
  final int roundIndex;
  final String player1Id;
  final String player1Name;
  final String player2Id;
  final String player2Name;
  final int player1Score;
  final int player2Score;
  final String? winnerId;
  final MatchStatus status;
  final DateTime startTime;
  final DateTime? endTime;
  final String refereeId;
  final bool isVerified;
  final List<String> evidenceUrls;

  const MatchModel({
    required this.id,
    required this.tournamentId,
    required this.roundIndex,
    required this.player1Id,
    required this.player1Name,
    required this.player2Id,
    required this.player2Name,
    this.player1Score = 0,
    this.player2Score = 0,
    this.winnerId,
    this.status = MatchStatus.pending,
    required this.startTime,
    this.endTime,
    this.refereeId = 'system_referee',
    this.isVerified = false,
    this.evidenceUrls = const [],
  });

  MatchModel copyWith({
    int? player1Score,
    int? player2Score,
    String? winnerId,
    MatchStatus? status,
    DateTime? endTime,
    bool? isVerified,
    List<String>? evidenceUrls,
  }) {
    return MatchModel(
      id: id,
      tournamentId: tournamentId,
      roundIndex: roundIndex,
      player1Id: player1Id,
      player1Name: player1Name,
      player2Id: player2Id,
      player2Name: player2Name,
      player1Score: player1Score ?? this.player1Score,
      player2Score: player2Score ?? this.player2Score,
      winnerId: winnerId ?? this.winnerId,
      status: status ?? this.status,
      startTime: startTime,
      endTime: endTime ?? this.endTime,
      refereeId: refereeId,
      isVerified: isVerified ?? this.isVerified,
      evidenceUrls: evidenceUrls ?? this.evidenceUrls,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'tournamentId': tournamentId,
      'roundIndex': roundIndex,
      'player1Id': player1Id,
      'player1Name': player1Name,
      'player2Id': player2Id,
      'player2Name': player2Name,
      'player1Score': player1Score,
      'player2Score': player2Score,
      'winnerId': winnerId,
      'status': status.name,
      'startTime': startTime.toIso8601String(),
      'endTime': endTime?.toIso8601String(),
      'refereeId': refereeId,
      'isVerified': isVerified,
      'evidenceUrls': evidenceUrls,
    };
  }

  factory MatchModel.fromMap(Map<String, dynamic> map) {
    return MatchModel(
      id: map['id'] as String? ?? '',
      tournamentId: map['tournamentId'] as String? ?? '',
      roundIndex: map['roundIndex'] as int? ?? 0,
      player1Id: map['player1Id'] as String? ?? 'Player 1',
      player1Name: map['player1Name'] as String? ?? 'Player 1',
      player2Id: map['player2Id'] as String? ?? 'Player 2',
      player2Name: map['player2Name'] as String? ?? 'Player 2',
      player1Score: map['player1Score'] as int? ?? 0,
      player2Score: map['player2Score'] as int? ?? 0,
      winnerId: map['winnerId'] as String?,
      status: MatchStatus.values.firstWhere(
        (e) => e.name == map['status'],
        orElse: () => MatchStatus.pending,
      ),
      startTime: map['startTime'] != null
          ? DateTime.parse(map['startTime'] as String)
          : DateTime.now(),
      endTime: map['endTime'] != null ? DateTime.parse(map['endTime'] as String) : null,
      refereeId: map['refereeId'] as String? ?? 'system_referee',
      isVerified: map['isVerified'] as bool? ?? false,
      evidenceUrls: (map['evidenceUrls'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          const [],
    );
  }

  @override
  List<Object?> get props => [
        id,
        tournamentId,
        roundIndex,
        player1Id,
        player2Id,
        player1Score,
        player2Score,
        winnerId,
        status,
      ];
}
