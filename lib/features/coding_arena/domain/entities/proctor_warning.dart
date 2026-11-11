import 'package:equatable/equatable.dart';

enum ProctorViolationType { tabSwitch, copyPaste, multipleMonitors, faceMissing, screenBlur }

class ProctorWarning extends Equatable {
  final String id;
  final String userId;
  final ProctorViolationType violationType;
  final DateTime timestamp;
  final int totalViolations;

  const ProctorWarning({
    required this.id,
    required this.userId,
    required this.violationType,
    required this.timestamp,
    this.totalViolations = 1,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'violationType': violationType.name,
      'timestamp': timestamp.toIso8601String(),
      'totalViolations': totalViolations,
    };
  }

  factory ProctorWarning.fromMap(Map<String, dynamic> map) {
    return ProctorWarning(
      id: map['id'] as String? ?? '',
      userId: map['userId'] as String? ?? '',
      violationType: ProctorViolationType.values.firstWhere((e) => e.name == map['violationType'], orElse: () => ProctorViolationType.tabSwitch),
      timestamp: map['timestamp'] != null ? DateTime.parse(map['timestamp'] as String) : DateTime.now(),
      totalViolations: map['totalViolations'] as int? ?? 1,
    );
  }

  @override
  List<Object?> get props => [id, userId, violationType, timestamp];
}
