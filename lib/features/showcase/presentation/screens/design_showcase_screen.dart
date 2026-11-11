import 'package:flutter/material.dart';
import 'package:skill_arena/core/theme/tokens/app_colors.dart';
import 'package:skill_arena/core/theme/tokens/app_spacing.dart';
import 'package:skill_arena/core/theme/tokens/app_typography.dart';
import 'package:skill_arena/core/widgets/aurora_background.dart';
import 'package:skill_arena/core/widgets/skill_avatar.dart';
import 'package:skill_arena/core/widgets/skill_badge.dart';
import 'package:skill_arena/core/widgets/skill_empty_state.dart';
import 'package:skill_arena/core/widgets/skill_glass_card.dart';
import 'package:skill_arena/core/widgets/skill_glow_button.dart';
import 'package:skill_arena/core/widgets/skill_input_field.dart';
import 'package:skill_arena/core/widgets/skill_radar_chart.dart';
import 'package:skill_arena/core/widgets/skill_skeleton_loader.dart';
import 'package:skill_arena/core/widgets/skill_snackbar.dart';

/// Interactive catalog showcasing every Design System component.
class DesignShowcaseScreen extends StatefulWidget {
  const DesignShowcaseScreen({super.key});

  @override
  State<DesignShowcaseScreen> createState() => _DesignShowcaseScreenState();
}

