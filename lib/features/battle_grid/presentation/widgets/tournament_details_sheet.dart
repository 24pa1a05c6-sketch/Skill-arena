import 'package:flutter/material.dart';
import 'package:skill_arena/core/theme/tokens/app_colors.dart';
import 'package:skill_arena/core/theme/tokens/app_spacing.dart';
import 'package:skill_arena/core/theme/tokens/app_typography.dart';
import 'package:skill_arena/core/widgets/skill_badge.dart';
import 'package:skill_arena/core/widgets/skill_glass_card.dart';
import 'package:skill_arena/core/widgets/skill_glow_button.dart';

/// Complete Tournament Details Modal Sheet.
class TournamentDetailsSheet extends StatefulWidget {
  final String title;
  final String prizePool;
  final String category;

  const TournamentDetailsSheet({
    super.key,
    required this.title,
    required this.prizePool,
    required this.category,
  });

  @override
  State<TournamentDetailsSheet> createState() => _TournamentDetailsSheetState();
}

class _TournamentDetailsSheetState extends State<TournamentDetailsSheet> {
  bool _isRegistered = false;
  int _selectedTab = 0; // 0: Details & Rules, 1: Schedule & Prize, 2: Participants

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.88,
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
                      Text(widget.title, style: AppTypography.heading3),
                      Text('${widget.category} • Prize Pool: ${widget.prizePool}', style: AppTypography.cyberMonoSmall.copyWith(color: AppColors.neonCyan)),
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close, color: Colors.white70),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.sm),

            // Tab Selector Row
            Row(
              children: [
                _buildTabButton(0, 'RULES & OVERVIEW'),
                const SizedBox(width: AppSpacing.xs),
                _buildTabButton(1, 'SCHEDULE & PRIZE'),
                const SizedBox(width: AppSpacing.xs),
                _buildTabButton(2, 'PARTICIPANTS'),
              ],
            ),
            const SizedBox(height: AppSpacing.md),

            Expanded(
              child: _selectedTab == 0
                  ? _buildRulesTab()
                  : _selectedTab == 1
                      ? _buildScheduleTab()
                      : _buildParticipantsTab(),
            ),
            const SizedBox(height: AppSpacing.sm),

            // Action Button
            SkillGlowButton(
              label: _isRegistered ? 'ENTER MATCH ROOM ⚔️' : 'REGISTER FOR TOURNAMENT (100 \$ARENA) 🚀',
              variant: _isRegistered ? SkillButtonVariant.secondary : SkillButtonVariant.primary,
              width: double.infinity,
              onPressed: () {
                if (!_isRegistered) {
                  setState(() {
                    _isRegistered = true;
                  });
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Registered successfully! 100 \$ARENA deducted.')),
                  );
                } else {
                  Navigator.pop(context);
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTabButton(int index, String label) {
    final isActive = _selectedTab == index;
    return Expanded(
      child: InkWell(
        onTap: () => setState(() => _selectedTab = index),
        borderRadius: BorderRadius.circular(8),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: AppSpacing.xs),
          decoration: BoxDecoration(
            color: isActive ? AppColors.electricBlue.withValues(alpha: 0.2) : Colors.transparent,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: isActive ? AppColors.neonCyan : Colors.white12),
          ),
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: AppTypography.cyberMonoSmall.copyWith(
              fontSize: 10,
              color: isActive ? AppColors.neonCyan : Colors.white60,
              fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildRulesTab() {
    return ListView(
      children: [
        SkillGlassCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('TOURNAMENT FORMAT & ANTI-CHEAT', style: AppTypography.labelLarge),
              const SizedBox(height: AppSpacing.xs),
              Text('• Single-Elimination Knockout Bracket (64 Players)', style: AppTypography.bodySmall),
              Text('• Live Judge0 Compiler Execution (Time Limit: 2000ms)', style: AppTypography.bodySmall),
              Text('• AURA Neural Proctoring Active (No tab switching allowed)', style: AppTypography.bodySmall),
              Text('• Submissions scored by Speed + Memory + Correctness', style: AppTypography.bodySmall),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildScheduleTab() {
    return ListView(
      children: [
        SkillGlassCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('PRIZE POOL SPLIT', style: AppTypography.labelLarge),
              const SizedBox(height: AppSpacing.xs),
              Text('🥇 1st Place: 5,000 \$ARENA + Grandmaster Crown', style: AppTypography.bodySmall.copyWith(color: AppColors.cyberAmber)),
              Text('🥈 2nd Place: 2,500 \$ARENA + Cyber Frame', style: AppTypography.bodySmall.copyWith(color: Colors.white70)),
              Text('🥉 3rd Place: 1,000 \$ARENA + 500 XP', style: AppTypography.bodySmall.copyWith(color: Colors.white60)),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildParticipantsTab() {
    final players = ['Jashwanth V. (ELO 2450)', 'Alex_Vanguard (ELO 2310)', 'CyberNinja (ELO 2240)', 'CodeQueen (ELO 2190)'];
    return ListView.builder(
      itemCount: players.length,
      itemBuilder: (ctx, idx) {
        return Padding(
          padding: const EdgeInsets.only(bottom: AppSpacing.xs),
          child: SkillGlassCard(
            child: Row(
              children: [
                SkillBadge(label: '#${idx + 1}', variant: SkillBadgeVariant.info, isSmall: true),
                const SizedBox(width: AppSpacing.sm),
                Text(players[idx], style: AppTypography.bodyMedium),
              ],
            ),
          ),
        );
      },
    );
  }
}
