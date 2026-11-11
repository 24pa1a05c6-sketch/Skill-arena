import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:skill_arena/core/enums/user_mode.dart';
import 'package:skill_arena/core/theme/tokens/app_colors.dart';
import 'package:skill_arena/core/theme/tokens/app_spacing.dart';
import 'package:skill_arena/core/theme/tokens/app_typography.dart';
import 'package:skill_arena/core/widgets/aurora_background.dart';
import 'package:skill_arena/core/widgets/skill_avatar.dart';
import 'package:skill_arena/core/widgets/skill_badge.dart';
import 'package:skill_arena/core/widgets/skill_glass_card.dart';
import 'package:skill_arena/core/widgets/skill_glow_button.dart';
import 'package:skill_arena/core/widgets/skill_skeleton_loader.dart';
import 'package:skill_arena/features/ai_engine/presentation/widgets/ai_mentor_chat_sheet.dart';
import 'package:skill_arena/features/auth/presentation/providers/auth_provider.dart';
import 'package:skill_arena/features/nexus/presentation/providers/nexus_provider.dart';
import 'package:skill_arena/features/social/presentation/widgets/guild_hall_sheet.dart';

/// Flagship Nexus Home Dashboard with Live Coding Arena, Talent Portal, Vault, Guild Hall & AI Mentor.
class NexusScreen extends ConsumerWidget {
  const NexusScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dashboardAsyncValue = ref.watch(nexusDashboardProvider);