class _DesignShowcaseScreenState extends State<DesignShowcaseScreen> {
  bool _buttonLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.deepSpaceObsidian,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text('Design System', style: AppTypography.heading3),
      ),
      body: AuroraBackground(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.lg,
            vertical: AppSpacing.md,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSection('Colors', _buildColorsSection()),
              _buildSection('Typography', _buildTypographySection()),
              _buildSection('Buttons', _buildButtonsSection()),
              _buildSection('Glass Cards', _buildGlassCardsSection()),
              _buildSection('Input Fields', _buildInputFieldsSection()),
              _buildSection('Badges', _buildBadgesSection()),
              _buildSection('Avatars', _buildAvatarsSection()),
              _buildSection('Skill Radar', _buildRadarSection()),
              _buildSection('Loading States', _buildLoadingSection()),
              _buildSection('Empty States', _buildEmptyStateSection()),
              const SizedBox(height: AppSpacing.huge),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSection(String title, Widget content) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.xxl),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: AppTypography.heading2),
          const SizedBox(height: AppSpacing.md),
          content,
        ],
      ),
    );
  }

  Widget _buildColorsSection() {
    final colors = <String, Color>{
      'Deep Space': AppColors.deepSpaceObsidian,
      'Cyber Black': AppColors.cyberBlack,
      'Electric Blue': AppColors.electricBlue,
      'Neon Cyan': AppColors.neonCyan,
      'Royal Purple': AppColors.royalPurple,
      'Emerald': AppColors.synthEmerald,
      'Amber': AppColors.cyberAmber,
      'Coral': AppColors.coralBurst,
    };

    return Wrap(
      spacing: AppSpacing.sm,
      runSpacing: AppSpacing.sm,
      children: colors.entries.map((e) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: e.value,
                shape: BoxShape.circle,
                border: Border.all(
                  color: const Color.fromRGBO(255, 255, 255, 0.1),
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.xxs),
            Text(
              e.key,
              style: AppTypography.cyberMonoSmall,
            ),
          ],
        );
      }).toList(),
    );
  }

  Widget _buildTypographySection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Display Heavy', style: AppTypography.displayHeavy),
        const SizedBox(height: AppSpacing.sm),
        Text('Display Medium', style: AppTypography.displayMedium),
        const SizedBox(height: AppSpacing.sm),
        Text('Heading 1', style: AppTypography.heading1),
        const SizedBox(height: AppSpacing.sm),
        Text('Heading 2', style: AppTypography.heading2),
        const SizedBox(height: AppSpacing.sm),
        Text('Heading 3', style: AppTypography.heading3),
        const SizedBox(height: AppSpacing.sm),
        Text('Body Large', style: AppTypography.bodyLarge),
        const SizedBox(height: AppSpacing.sm),
        Text('Body Medium', style: AppTypography.bodyMedium),
        const SizedBox(height: AppSpacing.sm),
        Text('Body Small', style: AppTypography.bodySmall),
        const SizedBox(height: AppSpacing.sm),
        Text('Label Large', style: AppTypography.labelLarge),
        const SizedBox(height: AppSpacing.sm),
        Text('Label Medium', style: AppTypography.labelMedium),
        const SizedBox(height: AppSpacing.sm),
        Text('Cyber Mono', style: AppTypography.cyberMono),
        const SizedBox(height: AppSpacing.sm),
        Text('Cyber Mono Small', style: AppTypography.cyberMonoSmall),
      ],
    );
  }

  Widget _buildButtonsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Sizes', style: AppTypography.labelLarge),
        const SizedBox(height: AppSpacing.sm),
        Wrap(
          spacing: AppSpacing.sm,
          runSpacing: AppSpacing.sm,
          children: [
            SkillGlowButton(
              label: 'Small',
              size: SkillButtonSize.small,
              onPressed: () {},
            ),
            SkillGlowButton(
              label: 'Medium',
              onPressed: () {},
            ),
            SkillGlowButton(
              label: 'Large',
              size: SkillButtonSize.large,
              onPressed: () {},
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.lg),
        Text('Variants', style: AppTypography.labelLarge),
        const SizedBox(height: AppSpacing.sm),
        Wrap(
          spacing: AppSpacing.sm,
          runSpacing: AppSpacing.sm,
          children: [
            SkillGlowButton(
              label: 'Primary',
              onPressed: () {},
            ),
            SkillGlowButton(
              label: 'Secondary',
              variant: SkillButtonVariant.secondary,
              onPressed: () {},
            ),
            SkillGlowButton(
              label: 'Ghost',
              variant: SkillButtonVariant.ghost,
              onPressed: () {},
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.lg),
        Text('States', style: AppTypography.labelLarge),
        const SizedBox(height: AppSpacing.sm),
        Wrap(
          spacing: AppSpacing.sm,
          runSpacing: AppSpacing.sm,
          children: [
            const SkillGlowButton(
              label: 'Disabled',
              onPressed: null,
            ),
            SkillGlowButton(
              label: _buttonLoading ? 'Loading...' : 'Tap to Load',
              isLoading: _buttonLoading,
              onPressed: () {
                setState(() => _buttonLoading = !_buttonLoading);
              },
            ),
            SkillGlowButton(
              label: 'Ghost Variant',
              variant: SkillButtonVariant.ghost,
              onPressed: () {},
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildGlassCardsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SkillGlassCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Default Glass Card', style: AppTypography.heading3),
              const SizedBox(height: AppSpacing.xs),
              Text(
                'Uses default glass opacity, border gradient, and cyber styling.',
                style: AppTypography.bodySmall,
              ),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        SkillGlassCard(
          onTap: () {},
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Interactive Glass Card (Tap Me)', style: AppTypography.labelLarge),
              const Icon(Icons.chevron_right_rounded, color: AppColors.neonCyan),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        SkillGlassCard(
          isError: true,
          child: Text('Error Card', style: AppTypography.bodyLarge),
        ),
      ],
    );
  }

  Widget _buildInputFieldsSection() {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SkillInputField(
          label: 'Username',
          hint: 'Enter your arena name',
        ),
        SizedBox(height: AppSpacing.md),
        SkillInputField(
          label: 'Password',
          hint: 'Enter your password',
          obscureText: true,
        ),
        SizedBox(height: AppSpacing.md),
        SkillInputField(
          label: 'Error State',
          hint: 'Invalid input',
          errorText: 'This field is required',
        ),
        SizedBox(height: AppSpacing.md),
        SkillInputField(
          label: 'Success State',
          hint: 'Valid input',
          successText: 'Looks good!',
        ),
        SizedBox(height: AppSpacing.md),
        SkillInputField(
          label: 'Disabled',
          hint: 'Cannot edit',
          enabled: false,
        ),
      ],
    );
  }

  Widget _buildBadgesSection() {
    return const Wrap(
      spacing: AppSpacing.sm,
      runSpacing: AppSpacing.sm,
      children: [
        SkillBadge(label: 'Info', variant: SkillBadgeVariant.info),
        SkillBadge(label: 'Success', variant: SkillBadgeVariant.success),
        SkillBadge(label: 'Warning', variant: SkillBadgeVariant.warning),
        SkillBadge(label: 'Error', variant: SkillBadgeVariant.error),
        SkillBadge(label: 'Premium', variant: SkillBadgeVariant.premium),
        SkillBadge(
          label: 'LIVE',
          variant: SkillBadgeVariant.live,
          showPulse: true,
        ),
      ],
    );
  }

  Widget _buildAvatarsSection() {
    return const Wrap(
      spacing: AppSpacing.md,
      runSpacing: AppSpacing.md,
      children: [
        SkillAvatar(
          initials: 'SA',
          showStatusRing: true,
          status: SkillAvatarStatus.online,
        ),
        SkillAvatar(
          initials: 'BG',
          showStatusRing: true,
          status: SkillAvatarStatus.away,
          level: 12,
        ),
        SkillAvatar(
          initials: 'AC',
          showStatusRing: true,
          status: SkillAvatarStatus.busy,
          level: 42,
        ),
        SkillAvatar(
          initials: 'IH',
          showStatusRing: true,
        ),
      ],
    );
  }

  Widget _buildRadarSection() {
    return const Center(
      child: SkillRadarChart(
        data: {
          'Code': 0.85,
          'Design': 0.7,
          'Strategy': 0.6,
          'Security': 0.9,
          'Speed': 0.75,
        },
        size: 240,
      ),
    );
  }

  Widget _buildLoadingSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SkillSkeletonLoader(),
        const SizedBox(height: AppSpacing.sm),
        const SkillSkeletonLoader(width: 200),
        const SizedBox(height: AppSpacing.sm),
        const SkillSkeletonLoader(height: 48, isCircle: true),
        const SizedBox(height: AppSpacing.lg),
        Text('Skeleton Card', style: AppTypography.labelLarge),
        const SizedBox(height: AppSpacing.sm),
        const SkillSkeletonCard(),
      ],
    );
  }

  Widget _buildEmptyStateSection() {
    return SkillEmptyState(
      title: 'No Tournaments Found',
      message: 'There are no active tournaments right now. Check back later or create your own.',
      icon: Icons.emoji_events_rounded,
      actionLabel: 'Create Tournament',
      onAction: () {
        SkillSnackbar.showSuccess(context, 'Tournament created!');
      },
    );
  }
}
