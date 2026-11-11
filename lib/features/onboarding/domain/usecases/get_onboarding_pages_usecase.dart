import 'package:skill_arena/features/onboarding/domain/entities/onboarding_page.dart';
import 'package:skill_arena/features/onboarding/domain/repositories/onboarding_repository.dart';

/// UseCase to retrieve the list of Genesis Portal onboarding slides.
class GetOnboardingPagesUseCase {
  final OnboardingRepository _repository;

  GetOnboardingPagesUseCase(this._repository);

  List<OnboardingPage> call() => _repository.getOnboardingPages();
}
