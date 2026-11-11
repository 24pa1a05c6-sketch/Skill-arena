import 'package:equatable/equatable.dart';

class CompanyModel extends Equatable {
  final String id;
  final String name;
  final String logoUrl;
  final String industry;
  final String location;
  final bool isVerified;
  final int openJobsCount;
  final double rating;

  const CompanyModel({
    required this.id,
    required this.name,
    this.logoUrl = '',
    this.industry = 'AI & Cloud Infrastructure',
    this.location = 'San Francisco, CA (Remote)',
    this.isVerified = true,
    this.openJobsCount = 12,
    this.rating = 4.9,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'logoUrl': logoUrl,
      'industry': industry,
      'location': location,
      'isVerified': isVerified,
      'openJobsCount': openJobsCount,
      'rating': rating,
    };
  }

  factory CompanyModel.fromMap(Map<String, dynamic> map) {
    return CompanyModel(
      id: map['id'] as String? ?? '',
      name: map['name'] as String? ?? 'Cyber Tech Enterprise',
      logoUrl: map['logoUrl'] as String? ?? '',
      industry: map['industry'] as String? ?? 'Software Engineering',
      location: map['location'] as String? ?? 'Remote',
      isVerified: map['isVerified'] as bool? ?? true,
      openJobsCount: map['openJobsCount'] as int? ?? 12,
      rating: (map['rating'] as num?)?.toDouble() ?? 4.9,
    );
  }

  @override
  List<Object?> get props => [id, name, isVerified, openJobsCount];
}
