import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:skill_arena/features/academy_core/data/datasources/firestore_academy_datasource.dart';
import 'package:skill_arena/features/academy_core/data/repositories/academy_repository_impl.dart';
import 'package:skill_arena/features/academy_core/domain/entities/course.dart';
import 'package:skill_arena/features/academy_core/domain/repositories/academy_repository.dart';

class AcademyState {
  final List<Course> courses;
  final int dailyStreak;
  final int xpEarnedToday;
  final String selectedCategory;
  final bool isLoading;

  const AcademyState({
    this.courses = const [],
    this.dailyStreak = 7,
    this.xpEarnedToday = 350,
    this.selectedCategory = 'ALL',
    this.isLoading = false,
  });

  AcademyState copyWith({
    List<Course>? courses,
    int? dailyStreak,
    int? xpEarnedToday,
    String? selectedCategory,
    bool? isLoading,
  }) {
    return AcademyState(
      courses: courses ?? this.courses,
      dailyStreak: dailyStreak ?? this.dailyStreak,
      xpEarnedToday: xpEarnedToday ?? this.xpEarnedToday,
      selectedCategory: selectedCategory ?? this.selectedCategory,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}

final firestoreAcademyDataSourceProvider = Provider<FirestoreAcademyDatasource>((ref) {
  return FirestoreAcademyDatasource();
});

final academyRepositoryProvider = Provider<AcademyRepository>((ref) {
  final dataSource = ref.watch(firestoreAcademyDataSourceProvider);
  return AcademyRepositoryImpl(dataSource);
});

final academyProvider = StateNotifierProvider<AcademyNotifier, AcademyState>((ref) {
  final repository = ref.watch(academyRepositoryProvider);
  return AcademyNotifier(repository);
});

class AcademyNotifier extends StateNotifier<AcademyState> {
  final AcademyRepository _repository;

  AcademyNotifier(this._repository) : super(const AcademyState()) {
    loadData();
  }

  Future<void> loadData() async {
    state = state.copyWith(isLoading: true);
    try {
      final courses = await _repository.getCourses();
      final streak = await _repository.getDailyStreak();
      final xp = await _repository.getXpEarnedToday();

      state = state.copyWith(
        courses: courses,
        dailyStreak: streak,
        xpEarnedToday: xp,
        isLoading: false,
      );
    } catch (_) {
      state = state.copyWith(isLoading: false);
    }
  }

  void setCategory(String category) {
    state = state.copyWith(selectedCategory: category);
  }

  Future<void> completeModule(String courseId, double progress, int completedModules) async {
    await _repository.updateCourseProgress(courseId, progress, completedModules);
    await loadData();
  }
}
