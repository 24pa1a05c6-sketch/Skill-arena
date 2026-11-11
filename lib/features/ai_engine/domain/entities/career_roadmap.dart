import 'package:equatable/equatable.dart';

enum CareerPath {
  flutterDev,
  fullStack,
  aiEngineer,
  cyberSecurity,
  cloudEngineer,
  dataScientist,
  devOps,
}

extension CareerPathExtension on CareerPath {
  String get title {
    switch (this) {
      case CareerPath.flutterDev:
        return 'Flutter 2030 Lead Architect';
      case CareerPath.fullStack:
        return 'Full Stack Enterprise Engineer';
      case CareerPath.aiEngineer:
        return 'Generative AI Systems Specialist';
      case CareerPath.cyberSecurity:
        return 'Cyber Defense Operations Master';
      case CareerPath.cloudEngineer:
        return 'Cloud Infrastructure Architect';
      case CareerPath.dataScientist:
        return 'Machine Learning Data Scientist';
      case CareerPath.devOps:
        return 'DevOps & Site Reliability Expert';
    }
  }
}

class RoadmapMilestone extends Equatable {
  final String title;
  final String description;
  final bool isCompleted;
  final int xpReward;

  const RoadmapMilestone({
    required this.title,
    required this.description,
    this.isCompleted = false,
    this.xpReward = 500,
  });

  @override
  List<Object?> get props => [title, isCompleted];
}

class CareerRoadmap extends Equatable {
  final String userId;
  final CareerPath path;
  final int currentMilestoneIndex;
  final List<RoadmapMilestone> milestones;

  const CareerRoadmap({
    required this.userId,
    required this.path,
    this.currentMilestoneIndex = 2,
    required this.milestones,
  });

  @override
  List<Object?> get props => [userId, path, currentMilestoneIndex, milestones];
}
