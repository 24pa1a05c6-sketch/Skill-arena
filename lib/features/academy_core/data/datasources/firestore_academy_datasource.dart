import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:skill_arena/core/firestore/firestore_collections.dart';
import 'package:skill_arena/core/services/analytics_service.dart';
import 'package:skill_arena/core/services/storage_service.dart';
import 'package:skill_arena/features/academy_core/domain/entities/course.dart';

/// Production Firestore Datasource for Academy Core courses, module progress & XP logging.
class FirestoreAcademyDatasource {
  final List<Course> _fallbackCourses = const [
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

  Future<List<Course>> getCourses() async {
    final storage = await StorageService.getInstance();
    final result = <Course>[];

    try {
      final snapshot = await FirebaseFirestore.instance
          .collection(FirestoreCollections.courses)
          .get(const GetOptions(source: Source.cache));

      if (snapshot.docs.isNotEmpty) {
        for (final doc in snapshot.docs) {
          result.add(_fromMap(doc.id, doc.data()));
        }
        return result;
      }
    } catch (_) {}

    for (final base in _fallbackCourses) {
      final savedProgress = storage.getCourseProgress(base.id);
      if (savedProgress.isNotEmpty) {
        final prog = (savedProgress['progress'] as num?)?.toDouble() ?? base.progress;
        final comp = (savedProgress['completedModules'] as num?)?.toInt() ?? base.completedModules;
        result.add(Course(
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
        result.add(base);
      }
    }
    return result;
  }

  Future<int> getDailyStreak() async {
    final storage = await StorageService.getInstance();
    return storage.updateDailyStreak();
  }

  Future<int> getXpEarnedToday() async {
    final storage = await StorageService.getInstance();
    return storage.getXpEarnedToday();
  }

  Future<void> updateCourseProgress(String courseId, double progress, int completedModules) async {
    final storage = await StorageService.getInstance();
    await storage.saveCourseProgress(courseId, progress, completedModules);
    await storage.addXpEarnedToday(50);

    try {
      await FirebaseFirestore.instance
          .collection(FirestoreCollections.courses)
          .doc(courseId)
          .set({
        'progress': progress,
        'completedModules': completedModules,
        'updatedAt': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));

      await FirebaseFirestore.instance
          .collection(FirestoreCollections.xpLogs)
          .add({
        'courseId': courseId,
        'xpAmount': 50,
        'timestamp': FieldValue.serverTimestamp(),
      });

      AnalyticsService.instance.logCourseStarted(courseId, 'Course Module');
    } catch (_) {}
  }

  Course _fromMap(String id, Map<String, dynamic> data) {
    return Course(
      id: id,
      title: data['title'] as String? ?? 'Course Track',
      category: data['category'] as String? ?? 'FLUTTER',
      level: data['level'] as String? ?? 'Intermediate',
      progress: (data['progress'] as num?)?.toDouble() ?? 0.0,
      totalModules: data['totalModules'] as int? ?? 10,
      completedModules: data['completedModules'] as int? ?? 0,
      xpReward: data['xpReward'] as int? ?? 500,
      icon: Icons.code,
    );
  }
}
