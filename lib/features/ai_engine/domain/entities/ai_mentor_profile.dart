import 'package:equatable/equatable.dart';

/// Persistent AI Mentor Profile & Persona entity.
class AiMentorProfile extends Equatable {
  final String userId;
  final String mentorName;
  final String mentorAvatarUrl;
  final String currentFocus;
  final double growthAccelerationScore;
  final List<String> recommendedSkills;
  final List<String> strengthAreas;
  final List<String> improvementAreas;
  final int totalInteractions;

  const AiMentorProfile({
    required this.userId,
    this.mentorName = 'AURA AI MENTOR',
    this.mentorAvatarUrl = '',
    this.currentFocus = 'Flutter 2030 Architecture & Cyber Defense',
    this.growthAccelerationScore = 0.94,
    this.recommendedSkills = const ['Riverpod 3.0', 'StateNotifier Optimization', 'Smart Contracts'],
    this.strengthAreas = const ['UI Engineering', 'State Management', 'Clean Architecture'],
    this.improvementAreas = const ['Memory Leak Profiling', 'Web3 Cryptography'],
    this.totalInteractions = 42,
  });

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'mentorName': mentorName,
      'mentorAvatarUrl': mentorAvatarUrl,
      'currentFocus': currentFocus,
      'growthAccelerationScore': growthAccelerationScore,
      'recommendedSkills': recommendedSkills,
      'strengthAreas': strengthAreas,
      'improvementAreas': improvementAreas,
      'totalInteractions': totalInteractions,
    };
  }

  factory AiMentorProfile.fromMap(Map<String, dynamic> map) {
    return AiMentorProfile(
      userId: map['userId'] as String? ?? '',
      mentorName: map['mentorName'] as String? ?? 'AURA AI MENTOR',
      mentorAvatarUrl: map['mentorAvatarUrl'] as String? ?? '',
      currentFocus: map['currentFocus'] as String? ?? 'Flutter 2030 Architecture',
      growthAccelerationScore: (map['growthAccelerationScore'] as num?)?.toDouble() ?? 0.94,
      recommendedSkills: (map['recommendedSkills'] as List<dynamic>?)?.map((e) => e.toString()).toList() ?? const [],
      strengthAreas: (map['strengthAreas'] as List<dynamic>?)?.map((e) => e.toString()).toList() ?? const [],
      improvementAreas: (map['improvementAreas'] as List<dynamic>?)?.map((e) => e.toString()).toList() ?? const [],
      totalInteractions: map['totalInteractions'] as int? ?? 42,
    );
  }

  @override
  List<Object?> get props => [userId, mentorName, currentFocus, growthAccelerationScore];
}
