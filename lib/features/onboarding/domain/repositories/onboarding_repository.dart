import 'package:skill_arena/features/onboarding/domain/entities/onboarding_page.dart';

/// Contract for onboarding data and persistence operations.
abstract class OnboardingRepository {
  /// Fetches all 5 Genesis Portal onboarding pages.
  List<OnboardingPage> getOnboardingPages();

  /// Returns true if the user has completed onboarding before.
  Future<bool> isOnboardingCompleted();

  /// Marks onboarding as completed in local storage.
  Future<void> completeOnboarding();
}
