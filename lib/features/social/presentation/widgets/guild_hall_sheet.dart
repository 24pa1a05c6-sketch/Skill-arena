import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:skill_arena/core/theme/tokens/app_colors.dart';
import 'package:skill_arena/core/theme/tokens/app_spacing.dart';
import 'package:skill_arena/core/theme/tokens/app_typography.dart';
import 'package:skill_arena/core/widgets/skill_badge.dart';
import 'package:skill_arena/core/widgets/skill_glass_card.dart';
import 'package:skill_arena/core/widgets/skill_glow_button.dart';
import 'package:skill_arena/features/social/presentation/providers/social_provider.dart';

/// Reusable Cyber Guild Hall Modal Sheet.
class GuildHallSheet extends ConsumerWidget {
  const GuildHallSheet({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(socialProvider);
    final notifier = ref.read(socialProvider.notifier);

    return Container(
      height: MediaQuery.of(context).size.height * 0.85,
      decoration: const BoxDecoration(
        color: AppColors.cyberBlack,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: const EdgeInsets.all(AppSpacing.md),
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('GUILD HALL ⚔️', style: AppTypography.heading2, overflow: TextOverflow.ellipsis),
                      Text('Join forces with top Vanguard software squads', style: AppTypography.cyberMonoSmall, overflow: TextOverflow.ellipsis),
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close, color: Colors.white70),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.md),

            // Guilds List
            Expanded(
              child: ListView.builder(
                itemCount: state.guilds.length,
                itemBuilder: (ctx, index) {
                  final guild = state.guilds[index];
                  final isJoined = state.joinedGuildIds.contains(guild.id);

                  return Padding(
                    padding: const EdgeInsets.only(bottom: AppSpacing.md),
                    child: SkillGlassCard(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Text(
                                  '${guild.name} [${guild.tag}]',
                                  style: AppTypography.heading3,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              const SizedBox(width: AppSpacing.xs),
                              SkillBadge(label: 'LVL ${guild.level}', variant: SkillBadgeVariant.premium, isSmall: true),
                            ],
                          ),
                          const SizedBox(height: AppSpacing.xs),
                          Text(guild.description, style: AppTypography.bodySmall),
                          const SizedBox(height: AppSpacing.md),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('${guild.memberCount}/${guild.maxMembers} Members', style: AppTypography.cyberMonoSmall),
                              Text('${guild.xp} Guild XP', style: AppTypography.cyberMonoSmall.copyWith(color: AppColors.cyberAmber)),
                            ],
                          ),
                          const SizedBox(height: AppSpacing.md),
                          SkillGlowButton(
                            label: isJoined ? 'ENTER GUILD CHAT 💬' : 'JOIN GUILD',
                            variant: isJoined ? SkillButtonVariant.primary : SkillButtonVariant.secondary,
                            width: double.infinity,
                            onPressed: () {
                              if (!isJoined) {
                                notifier.joinGuild(guild.id);
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
