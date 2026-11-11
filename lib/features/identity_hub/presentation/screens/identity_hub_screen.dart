import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:skill_arena/core/enums/user_mode.dart';
import 'package:skill_arena/core/theme/tokens/app_colors.dart';
import 'package:skill_arena/core/theme/tokens/app_spacing.dart';
import 'package:skill_arena/core/theme/tokens/app_typography.dart';
import 'package:skill_arena/core/widgets/aurora_background.dart';
import 'package:skill_arena/core/widgets/skill_avatar.dart';
import 'package:skill_arena/core/widgets/skill_badge.dart';
import 'package:skill_arena/core/widgets/skill_glass_card.dart';
import 'package:skill_arena/core/widgets/skill_glow_button.dart';
import 'package:skill_arena/core/widgets/skill_radar_chart.dart';
import 'package:skill_arena/features/auth/presentation/providers/auth_provider.dart';
import 'package:skill_arena/features/identity_hub/domain/entities/user_profile.dart';
import 'package:skill_arena/features/identity_hub/presentation/providers/identity_provider.dart';
import 'package:skill_arena/features/identity_hub/presentation/widgets/identity_settings_sheet.dart';
import 'package:skill_arena/features/identity_hub/presentation/widgets/public_developer_portfolio_sheet.dart';

/// Identity Hub Flagship Profile Screen.
class IdentityHubScreen extends ConsumerWidget {
  const IdentityHubScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profile = ref.watch(identityProvider);
    final notifier = ref.read(identityProvider.notifier);

