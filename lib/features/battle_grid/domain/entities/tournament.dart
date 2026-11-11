import 'package:equatable/equatable.dart';

/// Represents a Battle Grid tournament.
class Tournament extends Equatable {
  /// Unique identifier
  final String id;
  /// Tournament title
  final String title;
  /// Category (e.g. Flutter, Web3)
  final String category;
  /// Difficulty level
  final String difficulty;
  /// Prize pool in $ARENA tokens
  final int prizeTokens;
  /// Current number of participants
  final int participantCount;
  /// Maximum number of participants allowed
  final int maxParticipants;
  /// Start time of the tournament
  final DateTime startTime;
  /// Status of the tournament ('live', 'upcoming', 'completed')
  final String status;
  /// Bracket rounds
  final List<String> bracketRounds;

  /// Creates a [Tournament].
  const Tournament({
    required this.id,
    required this.title,
    required this.category,
    required this.difficulty,
    required this.prizeTokens,
    required this.participantCount,
    required this.maxParticipants,
    required this.startTime,
    required this.status,
    required this.bracketRounds,
  });

  @override
  List<Object?> get props => [
        id,
        title,
        category,
        difficulty,
        prizeTokens,
        participantCount,
        maxParticipants,
        startTime,
        status,
        bracketRounds,
      ];
}
