import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:skill_arena/core/enums/user_mode.dart';
import 'package:skill_arena/core/theme/tokens/app_colors.dart';
import 'package:skill_arena/core/theme/tokens/app_gradients.dart';
import 'package:skill_arena/core/theme/tokens/app_spacing.dart';
import 'package:skill_arena/core/theme/tokens/app_typography.dart';
import 'package:skill_arena/core/widgets/aurora_background.dart';
import 'package:skill_arena/core/widgets/skill_badge.dart';
import 'package:skill_arena/core/widgets/skill_glass_card.dart';
import 'package:skill_arena/core/widgets/skill_glow_button.dart';
import 'package:skill_arena/core/widgets/skill_radar_chart.dart';
import 'package:skill_arena/features/auth/presentation/providers/auth_provider.dart';
import 'package:skill_arena/features/onboarding/domain/entities/onboarding_page.dart';
import 'package:skill_arena/features/onboarding/presentation/providers/onboarding_provider.dart';
import 'package:skill_arena/features/onboarding/presentation/widgets/onboarding_page_indicator.dart';
import 'package:skill_arena/features/onboarding/presentation/widgets/particle_canvas.dart';

/// Genesis Portal — Flagship 5-Step Cyber Onboarding Experience.
class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  late final PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _nextPage() {
    final state = ref.read(onboardingProvider);
    if (!state.isLastPage) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOutCubic,
      );
    }
  }

  void _skipToLast() {
    final state = ref.read(onboardingProvider);
    _pageController.animateToPage(
      state.pages.length - 1,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOutCubic,
    );
  }

  Future<void> _enterAsGuest() async {
    await ref.read(onboardingProvider.notifier).completeOnboarding();
    if (mounted) {
      context.go('/nexus');
    }
  }

  Future<void> _navigateToAuth() async {
    await ref.read(onboardingProvider.notifier).completeOnboarding();
    if (mounted) {
      context.go('/auth');
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(onboardingProvider);

    return Scaffold(
      backgroundColor: AppColors.deepSpaceObsidian,
      body: AuroraBackground(
        child: Stack(
          children: [
            const ParticleCanvas(particleCount: 30),
            SafeArea(
              child: Column(
                children: [
                  // Top Header Bar with Skip Button
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.lg,
                      vertical: AppSpacing.sm,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Container(
                              width: 32,
                              height: 32,
                              decoration: const BoxDecoration(
                                color: AppColors.electricBlue,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.bolt_rounded,
                                size: 20,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(width: AppSpacing.xs),
                            Text(
                              'SKILL ARENA',
                              style: AppTypography.cyberMono.copyWith(
                                fontWeight: FontWeight.bold,
                                letterSpacing: 1.5,
                              ),
                            ),
                          ],
                        ),
                        if (!state.isLastPage)
                          TextButton(
                            onPressed: _skipToLast,
                            child: Text(
                              'SKIP',
                              style: AppTypography.cyberMonoSmall.copyWith(
                                color: AppColors.textTertiary,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),

                  // Main PageView Flow
                  Expanded(
                    child: PageView.builder(
                      controller: _pageController,
                      itemCount: state.pages.length,
                      onPageChanged: (index) {
                        ref.read(onboardingProvider.notifier).setPageIndex(index);
                      },
                      itemBuilder: (context, index) {
                        final page = state.pages[index];
                        return _buildSlideContent(page);
                      },
                    ),
                  ),

                  // Bottom Control Dock
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.lg,
                      vertical: AppSpacing.md,
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        OnboardingPageIndicator(
                          count: state.pages.length,
                          currentIndex: state.currentPageIndex,
                        ),
                        const SizedBox(height: AppSpacing.md),
                        if (state.isLastPage) ...[
                          SkillGlowButton(
                            label: 'CREATE ACCOUNT',
                            size: SkillButtonSize.large,
                            width: double.infinity,
                            onPressed: _navigateToAuth,
                          ),
                          const SizedBox(height: AppSpacing.sm),
                          SkillGlowButton(
                            label: 'CONTINUE AS GUEST',
                            variant: SkillButtonVariant.secondary,
                            width: double.infinity,
                            onPressed: _enterAsGuest,
                          ),
                        ] else ...[
                          SkillGlowButton(
                            label: state.currentPageIndex == 0 ? 'ENTER ARENA' : 'NEXT STEP',
                            size: SkillButtonSize.large,
                            width: double.infinity,
                            icon: Icons.arrow_forward_rounded,
                            onPressed: _nextPage,
                          ),
                        ],
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSlideContent(OnboardingPage page) {
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Visual Feature Card Slot
            _buildInteractiveVisualCard(page.index),
            const SizedBox(height: AppSpacing.lg),

            // Tag & Header
            SkillBadge(
              label: page.tag,
              variant: SkillBadgeVariant.info,
              isSmall: true,
            ),
            const SizedBox(height: AppSpacing.xs),

            Text(
              page.title,
              style: AppTypography.displayMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSpacing.xxs),

            Text(
              page.subtitle,
              style: AppTypography.cyberMono.copyWith(color: AppColors.neonCyan),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSpacing.sm),

            Text(
              page.description,
              style: AppTypography.bodyMedium,
              textAlign: TextAlign.center,
              maxLines: 4,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInteractiveVisualCard(int slideIndex) {
    switch (slideIndex) {
      case 0:
        // Welcome Shield Card
        return SkillGlassCard(
          height: 180,
          width: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  gradient: AppGradients.auroraShimmer,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.electricBlue.withValues(alpha: 0.5),
                      blurRadius: 24,
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.shield_rounded,
                  size: 32,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: AppSpacing.sm),
              Text(
                'SKILL ARENA 2030',
                style: AppTypography.heading3,
              ),
              const SizedBox(height: AppSpacing.xxs),
              Text(
                'FLAGSHIP ECOSYSTEM',
                style: AppTypography.cyberMonoSmall,
              ),
            ],
          ),
        );
      case 1:
        // Learn Track Nodes Card
        return const SkillGlassCard(
          height: 180,
          width: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  SkillBadge(label: 'Flutter 2030', variant: SkillBadgeVariant.info),
                  SkillBadge(label: 'CyberSec', variant: SkillBadgeVariant.premium),
                  SkillBadge(label: 'AI Systems', variant: SkillBadgeVariant.success),
                ],
              ),
              SizedBox(height: AppSpacing.md),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.hub_rounded, size: 32, color: AppColors.neonCyan),
                  SizedBox(width: AppSpacing.sm),
                  Icon(Icons.play_arrow_rounded, size: 20, color: AppColors.textTertiary),
                  SizedBox(width: AppSpacing.sm),
                  Icon(Icons.verified_rounded, size: 32, color: AppColors.synthEmerald),
                ],
              ),
            ],
          ),
        );
      case 2:
        // Tournament Spotlight Card
        return SkillGlassCard(
          height: 180,
          width: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const SkillBadge(label: 'GRAND TOURNAMENT', variant: SkillBadgeVariant.live, showPulse: true),
                  const SizedBox(width: AppSpacing.xs),
                  Flexible(
                    child: Text('Prize: 10,000 \$ARENA', style: AppTypography.cyberMonoSmall, overflow: TextOverflow.ellipsis),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.sm),
              Row(
                children: [
                  const Icon(Icons.emoji_events_rounded, size: 40, color: AppColors.cyberAmber),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Cyber Battle Royale', style: AppTypography.heading3),
                        Text('128 Competitors Registered', style: AppTypography.bodySmall),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      case 3:
        // Skill Radar Visualizer Card
        return const SkillGlassCard(
          height: 180,
          width: double.infinity,
          child: Center(
            child: SkillRadarChart(
              size: 150,
              animate: false,
              data: {
                'Code': 0.9,
                'Design': 0.75,
                'Strategy': 0.8,
                'Security': 0.85,
                'Speed': 0.95,
              },
            ),
          ),
        );
      case 4:
        // Career Growth Card
        return SkillGlassCard(
          height: 180,
          width: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.workspace_premium_rounded, size: 40, color: AppColors.royalPurple),
              const SizedBox(height: AppSpacing.sm),
              Text('Recruiter Verified Profile', style: AppTypography.heading3),
              const SizedBox(height: AppSpacing.xs),
              const SkillBadge(label: 'Top 1% Global Vanguard', variant: SkillBadgeVariant.premium),
            ],
          ),
        );
      case 5:
      default:
        // What's Your Arena? Mode Selection Card
        return _buildModeSelectorCard();
    }
  }

  Widget _buildModeSelectorCard() {
    final authNotifier = ref.read(authProvider.notifier);
    final currentMode = ref.watch(authProvider).currentUser?.mode ?? UserMode.both;

    return Column(
      children: [
        _buildModeOptionTile(
          mode: UserMode.compete,
          title: '🎮 COMPETE',
          subtitle: 'Tournaments • Rankings • Teams • Gaming',
          isSelected: currentMode == UserMode.compete,
          onTap: () => authNotifier.updateUserMode(UserMode.compete),
        ),
        const SizedBox(height: AppSpacing.xs),
        _buildModeOptionTile(
          mode: UserMode.master,
          title: '🎓 MASTER',
          subtitle: 'Courses • Skills • Projects • Certifications',
          isSelected: currentMode == UserMode.master,
          onTap: () => authNotifier.updateUserMode(UserMode.master),
        ),
        const SizedBox(height: AppSpacing.xs),
        _buildModeOptionTile(
          mode: UserMode.both,
          title: '☑ EXPLORE BOTH',
          subtitle: 'Hybrid Mode • Dynamic Gaming & Mastery',
          isSelected: currentMode == UserMode.both,
          onTap: () => authNotifier.updateUserMode(UserMode.both),
        ),
      ],
    );
  }

  Widget _buildModeOptionTile({
    required UserMode mode,
    required String title,
    required String subtitle,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return SkillGlassCard(
      onTap: onTap,
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.sm),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(AppSpacing.xs),
            decoration: BoxDecoration(
              color: mode.accentColor.withValues(alpha: 0.2),
              shape: BoxShape.circle,
            ),
            child: Icon(mode.icon, color: mode.accentColor, size: 20),
          ),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: AppTypography.heading3.copyWith(fontSize: 14)),
                Text(subtitle, style: AppTypography.cyberMonoSmall, overflow: TextOverflow.ellipsis),
              ],
            ),
          ),
          Icon(
            isSelected ? Icons.check_circle_rounded : Icons.radio_button_unchecked_rounded,
            color: isSelected ? AppColors.neonCyan : Colors.white30,
            size: 20,
          ),
        ],
      ),
    );
  }
}
