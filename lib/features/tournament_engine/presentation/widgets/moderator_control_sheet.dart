import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:skill_arena/core/theme/tokens/app_spacing.dart';
import 'package:skill_arena/core/theme/tokens/app_typography.dart';
import 'package:skill_arena/core/widgets/skill_glass_card.dart';
import 'package:skill_arena/core/widgets/skill_glow_button.dart';
import 'package:skill_arena/features/tournament_engine/domain/entities/tournament_enums.dart';
import 'package:skill_arena/features/tournament_engine/presentation/providers/tournament_engine_provider.dart';

/// Organizer / Moderator Control Sheet for Tournament Administration.
class ModeratorControlSheet extends ConsumerWidget {
  final String tournamentId;

  const ModeratorControlSheet({
    super.key,
    required this.tournamentId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notifier = ref.read(tournamentEngineProvider.notifier);

    return SkillGlassCard(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text('ORGANIZER CONTROL HUB 🛡️', style: AppTypography.heading3, overflow: TextOverflow.ellipsis),
                ),
                IconButton(
                  icon: const Icon(Icons.close, color: Colors.white70),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            'Manage tournament lifecycle status, advance rounds, and verify winner results.',
            style: AppTypography.bodySmall,
          ),
          const SizedBox(height: AppSpacing.lg),
          SkillGlowButton(
            label: 'GENERATE TOURNAMENT BRACKETS',
            width: double.infinity,
            onPressed: () async {
              await notifier.generateBrackets(
                tournamentId: tournamentId,
                playerIds: const ['usr_ninja', 'usr_codemaster', 'usr_dartvader', 'usr_bugsquasher'],
                type: MatchmakingType.singleElimination,
              );
              if (context.mounted) Navigator.pop(context);
            },
          ),
          const SizedBox(height: AppSpacing.sm),
          SkillGlowButton(
            label: 'ADVANCE TO LIVE STATUS ⚡',
            variant: SkillButtonVariant.secondary,
            width: double.infinity,
            onPressed: () async {
              await notifier.updateStatus(tournamentId, TournamentStatus.live);
              if (context.mounted) Navigator.pop(context);
            },
          ),
          const SizedBox(height: AppSpacing.sm),
          SkillGlowButton(
            label: 'DISTRIBUTE CHAMPION REWARDS 🏆',
            variant: SkillButtonVariant.ghost,
            width: double.infinity,
            onPressed: () async {
              await notifier.distributeRewards(
                tournamentId: tournamentId,
                winnerId: 'usr_ninja',
                winnerName: '0xNinja',
                prizePool: 10000,
                xpBonus: 2500,
              );
              if (context.mounted) Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }
}
