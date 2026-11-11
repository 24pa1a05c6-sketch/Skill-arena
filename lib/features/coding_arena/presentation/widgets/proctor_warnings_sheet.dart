import 'package:flutter/material.dart';
import 'package:skill_arena/core/theme/tokens/app_colors.dart';
import 'package:skill_arena/core/theme/tokens/app_spacing.dart';
import 'package:skill_arena/core/theme/tokens/app_typography.dart';
import 'package:skill_arena/core/widgets/skill_badge.dart';
import 'package:skill_arena/core/widgets/skill_glass_card.dart';

/// AI Proctoring Security Log Modal Sheet.
class ProctorWarningsSheet extends StatelessWidget {
  const ProctorWarningsSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.7,
      decoration: const BoxDecoration(
        color: AppColors.cyberBlack,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: const EdgeInsets.all(AppSpacing.md),
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('AI PROCTORING LOG 🛡️', style: AppTypography.heading3),
                IconButton(
                  icon: const Icon(Icons.close, color: Colors.white70),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.sm),

            SkillGlassCard(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('INTEGRITY SCORE: 100%', style: AppTypography.labelLarge.copyWith(color: AppColors.synthEmerald)),
                      Text('Neural Vision Status: ACTIVE', style: AppTypography.cyberMonoSmall),
                    ],
                  ),
                  const SkillBadge(label: 'SECURE ✅', variant: SkillBadgeVariant.success),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.md),

            Text('SECURITY EVENT TRAIL', style: AppTypography.labelLarge),
            const SizedBox(height: AppSpacing.xs),
            Expanded(
              child: ListView(
                children: const [
                  Material(
                    color: Colors.transparent,
                    child: ListTile(
                      leading: Icon(Icons.check_circle_outline_rounded, color: AppColors.synthEmerald),
                      title: Text('Environment Check Passed', style: TextStyle(color: Colors.white)),
                      subtitle: Text('No secondary display or recording process detected.', style: TextStyle(color: Colors.white54, fontSize: 11)),
                    ),
                  ),
                  Material(
                    color: Colors.transparent,
                    child: ListTile(
                      leading: Icon(Icons.check_circle_outline_rounded, color: AppColors.synthEmerald),
                      title: Text('Neural Face Mesh Locked', style: TextStyle(color: Colors.white)),
                      subtitle: Text('Single developer detected in camera frame.', style: TextStyle(color: Colors.white54, fontSize: 11)),
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
}