    return Scaffold(
      backgroundColor: AppColors.deepSpaceObsidian,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text('IDENTITY HUB', style: AppTypography.heading3),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.language_rounded, color: AppColors.neonCyan),
            tooltip: 'Public Developer Portfolio',
            onPressed: () {
              showModalBottomSheet(
                context: context,
                backgroundColor: Colors.transparent,
                isScrollControlled: true,
                builder: (_) => const PublicDeveloperPortfolioSheet(),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.settings_rounded, color: AppColors.textPrimary),
            onPressed: () {
              showModalBottomSheet(
                context: context,
                backgroundColor: Colors.transparent,
                isScrollControlled: true,
                builder: (_) => const IdentitySettingsSheet(),
              );
            },
          ),
        ],
      ),
      body: AuroraBackground(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              InkWell(
                onTap: () {
                  showModalBottomSheet(
                    context: context,
                    backgroundColor: Colors.transparent,
                    isScrollControlled: true,
                    builder: (_) => const PublicDeveloperPortfolioSheet(),
                  );
                },
                child: _buildProfileHeader(profile, ref),
              ),
              const SizedBox(height: AppSpacing.md),
              _buildProfileQuickActions(context, ref),
              const SizedBox(height: AppSpacing.lg),
              _buildRecruiterToggle(profile, notifier),
              const SizedBox(height: AppSpacing.lg),
              _buildSkillRadar(profile),
              const SizedBox(height: AppSpacing.lg),
              if (!profile.isRecruiterView) ...[
                _buildBadgesGallery(profile),
                const SizedBox(height: AppSpacing.lg),
              ],
              _buildStatsCard(profile),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProfileHeader(UserProfile profile, WidgetRef ref) {
    final currentMode = ref.watch(authProvider).currentUser?.mode ?? UserMode.both;

    return Column(
      children: [
        SkillAvatar(
          initials: 'CV',
          size: 72,
          showStatusRing: true,
          status: SkillAvatarStatus.online,
          level: profile.level,
        ),
        const SizedBox(height: AppSpacing.md),
        Text(profile.name, style: AppTypography.heading2),
        const SizedBox(height: AppSpacing.xxs),
        Text(profile.handle, style: AppTypography.cyberMonoSmall),
        const SizedBox(height: AppSpacing.xs),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SkillBadge(
              label: profile.rankTitle,
              variant: SkillBadgeVariant.premium,
            ),
            const SizedBox(width: AppSpacing.xs),
            SkillBadge(
              label: currentMode.displayName,
              variant: SkillBadgeVariant.live,
              isSmall: true,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildProfileQuickActions(BuildContext context, WidgetRef ref) {
    return SkillGlassCard(
      padding: const EdgeInsets.all(AppSpacing.sm),
      child: Wrap(
        alignment: WrapAlignment.spaceEvenly,
        spacing: AppSpacing.xs,
        runSpacing: AppSpacing.xs,
        children: [
          SkillGlowButton(
            label: 'VIEW PORTFOLIO',
            size: SkillButtonSize.small,
            icon: Icons.person_rounded,
            onPressed: () {
              showModalBottomSheet(
                context: context,
                backgroundColor: Colors.transparent,
                isScrollControlled: true,
                builder: (_) => const PublicDeveloperPortfolioSheet(),
              );
            },
          ),
          SkillGlowButton(
            label: 'EDIT PROFILE',
            size: SkillButtonSize.small,
            variant: SkillButtonVariant.secondary,
            icon: Icons.edit_rounded,
            onPressed: () {
              showModalBottomSheet(
                context: context,
                backgroundColor: Colors.transparent,
                isScrollControlled: true,
                builder: (_) => const IdentitySettingsSheet(),
              );
            },
          ),
          SkillGlowButton(
            label: 'SHARE PROFILE',
            size: SkillButtonSize.small,
            variant: SkillButtonVariant.secondary,
            icon: Icons.share_rounded,
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Copied shareable profile link: skillarena.app/@vanguard_2030 🚀')),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildRecruiterToggle(UserProfile profile, IdentityNotifier notifier) {
    return SkillGlassCard(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Recruiter View Mode', style: AppTypography.labelLarge),
              Text(
                profile.isRecruiterView ? 'Verified Portfolio Highlighted' : 'Standard Arena View',
                style: AppTypography.bodySmall,
              ),
            ],
          ),
          Switch(
            value: profile.isRecruiterView,
            onChanged: (val) => notifier.toggleRecruiterView(val),
            activeThumbColor: AppColors.electricBlue,
          ),
        ],
      ),
    );
  }

  Widget _buildSkillRadar(UserProfile profile) {
    return SkillGlassCard(
      child: Column(
        children: [
          Text('VERIFIABLE SKILL MATRIX', style: AppTypography.labelLarge),
          const SizedBox(height: AppSpacing.md),
          Center(
            child: SkillRadarChart(
              size: 220,
              data: profile.skillStats,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBadgesGallery(UserProfile profile) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('BADGES & TROPHIES', style: AppTypography.labelLarge),
        const SizedBox(height: AppSpacing.sm),
        Wrap(
          spacing: AppSpacing.sm,
          runSpacing: AppSpacing.sm,
          children: profile.badges.map((badge) {
            return SkillBadge(
              label: badge,
              variant: SkillBadgeVariant.info,
              icon: Icons.military_tech_rounded,
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildStatsCard(UserProfile profile) {
    return SkillGlassCard(
      child: Column(
        children: [
          _buildStatRow('Verified Certificates', '${profile.certificatesCount}', Icons.verified_rounded),
          const Divider(color: Colors.white10),
          _buildStatRow('Win Rate', '${profile.winRate}%', Icons.emoji_events_rounded),
          const Divider(color: Colors.white10),
          _buildStatRow('\$ARENA Earned', '${profile.arenaEarned}', Icons.toll_rounded),
        ],
      ),
    );
  }

  Widget _buildStatRow(String label, String value, IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.xs),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(icon, color: AppColors.electricBlue, size: 20),
              const SizedBox(width: AppSpacing.sm),
              Text(label, style: AppTypography.bodyMedium),
            ],
          ),
          Text(value, style: AppTypography.cyberMono),
        ],
      ),
    );
  }
}
