import 'package:skill_arena/features/onboarding/domain/repositories/onboarding_repository.dart';

/// UseCase to mark onboarding as completed.
class CompleteOnboardingUseCase {
  final OnboardingRepository _repository;

  CompleteOnboardingUseCase(this._repository);

  Future<void> call() => _repository.completeOnboarding();
}
