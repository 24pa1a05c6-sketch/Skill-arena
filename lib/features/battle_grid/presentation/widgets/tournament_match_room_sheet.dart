import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:skill_arena/core/theme/tokens/app_colors.dart';
import 'package:skill_arena/core/theme/tokens/app_spacing.dart';
import 'package:skill_arena/core/theme/tokens/app_typography.dart';
import 'package:skill_arena/core/widgets/skill_avatar.dart';
import 'package:skill_arena/core/widgets/skill_badge.dart';
import 'package:skill_arena/core/widgets/skill_glass_card.dart';
import 'package:skill_arena/core/widgets/skill_glow_button.dart';

/// Live Tournament Match Battle Room Sheet.
class TournamentMatchRoomSheet extends StatefulWidget {
  final String opponentName;
  final int opponentElo;

  const TournamentMatchRoomSheet({
    super.key,
    this.opponentName = 'Alex_Vanguard',
    this.opponentElo = 2310,
  });

  @override
  State<TournamentMatchRoomSheet> createState() => _TournamentMatchRoomSheetState();
}

class _TournamentMatchRoomSheetState extends State<TournamentMatchRoomSheet> {
  final int _secondsRemaining = 15;
  final List<String> _battleChat = ['Match room initialized.', 'Opponent connected.', 'Good luck, have fun! ⚔️'];

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.85,
      decoration: const BoxDecoration(
        color: AppColors.cyberBlack,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: const EdgeInsets.all(AppSpacing.md),
      child: SafeArea(
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('LIVE BATTLE ROOM ⚔️', style: AppTypography.heading3),
                IconButton(
                  icon: const Icon(Icons.close, color: Colors.white70),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.sm),

            // Matchup Card
            SkillGlassCard(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Column(
                    children: [
                      const SkillAvatar(initials: 'YOU', status: SkillAvatarStatus.online),
                      const SizedBox(height: AppSpacing.xs),
                      Text('YOU', style: AppTypography.labelLarge),
                      const SkillBadge(label: 'ELO 2450', variant: SkillBadgeVariant.info, isSmall: true),
                    ],
                  ),
                  Text('VS', style: AppTypography.heading1.copyWith(color: AppColors.coralBurst)),
                  Column(
                    children: [
                      const SkillAvatar(initials: 'AV', status: SkillAvatarStatus.online),
                      const SizedBox(height: AppSpacing.xs),
                      Text(widget.opponentName, style: AppTypography.labelLarge),
                      SkillBadge(label: 'ELO ${widget.opponentElo}', variant: SkillBadgeVariant.info, isSmall: true),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.md),

            // Live Countdown Timer
            SkillGlassCard(
              child: Column(
                children: [
                  Text('MATCH STARTING IN', style: AppTypography.cyberMonoSmall),
                  Text('00:${_secondsRemaining.toString().padLeft(2, '0')}', style: AppTypography.heading1.copyWith(color: AppColors.neonCyan)),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.md),

            // Battle Chat Preview
            Text('LIVE MATCH CHAT 💬', style: AppTypography.labelLarge),
            const SizedBox(height: AppSpacing.xs),
            Expanded(
              child: SkillGlassCard(
                child: ListView.builder(
                  itemCount: _battleChat.length,
                  itemBuilder: (ctx, idx) => Padding(
                    padding: const EdgeInsets.only(bottom: AppSpacing.xs),
                    child: Text(_battleChat[idx], style: AppTypography.bodySmall),
                  ),
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.sm),

            // Launch Arena Button
            SkillGlowButton(
              label: 'ENTER LIVE CODING ARENA ⚡',
              width: double.infinity,
              onPressed: () {
                Navigator.pop(context);
                context.push('/coding-arena');
              },
            ),
          ],
        ),
      ),
    );
  }
}
