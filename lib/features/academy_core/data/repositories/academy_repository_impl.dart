import 'package:skill_arena/features/academy_core/data/datasources/firestore_academy_datasource.dart';
import 'package:skill_arena/features/academy_core/domain/entities/course.dart';
import 'package:skill_arena/features/academy_core/domain/repositories/academy_repository.dart';

/// Implementation of [AcademyRepository] using FirestoreAcademyDatasource.
class AcademyRepositoryImpl implements AcademyRepository {
  final FirestoreAcademyDatasource _dataSource;

  AcademyRepositoryImpl(this._dataSource);

  @override
  Future<List<Course>> getCourses() => _dataSource.getCourses();

  @override
  Future<int> getDailyStreak() => _dataSource.getDailyStreak();

  @override
  Future<int> getXpEarnedToday() => _dataSource.getXpEarnedToday();

  @override
  Future<void> updateCourseProgress(String courseId, double progress, int completedModules) =>
      _dataSource.updateCourseProgress(courseId, progress, completedModules);
}
