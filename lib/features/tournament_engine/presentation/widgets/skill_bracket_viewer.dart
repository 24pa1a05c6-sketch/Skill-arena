import 'package:flutter/material.dart';
import 'package:skill_arena/core/theme/tokens/app_colors.dart';
import 'package:skill_arena/core/theme/tokens/app_spacing.dart';
import 'package:skill_arena/core/theme/tokens/app_typography.dart';
import 'package:skill_arena/core/widgets/skill_badge.dart';
import 'package:skill_arena/core/widgets/skill_glass_card.dart';
import 'package:skill_arena/features/tournament_engine/domain/entities/match_model.dart';

/// Reusable Interactive Tournament Bracket Viewer with Zoom & Pan support.
class SkillBracketViewer extends StatelessWidget {
  final List<List<MatchModel>> rounds;
  final Function(MatchModel match)? onMatchTap;

  const SkillBracketViewer({
    super.key,
    required this.rounds,
    this.onMatchTap,
  });

  @override
  Widget build(BuildContext context) {
    if (rounds.isEmpty) {
      return Center(
        child: Text(
          'BRACKETS INITIALIZING...',
          style: AppTypography.cyberMono.copyWith(color: AppColors.neonCyan),
        ),
      );
    }

    return InteractiveViewer(
      constrained: false,
      boundaryMargin: const EdgeInsets.all(AppSpacing.xl),
      minScale: 0.5,
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: List.generate(rounds.length, (roundIndex) {
            final matches = rounds[roundIndex];
            final roundTitle = _getRoundTitle(roundIndex, rounds.length);

            return Padding(
              padding: const EdgeInsets.only(right: AppSpacing.xl),
              child: Column(
                children: [
                  // Round Header
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.md,
                      vertical: AppSpacing.xs,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.cyberBlack,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: AppColors.electricBlue.withValues(alpha: 0.5)),
                    ),
                    child: Text(
                      roundTitle,
                      style: AppTypography.cyberMonoSmall.copyWith(
                        color: AppColors.neonCyan,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.lg),

                  // Round Matches Column
                  Column(
                    children: matches.map((match) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: AppSpacing.lg),
                        child: GestureDetector(
                          onTap: () => onMatchTap?.call(match),
                          child: _buildMatchCard(match),
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ),
            );
          }),
        ),
      ),
    );
  }

  Widget _buildMatchCard(MatchModel match) {
    final isCompleted = match.status == MatchStatus.completed;
    final isLive = match.status == MatchStatus.live;

    return SkillGlassCard(
      width: 240,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  'MATCH #${match.id.length > 3 ? match.id.substring(match.id.length - 3) : match.id}',
                  style: AppTypography.cyberMonoSmall.copyWith(color: AppColors.neonCyan),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: AppSpacing.xs),
              SkillBadge(
                label: isLive ? 'LIVE' : (isCompleted ? 'FINAL' : 'PENDING'),
                variant: isLive
                    ? SkillBadgeVariant.live
                    : (isCompleted ? SkillBadgeVariant.success : SkillBadgeVariant.info),
                isSmall: true,
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.xs),
          _buildPlayerRow(
            name: match.player1Name,
            score: match.player1Score,
            isWinner: match.winnerId == match.player1Id,
          ),
          const Divider(color: Colors.white10, height: AppSpacing.sm),
          _buildPlayerRow(
            name: match.player2Name,
            score: match.player2Score,
            isWinner: match.winnerId == match.player2Id,
          ),
        ],
      ),
    );
  }

  Widget _buildPlayerRow({
    required String name,
    required int score,
    required bool isWinner,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Text(
            name,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTypography.bodySmall.copyWith(
              color: isWinner ? AppColors.cyberAmber : Colors.white,
              fontWeight: isWinner ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ),
        Text(
          '$score',
          style: AppTypography.cyberMono.copyWith(
            color: isWinner ? AppColors.synthEmerald : Colors.white70,
            fontSize: 14,
          ),
        ),
      ],
    );
  }

  String _getRoundTitle(int index, int totalRounds) {
    if (index == totalRounds - 1) return '🏆 FINALS';
    if (index == totalRounds - 2) return '⚔️ SEMI-FINALS';
    if (index == totalRounds - 3) return '⚡ QUARTER-FINALS';
    return 'ROUND ${index + 1}';
  }
}