    return Scaffold(
      backgroundColor: AppColors.deepSpaceObsidian,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text('NEXUS DASHBOARD', style: AppTypography.heading3),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.code_rounded, color: AppColors.neonCyan),
            tooltip: 'Live Coding Arena',
            onPressed: () => context.push('/coding-arena'),
          ),
          IconButton(
            icon: const Icon(Icons.work_rounded, color: AppColors.synthEmerald),
            tooltip: 'Talent & Jobs Portal',
            onPressed: () => context.push('/recruiter'),
          ),
          IconButton(
            icon: const Icon(Icons.storefront_rounded, color: AppColors.cyberAmber),
            tooltip: 'The Vault Marketplace',
            onPressed: () => context.push('/vault'),
          ),
          IconButton(
            icon: const Icon(Icons.shield_rounded, color: AppColors.royalPurple),
            tooltip: 'Guild Hall',
            onPressed: () {
              showModalBottomSheet(
                context: context,
                backgroundColor: Colors.transparent,
                isScrollControlled: true,
                builder: (_) => const GuildHallSheet(),
              );
            },
          ),
        ],
      ),
      body: AuroraBackground(
        child: dashboardAsyncValue.when(
          data: (data) => ListView(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.lg,
              vertical: AppSpacing.md,
            ),
            children: [
              // Cyber Header Section
              SkillGlassCard(
                padding: const EdgeInsets.all(AppSpacing.md),
                child: Row(
                  children: [
                    const SkillAvatar(
                      initials: 'CV',
                      size: 56,
                      showStatusRing: true,
                      status: SkillAvatarStatus.online,
                      level: 12,
                    ),
                    const SizedBox(width: AppSpacing.md),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Text(
                                  'Welcome back, ${data.userSummary.name}',
                                  style: AppTypography.heading3,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              SkillBadge(
                                label: (ref.watch(authProvider).currentUser?.mode ?? UserMode.both).displayName,
                                variant: SkillBadgeVariant.live,
                                isSmall: true,
                              ),
                            ],
                          ),
                          const SizedBox(height: AppSpacing.xs),
                          Row(
                            children: [
                              const SkillBadge(
                                label: 'Level 12',
                                variant: SkillBadgeVariant.premium,
                                isSmall: true,
                              ),
                              const SizedBox(width: AppSpacing.xs),
                              Expanded(
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(4),
                                  child: LinearProgressIndicator(
                                    value: data.userSummary.xp / data.userSummary.targetXp,
                                    backgroundColor: Colors.white10,
                                    color: AppColors.neonCyan,
                                    minHeight: 6,
                                  ),
                                ),
                              ),
                              const SizedBox(width: AppSpacing.xs),
                              Text(
                                '${data.userSummary.xp}/${data.userSummary.targetXp} XP',
                                style: AppTypography.cyberMonoSmall,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.sm),

              // Token Balance Badge (Navigates to Vault Marketplace)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () => context.push('/vault'),
                    child: SkillBadge(
                      label: '${data.userSummary.tokens} \$ARENA (VAULT 💎)',
                      variant: SkillBadgeVariant.warning,
                      icon: Icons.emoji_events_rounded,
                    ),
                  ),
                  TextButton.icon(
                    icon: Icon(
                      (ref.watch(authProvider).currentUser?.mode ?? UserMode.both).icon,
                      size: 16,
                      color: AppColors.neonCyan,
                    ),
                    label: Text(
                      'MODE: ${(ref.watch(authProvider).currentUser?.mode ?? UserMode.both).name.toUpperCase()}',
                      style: AppTypography.cyberMonoSmall.copyWith(color: AppColors.neonCyan),
                    ),
                    onPressed: () {
                      context.go('/identity');
                    },
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.lg),

              // Live Tournament Spotlight
              Text('SPOTLIGHT TOURNAMENT', style: AppTypography.labelLarge),
              const SizedBox(height: AppSpacing.xs),
              SkillGlassCard(
                padding: const EdgeInsets.all(AppSpacing.lg),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SkillBadge(
                          label: 'LIVE NOW',
                          variant: SkillBadgeVariant.live,
                          showPulse: true,
                        ),
                        SkillBadge(
                          label: 'Grand Finals',
                          variant: SkillBadgeVariant.info,
                          isSmall: true,
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    Text(data.spotlight.title, style: AppTypography.heading2),
                    const SizedBox(height: AppSpacing.md),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Prize Pool', style: AppTypography.bodySmall),
                            Text(
                              '${data.spotlight.prizePool} \$ARENA',
                              style: AppTypography.cyberMono.copyWith(color: AppColors.cyberAmber),
                            ),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text('Remaining', style: AppTypography.bodySmall),
                            Text(
                              data.spotlight.timeRemaining,
                              style: AppTypography.cyberMono,
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    SkillGlowButton(
                      label: 'JOIN BATTLE',
                      size: SkillButtonSize.large,
                      width: double.infinity,
                      onPressed: () {
                        context.go('/battle-grid');
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.lg),

              // Quick Actions Grid (Rich Dashboard Hub Cards)
              Text('QUICK ACTIONS', style: AppTypography.labelLarge),
              const SizedBox(height: AppSpacing.xs),
              GridView.count(
                crossAxisCount: MediaQuery.of(context).size.width > 800 ? 4 : 2,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisSpacing: AppSpacing.md,
                mainAxisSpacing: AppSpacing.md,
                childAspectRatio: MediaQuery.of(context).size.width > 800 ? 1.15 : 0.82,
                children: [
                  _buildQuickActionCard(
                    context: context,
                    title: 'Live Coding',
                    subtitle: 'Real-time proctored IDE & algorithmic drills.',
                    icon: Icons.code_rounded,
                    accentColor: AppColors.neonCyan,
                    badgeLabel: 'PROCTORED',
                    badgeVariant: SkillBadgeVariant.info,
                    ctaLabel: 'LAUNCH IDE 🚀',
                    onTap: () => context.push('/coding-arena'),
                  ),
                  _buildQuickActionCard(
                    context: context,
                    title: 'Battle Grid',
                    subtitle: 'Live tournament brackets & 1v1 arenas.',
                    icon: Icons.sports_esports_rounded,
                    accentColor: AppColors.cyberAmber,
                    badgeLabel: 'LIVE NOW ⚡',
                    badgeVariant: SkillBadgeVariant.live,
                    ctaLabel: 'ENTER ARENA ⚔️',
                    onTap: () => context.go('/battle-grid'),
                  ),
                  _buildQuickActionCard(
                    context: context,
                    title: 'Talent Jobs',
                    subtitle: 'Verified recruiter listings & ELO matching.',
                    icon: Icons.work_rounded,
                    accentColor: AppColors.synthEmerald,
                    badgeLabel: '94% MATCH',
                    badgeVariant: SkillBadgeVariant.success,
                    ctaLabel: 'APPLY NOW 💼',
                    onTap: () => context.push('/recruiter'),
                  ),
                  _buildQuickActionCard(
                    context: context,
                    title: 'AI Mentor',
                    subtitle: '24/7 Neural Assistant for code reviews.',
                    icon: Icons.smart_toy_rounded,
                    accentColor: AppColors.royalPurple,
                    badgeLabel: 'AURA 2.0',
                    badgeVariant: SkillBadgeVariant.premium,
                    ctaLabel: 'CHAT NOW 🤖',
                    onTap: () {
                      showModalBottomSheet(
                        context: context,
                        backgroundColor: Colors.transparent,
                        isScrollControlled: true,
                        builder: (_) => const AiMentorChatSheet(),
                      );
                    },
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.lg),

              // Continue Learning Section
              Text('CONTINUE LEARNING', style: AppTypography.labelLarge),
              const SizedBox(height: AppSpacing.xs),
              SkillGlassCard(
                onTap: () => context.go('/academy'),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Flutter 2030 Architecture', style: AppTypography.heading3),
                          const SizedBox(height: AppSpacing.xs),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(4),
                            child: const LinearProgressIndicator(
                              value: 0.68,
                              color: AppColors.electricBlue,
                              backgroundColor: Colors.white10,
                              minHeight: 6,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: AppSpacing.md),
                    SkillGlowButton(
                      label: 'RESUME',
                      size: SkillButtonSize.small,
                      onPressed: () => context.go('/academy'),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.lg),

              // Live Activity Feed Section
              Text('LIVE ARENA ACTIVITY', style: AppTypography.labelLarge),
              const SizedBox(height: AppSpacing.xs),
              ...data.activityFeed.map((activity) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: AppSpacing.xs),
                  child: SkillGlassCard(
                    padding: const EdgeInsets.all(AppSpacing.sm),
                    child: Row(
                      children: [
                        const SkillAvatar(initials: 'AV', size: 32),
                        const SizedBox(width: AppSpacing.sm),
                        Expanded(
                          child: RichText(
                            text: TextSpan(
                              style: AppTypography.bodySmall,
                              children: [
                                TextSpan(
                                  text: '${activity.user} ',
                                  style: AppTypography.labelLarge.copyWith(color: AppColors.neonCyan),
                                ),
                                TextSpan(text: activity.action),
                              ],
                            ),
                          ),
                        ),
                        Text(activity.timeAgo, style: AppTypography.cyberMonoSmall),
                      ],
                    ),
                  ),
                );
              }),
            ],
          ),
          loading: () => ListView(
            padding: const EdgeInsets.all(AppSpacing.lg),
            children: const [
              SkillSkeletonCard(showAvatar: true, lines: 2),
              SizedBox(height: AppSpacing.md),
              SkillSkeletonCard(),
              SizedBox(height: AppSpacing.md),
              SkillSkeletonCard(lines: 2),
            ],
          ),
          error: (err, stack) => Center(child: Text('Error: $err', style: const TextStyle(color: AppColors.coralBurst))),
        ),
      ),
    );
  }

  Widget _buildQuickActionCard({
    required BuildContext context,
    required String title,
    required String subtitle,
    required IconData icon,
    required Color accentColor,
    required String badgeLabel,
    required SkillBadgeVariant badgeVariant,
    required String ctaLabel,
    required VoidCallback onTap,
  }) {
    return SkillGlassCard(
      onTap: onTap,
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.all(AppSpacing.xs),
                decoration: BoxDecoration(
                  color: accentColor.withValues(alpha: 0.15),
                  shape: BoxShape.circle,
                  border: Border.all(color: accentColor.withValues(alpha: 0.4)),
                ),
                child: Icon(icon, color: accentColor, size: 20),
              ),
              SkillBadge(
                label: badgeLabel,
                variant: badgeVariant,
                isSmall: true,
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(title, style: AppTypography.heading3, overflow: TextOverflow.ellipsis),
          const SizedBox(height: AppSpacing.xxs),
          Expanded(
            child: Text(
              subtitle,
              style: AppTypography.bodySmall.copyWith(color: AppColors.textSecondary),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const SizedBox(height: AppSpacing.xs),
          SkillGlowButton(
            label: ctaLabel,
            size: SkillButtonSize.small,
            width: double.infinity,
            onPressed: onTap,
          ),
        ],
      ),
    );
  }
}
