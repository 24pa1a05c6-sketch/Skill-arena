import 'package:equatable/equatable.dart';

class JobModel extends Equatable {
  final String id;
  final String companyId;
  final String companyName;
  final String title;
  final String location;
  final String salaryRange;
  final String jobType; // Full-time, Remote, Internship, Contract
  final List<String> requiredSkills;
  final int applicantCount;
  final DateTime postedAt;

  const JobModel({
    required this.id,
    required this.companyId,
    required this.companyName,
    required this.title,
    this.location = 'Remote / Distributed',
    this.salaryRange = '\$160k - \$220k',
    this.jobType = 'Full-Time Remote',
    this.requiredSkills = const ['Flutter 2030', 'Riverpod', 'Clean Architecture'],
    this.applicantCount = 38,
    required this.postedAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'companyId': companyId,
      'companyName': companyName,
      'title': title,
      'location': location,
      'salaryRange': salaryRange,
      'jobType': jobType,
      'requiredSkills': requiredSkills,
      'applicantCount': applicantCount,
      'postedAt': postedAt.toIso8601String(),
    };
  }

  factory JobModel.fromMap(Map<String, dynamic> map) {
    return JobModel(
      id: map['id'] as String? ?? '',
      companyId: map['companyId'] as String? ?? '',
      companyName: map['companyName'] as String? ?? 'Enterprise Labs',
      title: map['title'] as String? ?? 'Senior Flutter Architect',
      location: map['location'] as String? ?? 'Remote',
      salaryRange: map['salaryRange'] as String? ?? '\$160k - \$220k',
      jobType: map['jobType'] as String? ?? 'Full-Time',
      requiredSkills: (map['requiredSkills'] as List<dynamic>?)?.map((e) => e.toString()).toList() ?? const [],
      applicantCount: map['applicantCount'] as int? ?? 38,
      postedAt: map['postedAt'] != null ? DateTime.parse(map['postedAt'] as String) : DateTime.now(),
    );
  }

  @override
  List<Object?> get props => [id, companyId, title, salaryRange];
}
