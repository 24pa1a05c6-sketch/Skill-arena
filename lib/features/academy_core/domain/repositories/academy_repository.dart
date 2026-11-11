import 'package:skill_arena/features/academy_core/domain/entities/course.dart';

/// Abstract class defining the contract for Academy repository.
abstract class AcademyRepository {
  /// Retrieves the list of available courses.
  Future<List<Course>> getCourses();

  /// Retrieves the user's current daily streak.
  Future<int> getDailyStreak();

  /// Retrieves the user's total XP earned today.
  Future<int> getXpEarnedToday();

  /// Updates course completion progress and completed modules.
  Future<void> updateCourseProgress(String courseId, double progress, int completedModules);
}
