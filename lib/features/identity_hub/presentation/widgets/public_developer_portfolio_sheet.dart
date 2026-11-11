import 'package:flutter/material.dart';
import 'package:skill_arena/core/theme/tokens/app_colors.dart';
import 'package:skill_arena/core/theme/tokens/app_spacing.dart';
import 'package:skill_arena/core/theme/tokens/app_typography.dart';
import 'package:skill_arena/core/widgets/skill_avatar.dart';
import 'package:skill_arena/core/widgets/skill_badge.dart';
import 'package:skill_arena/core/widgets/skill_glass_card.dart';
import 'package:skill_arena/core/widgets/skill_glow_button.dart';
import 'package:skill_arena/core/widgets/skill_radar_chart.dart';

/// Public Developer Portfolio Modal Sheet combining LinkedIn, GitHub, LeetCode, Chess.com, Steam, & Discord metrics.
class PublicDeveloperPortfolioSheet extends StatefulWidget {
  const PublicDeveloperPortfolioSheet({super.key});

  @override
  State<PublicDeveloperPortfolioSheet> createState() => _PublicDeveloperPortfolioSheetState();
}

class _PublicDeveloperPortfolioSheetState extends State<PublicDeveloperPortfolioSheet> {
  bool _isRecruiterView = false;
  bool _isFollowing = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.9,
      decoration: const BoxDecoration(
        color: AppColors.cyberBlack,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: const EdgeInsets.all(AppSpacing.md),
      child: SafeArea(
        child: Column(
          children: [
            // Top Action Bar
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const SkillBadge(label: 'PUBLIC PORTFOLIO 🌐', variant: SkillBadgeVariant.info),
                    const SizedBox(width: AppSpacing.xs),
                    Switch(
                      value: _isRecruiterView,
                      onChanged: (val) {
                        setState(() {
                          _isRecruiterView = val;
                        });
                      },
                      activeThumbColor: AppColors.neonCyan,
                    ),
                    Text(_isRecruiterView ? 'Recruiter Mode' : 'Developer Mode', style: AppTypography.cyberMonoSmall),
                  ],
                ),
                IconButton(
                  icon: const Icon(Icons.close, color: Colors.white70),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.sm),

            Expanded(
              child: ListView(
                children: [
                  // Hero Profile Card
                  SkillGlassCard(
                    child: Column(
                      children: [
                        Row(
                          children: [
                            const SkillAvatar(
                              initials: 'JV',
                              size: 64,
                              showStatusRing: true,
                              status: SkillAvatarStatus.online,
                            ),
                            const SizedBox(width: AppSpacing.md),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Text('JASHWANTH V.', style: AppTypography.heading2),
                                      const SizedBox(width: AppSpacing.xs),
                                      const Icon(Icons.verified_rounded, color: AppColors.neonCyan, size: 20),
                                    ],
                                  ),
                                  Text('@jashwanth_vanguard • Level 18 Grandmaster', style: AppTypography.cyberMonoSmall),
                                  const SizedBox(height: AppSpacing.xs),
                                  const Row(
                                    children: [
                                      SkillBadge(label: 'ELO 2450 🔥', variant: SkillBadgeVariant.live, isSmall: true),
                                      SizedBox(width: AppSpacing.xs),
                                      SkillBadge(label: 'TOP 1% GLOBAL', variant: SkillBadgeVariant.premium, isSmall: true),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: AppSpacing.md),
                        Text(
                          'Full-Stack AI Systems Engineer & Competitive Programmer. Building high-throughput Flutter applications with Riverpod, Clean Architecture, and AI proctoring engines.',
                          style: AppTypography.bodyMedium,
                        ),
                        const SizedBox(height: AppSpacing.md),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            _buildStatColumn('Followers', '1.4k'),
                            _buildStatColumn('Following', '380'),
                            _buildStatColumn('Matches', '142'),
                            _buildStatColumn('Win Rate', '88%'),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: AppSpacing.md),

                  // Integrated Social Ecosystem Badges (GitHub, LeetCode, Chess, Discord, Steam)
                  Text('CONNECTED ECOSYSTEMS 🔗', style: AppTypography.labelLarge),
                  const SizedBox(height: AppSpacing.xs),
                  const Wrap(
                    spacing: AppSpacing.xs,
                    runSpacing: AppSpacing.xs,
                    children: [
                      SkillBadge(label: 'GitHub: @jashwanth ⭐️ 342', variant: SkillBadgeVariant.info),
                      SkillBadge(label: 'LeetCode: 480 Solved (Top 2%)', variant: SkillBadgeVariant.warning),
                      SkillBadge(label: 'Chess.com: 1850 Blitz', variant: SkillBadgeVariant.success),
                      SkillBadge(label: 'Discord: Vanguard#0001', variant: SkillBadgeVariant.premium),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.md),

                  // Skill Radar Matrix
                  SkillGlassCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('VERIFIABLE SKILL RADAR MATRIX 📊', style: AppTypography.labelLarge),
                        const SizedBox(height: AppSpacing.sm),
                        const SizedBox(
                          height: 220,
                          child: SkillRadarChart(
                            data: {
                              'Flutter/Dart': 0.95,
                              'Algorithms': 0.90,
                              'Architecture': 0.88,
                              'AI Proctoring': 0.85,
                              'Web3/Crypto': 0.92,
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: AppSpacing.md),

                  // Featured Projects
                  Text('FEATURED ARCHITECTURE PROJECTS 🚀', style: AppTypography.labelLarge),
                  const SizedBox(height: AppSpacing.xs),
                  SkillGlassCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Skill Arena - Enterprise Platform', style: AppTypography.heading3),
                        const SizedBox(height: AppSpacing.xs),
                        Text('Cross-platform Flutter application with Judge0 code execution, AURA AI mentor, and ELO tournaments.', style: AppTypography.bodySmall),
                        const SizedBox(height: AppSpacing.sm),
                        const Wrap(
                          spacing: AppSpacing.xs,
                          children: [
                            SkillBadge(label: 'Flutter', variant: SkillBadgeVariant.info, isSmall: true),
                            SkillBadge(label: 'Riverpod', variant: SkillBadgeVariant.info, isSmall: true),
                            SkillBadge(label: 'Clean Architecture', variant: SkillBadgeVariant.info, isSmall: true),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: AppSpacing.md),

                  // Verified Resume & Certificate Download UI
                  SkillGlassCard(
                    child: Row(
                      children: [
                        const Icon(Icons.picture_as_pdf_rounded, color: AppColors.coralBurst, size: 36),
                        const SizedBox(width: AppSpacing.sm),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('VERIFIED RESUME (PDF)', style: AppTypography.labelLarge),
                              Text('Updated 2026 • Verified SHA-256 Hash', style: AppTypography.cyberMonoSmall),
                            ],
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.download_rounded, color: AppColors.neonCyan),
                          onPressed: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Downloading Jashwanth_V_Resume_2026.pdf...')),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.sm),

            // Bottom Action Buttons
            Row(
              children: [
                Expanded(
                  child: SkillGlowButton(
                    label: _isFollowing ? 'FOLLOWING ✅' : 'FOLLOW DEVELOPER ➕',
                    variant: _isFollowing ? SkillButtonVariant.secondary : SkillButtonVariant.primary,
                    onPressed: () {
                      setState(() {
                        _isFollowing = !_isFollowing;
                      });
                    },
                  ),
                ),
                const SizedBox(width: AppSpacing.sm),
                IconButton(
                  icon: const Icon(Icons.share_rounded, color: AppColors.neonCyan),
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Copied Public Portfolio Link: https://skillarena.dev/u/jashwanth')),
                    );
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatColumn(String label, String value) {
    return Column(
      children: [
        Text(value, style: AppTypography.heading3.copyWith(color: AppColors.neonCyan)),
        Text(label, style: AppTypography.cyberMonoSmall),
      ],
    );
  }
}
