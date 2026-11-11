import 'package:flutter/material.dart';
import 'package:skill_arena/core/theme/tokens/app_colors.dart';
import 'package:skill_arena/core/theme/tokens/app_spacing.dart';
import 'package:skill_arena/core/theme/tokens/app_typography.dart';
import 'package:skill_arena/core/widgets/skill_badge.dart';
import 'package:skill_arena/core/widgets/skill_glass_card.dart';
import 'package:skill_arena/core/widgets/skill_glow_button.dart';

/// Job Application Sheet.
class JobApplicationSheet extends StatefulWidget {
  final String company;
  final String role;
  final String matchRate;

  const JobApplicationSheet({
    super.key,
    required this.company,
    required this.role,
    required this.matchRate,
  });

  @override
  State<JobApplicationSheet> createState() => _JobApplicationSheetState();
}

class _JobApplicationSheetState extends State<JobApplicationSheet> {
  bool _isSubmitted = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.75,
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
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(widget.role, style: AppTypography.heading3),
                      Text(widget.company, style: AppTypography.cyberMonoSmall),
                    ],
                  ),
                ),
                SkillBadge(label: '${widget.matchRate} MATCH', variant: SkillBadgeVariant.success),
                IconButton(
                  icon: const Icon(Icons.close, color: Colors.white70),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.md),

            SkillGlassCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('ATTACHED VERIFIED PROFILES', style: AppTypography.labelLarge),
                  const SizedBox(height: AppSpacing.xs),
                  Text('• Verified ELO Score: 2450 (Top 1%)', style: AppTypography.bodySmall),
                  Text('• Blockchain Certificate: Vanguard Senior Architect', style: AppTypography.bodySmall),
                  Text('• Attached Resume: Jashwanth_V_Resume_2026.pdf', style: AppTypography.bodySmall),
                ],
              ),
            ),
            const Spacer(),

            SkillGlowButton(
              label: _isSubmitted ? 'APPLICATION SUBMITTED ✅' : 'SUBMIT ONE-TAP APPLICATION 🚀',
              variant: _isSubmitted ? SkillButtonVariant.secondary : SkillButtonVariant.primary,
              width: double.infinity,
              onPressed: () {
                if (!_isSubmitted) {
                  setState(() {
                    _isSubmitted = true;
                  });
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Application sent to ${widget.company}! 🎉')),
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
}
