import 'package:flutter/material.dart';
import 'package:skill_arena/core/services/storage_service.dart';
import 'package:skill_arena/features/academy_core/domain/entities/course.dart';

abstract class AcademyDataSource {
  Future<List<Course>> getCourses();
  Future<int> getDailyStreak();
  Future<int> getXpEarnedToday();
  Future<void> updateCourseProgress(String courseId, double progress, int completedModules);
}

class MockAcademyDataSource implements AcademyDataSource {
  final List<Course> _baseCourses = const [
    Course(
      id: 'c1',
      title: 'Flutter 2030 Masterclass',
      category: 'FLUTTER',
      level: 'Advanced',
      progress: 0.68,
      totalModules: 10,
      completedModules: 6,
      xpReward: 500,
      icon: Icons.code,
    ),
    Course(
      id: 'c2',
      title: 'Cyber Security Operations',
      category: 'CYBER',
      level: 'Intermediate',
      progress: 0.20,
      totalModules: 15,
      completedModules: 3,
      xpReward: 800,
      icon: Icons.security,
    ),
    Course(
      id: 'c3',
      title: 'Generative AI Engineering',
      category: 'AI',
      level: 'Expert',
      progress: 0.0,
      totalModules: 20,
      completedModules: 0,
      xpReward: 1200,
      icon: Icons.smart_toy,
    ),
    Course(
      id: 'c4',
      title: 'Web3 Smart Contracts',
      category: 'WEB3',
      level: 'Beginner',
      progress: 1.0,
      totalModules: 5,
      completedModules: 5,
      xpReward: 300,
      icon: Icons.link,
    ),
  ];

  @override
  Future<List<Course>> getCourses() async {
    final storage = await StorageService.getInstance();
    final updatedList = <Course>[];

    for (final base in _baseCourses) {
      final savedProgress = storage.getCourseProgress(base.id);
      if (savedProgress.isNotEmpty) {
        final prog = (savedProgress['progress'] as num?)?.toDouble() ?? base.progress;
        final comp = (savedProgress['completedModules'] as num?)?.toInt() ?? base.completedModules;
        updatedList.add(Course(
          id: base.id,
          title: base.title,
          category: base.category,
          level: base.level,
          progress: prog,
          totalModules: base.totalModules,
          completedModules: comp,
          xpReward: base.xpReward,
          icon: base.icon,
        ));
      } else {
        updatedList.add(base);
      }
    }
    return updatedList;
  }

  @override
  Future<int> getDailyStreak() async {
    final storage = await StorageService.getInstance();
    return storage.updateDailyStreak();
  }

  @override
  Future<int> getXpEarnedToday() async {
    final storage = await StorageService.getInstance();
    return storage.getXpEarnedToday();
  }

  @override
  Future<void> updateCourseProgress(String courseId, double progress, int completedModules) async {
    final storage = await StorageService.getInstance();
    await storage.saveCourseProgress(courseId, progress, completedModules);
    await storage.addXpEarnedToday(50);
  }
}
