import 'package:equatable/equatable.dart';

class CodingProblem extends Equatable {
  final String id;
  final String title;
  final String description;
  final String difficulty; // Easy, Medium, Hard, Expert
  final List<String> sampleInputs;
  final List<String> sampleOutputs;
  final int hiddenTestCasesCount;
  final int timeLimitMs;
  final int memoryLimitMb;

  const CodingProblem({
    required this.id,
    required this.title,
    required this.description,
    this.difficulty = 'Hard',
    this.sampleInputs = const ['[2, 7, 11, 15], target = 9'],
    this.sampleOutputs = const ['[0, 1]'],
    this.hiddenTestCasesCount = 10,
    this.timeLimitMs = 1000,
    this.memoryLimitMb = 256,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'difficulty': difficulty,
      'sampleInputs': sampleInputs,
      'sampleOutputs': sampleOutputs,
      'hiddenTestCasesCount': hiddenTestCasesCount,
      'timeLimitMs': timeLimitMs,
      'memoryLimitMb': memoryLimitMb,
    };
  }

  factory CodingProblem.fromMap(Map<String, dynamic> map) {
    return CodingProblem(
      id: map['id'] as String? ?? '',
      title: map['title'] as String? ?? 'Riverpod State Concurrency',
      description: map['description'] as String? ?? 'Optimize Riverpod state notifier state propagation',
      difficulty: map['difficulty'] as String? ?? 'Hard',
      sampleInputs: (map['sampleInputs'] as List<dynamic>?)?.map((e) => e.toString()).toList() ?? const [],
      sampleOutputs: (map['sampleOutputs'] as List<dynamic>?)?.map((e) => e.toString()).toList() ?? const [],
      hiddenTestCasesCount: map['hiddenTestCasesCount'] as int? ?? 10,
      timeLimitMs: map['timeLimitMs'] as int? ?? 1000,
      memoryLimitMb: map['memoryLimitMb'] as int? ?? 256,
    );
  }

  @override
  List<Object?> get props => [id, title, difficulty];
}
