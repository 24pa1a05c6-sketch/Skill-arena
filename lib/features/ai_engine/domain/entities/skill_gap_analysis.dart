import 'package:equatable/equatable.dart';

/// Skill Gap Analysis & Skill Forecast model.
class SkillGapAnalysis extends Equatable {
  final String userId;
  final int readinessScore;
  final List<String> strengths;
  final List<String> weaknesses;
  final List<String> priorityActions;
  final String predictedNextBadge;
  final int estimatedTournamentWinRate;

  const SkillGapAnalysis({
    required this.userId,
    this.readinessScore = 88,
    this.strengths = const ['Clean Architecture', 'SADL UI Systems', 'Widget Test Coverage'],
    this.weaknesses = const ['Network Failure Edge Cases', 'Concurrency Locking'],
    this.priorityActions = const ['Complete Cyber Security Ops Module', 'Join Flutter Architecture Showdown'],
    this.predictedNextBadge = 'Master Architect 🏆',
    this.estimatedTournamentWinRate = 82,
  });

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'readinessScore': readinessScore,
      'strengths': strengths,
      'weaknesses': weaknesses,
      'priorityActions': priorityActions,
      'predictedNextBadge': predictedNextBadge,
      'estimatedTournamentWinRate': estimatedTournamentWinRate,
    };
  }

  factory SkillGapAnalysis.fromMap(Map<String, dynamic> map) {
    return SkillGapAnalysis(
      userId: map['userId'] as String? ?? '',
      readinessScore: map['readinessScore'] as int? ?? 88,
      strengths: (map['strengths'] as List<dynamic>?)?.map((e) => e.toString()).toList() ?? const [],
      weaknesses: (map['weaknesses'] as List<dynamic>?)?.map((e) => e.toString()).toList() ?? const [],
      priorityActions: (map['priorityActions'] as List<dynamic>?)?.map((e) => e.toString()).toList() ?? const [],
      predictedNextBadge: map['predictedNextBadge'] as String? ?? 'Master Architect 🏆',
      estimatedTournamentWinRate: map['estimatedTournamentWinRate'] as int? ?? 82,
    );
  }

  @override
  List<Object?> get props => [userId, readinessScore, strengths, weaknesses, priorityActions];
}
