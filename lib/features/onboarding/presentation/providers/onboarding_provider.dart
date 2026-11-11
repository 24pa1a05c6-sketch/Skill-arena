import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:skill_arena/features/onboarding/data/datasources/onboarding_local_datasource.dart';
import 'package:skill_arena/features/onboarding/data/repositories/onboarding_repository_impl.dart';
import 'package:skill_arena/features/onboarding/domain/entities/onboarding_page.dart';
import 'package:skill_arena/features/onboarding/domain/repositories/onboarding_repository.dart';
import 'package:skill_arena/features/onboarding/domain/usecases/complete_onboarding_usecase.dart';
import 'package:skill_arena/features/onboarding/domain/usecases/get_onboarding_pages_usecase.dart';

final onboardingLocalDatasourceProvider = Provider<OnboardingLocalDatasource>((ref) {
  return OnboardingLocalDatasource();
});

final onboardingRepositoryProvider = Provider<OnboardingRepository>((ref) {
  final datasource = ref.watch(onboardingLocalDatasourceProvider);
  return OnboardingRepositoryImpl(datasource);
});

final getOnboardingPagesUseCaseProvider = Provider<GetOnboardingPagesUseCase>((ref) {
  final repository = ref.watch(onboardingRepositoryProvider);
  return GetOnboardingPagesUseCase(repository);
});

final completeOnboardingUseCaseProvider = Provider<CompleteOnboardingUseCase>((ref) {
  final repository = ref.watch(onboardingRepositoryProvider);
  return CompleteOnboardingUseCase(repository);
});

class OnboardingState {
  final int currentPageIndex;
  final List<OnboardingPage> pages;
  final bool isCompleted;

  const OnboardingState({
    required this.currentPageIndex,
    required this.pages,
    required this.isCompleted,
  });

  bool get isLastPage => currentPageIndex == pages.length - 1;

  OnboardingState copyWith({
    int? currentPageIndex,
    List<OnboardingPage>? pages,
    bool? isCompleted,
  }) {
    return OnboardingState(
      currentPageIndex: currentPageIndex ?? this.currentPageIndex,
      pages: pages ?? this.pages,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }
}

class OnboardingNotifier extends StateNotifier<OnboardingState> {
  final CompleteOnboardingUseCase _completeOnboardingUseCase;

  OnboardingNotifier(
    GetOnboardingPagesUseCase getPagesUseCase,
    this._completeOnboardingUseCase,
  ) : super(
          OnboardingState(
            currentPageIndex: 0,
            pages: getPagesUseCase(),
            isCompleted: false,
          ),
        );

  void setPageIndex(int index) {
    if (index >= 0 && index < state.pages.length) {
      state = state.copyWith(currentPageIndex: index);
    }
  }

  Future<void> completeOnboarding() async {
    await _completeOnboardingUseCase();
    state = state.copyWith(isCompleted: true);
  }
}

final onboardingProvider =
    StateNotifierProvider<OnboardingNotifier, OnboardingState>((ref) {
  final getPages = ref.watch(getOnboardingPagesUseCaseProvider);
  final complete = ref.watch(completeOnboardingUseCaseProvider);
  return OnboardingNotifier(getPages, complete);
});
