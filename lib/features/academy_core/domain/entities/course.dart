import 'package:flutter/material.dart';

/// Entity representing a course in the Academy.
class Course {
  /// Unique identifier for the course.
  final String id;

  /// Title of the course.
  final String title;

  /// Category of the course (e.g., FLUTTER, AI, WEB3).
  final String category;

  /// Difficulty level of the course.
  final String level;

  /// User's progress in the course (0.0 to 1.0).
  final double progress;

  /// Total number of modules in the course.
  final int totalModules;

  /// Number of modules completed by the user.
  final int completedModules;

  /// XP awarded upon course completion.
  final int xpReward;

  /// Icon representing the course.
  final IconData icon;

  /// Creates a new [Course] instance.
  const Course({
    required this.id,
    required this.title,
    required this.category,
    required this.level,
    required this.progress,
    required this.totalModules,
    required this.completedModules,
    required this.xpReward,
    required this.icon,
  });
}
