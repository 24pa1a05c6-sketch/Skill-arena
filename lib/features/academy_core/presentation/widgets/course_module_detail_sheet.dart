import 'package:flutter/material.dart';
import 'package:skill_arena/core/theme/tokens/app_colors.dart';
import 'package:skill_arena/core/theme/tokens/app_spacing.dart';
import 'package:skill_arena/core/theme/tokens/app_typography.dart';
import 'package:skill_arena/core/widgets/skill_badge.dart';
import 'package:skill_arena/core/widgets/skill_glass_card.dart';
import 'package:skill_arena/core/widgets/skill_glow_button.dart';

/// Interactive Course Module & Quiz Challenge Bottom Sheet.
class CourseModuleDetailSheet extends StatefulWidget {
  final String title;
  final String category;
  final int totalLessons;
  final int xpReward;

  const CourseModuleDetailSheet({
    super.key,
    required this.title,
    required this.category,
    this.totalLessons = 8,
    this.xpReward = 500,
  });

  @override
  State<CourseModuleDetailSheet> createState() => _CourseModuleDetailSheetState();
}

class _CourseModuleDetailSheetState extends State<CourseModuleDetailSheet> {
  final int _selectedQuizIndex = 0;
  int? _userAnswerIndex;
  bool _isSubmitted = false;
  bool _isClaimed = false;

  final List<Map<String, dynamic>> _quizQuestions = [
    {
      'question': 'Which Flutter widget provides top-level navigation shell isolation across Riverpod state boundaries?',
      'options': ['StatefulShellRoute', 'Navigator2030', 'MaterialAppRouter', 'RiverpodContainerRoute'],
      'correct': 0,
    },
    {
      'question': 'What is the recommended time complexity for sorting N items in live battle arenas?',
      'options': ['O(N^2)', 'O(N log N)', 'O(N!)', 'O(2^N)'],
      'correct': 1,
    },
  ];

  @override
  Widget build(BuildContext context) {
    final currentQ = _quizQuestions[_selectedQuizIndex];
    final isCorrect = _userAnswerIndex == currentQ['correct'];

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
            // Sheet Handle bar
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.white24,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.sm),

            // Header Row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(widget.title, style: AppTypography.heading3),
                      Text('${widget.category} • ${widget.totalLessons} Lessons', style: AppTypography.cyberMonoSmall),
                    ],
                  ),
                ),
                SkillBadge(label: '+${widget.xpReward} XP', variant: SkillBadgeVariant.success),
              ],
            ),
            const SizedBox(height: AppSpacing.md),

            Expanded(
              child: ListView(
                children: [
                  // Module Progress
                  SkillGlassCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('MODULE PROGRESS', style: AppTypography.labelLarge),
                            Text('75% COMPLETED', style: AppTypography.cyberMonoSmall.copyWith(color: AppColors.neonCyan)),
                          ],
                        ),
                        const SizedBox(height: AppSpacing.xs),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(4),
                          child: const LinearProgressIndicator(
                            value: 0.75,
                            backgroundColor: Colors.white12,
                            color: AppColors.neonCyan,
                            minHeight: 6,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: AppSpacing.md),

                  // Interactive Quiz Section
                  Text('INTERACTIVE KNOWLEDGE DRILL ⚡', style: AppTypography.labelLarge),
                  const SizedBox(height: AppSpacing.xs),
                  SkillGlassCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Question ${_selectedQuizIndex + 1}/${_quizQuestions.length}:',
                          style: AppTypography.cyberMonoSmall.copyWith(color: AppColors.cyberAmber),
                        ),
                        const SizedBox(height: AppSpacing.xs),
                        Text(currentQ['question'] as String, style: AppTypography.bodyMedium),
                        const SizedBox(height: AppSpacing.sm),

                        ...List.generate((currentQ['options'] as List).length, (idx) {
                          final isSelected = _userAnswerIndex == idx;
                          return Padding(
                            padding: const EdgeInsets.only(bottom: AppSpacing.xs),
                            child: InkWell(
                              onTap: _isSubmitted
                                  ? null
                                  : () {
                                      setState(() {
                                        _userAnswerIndex = idx;
                                      });
                                    },
                              borderRadius: BorderRadius.circular(8),
                              child: Container(
                                padding: const EdgeInsets.all(AppSpacing.sm),
                                decoration: BoxDecoration(
                                  color: isSelected
                                      ? (_isSubmitted
                                          ? (isCorrect ? AppColors.synthEmerald.withValues(alpha: 0.2) : AppColors.coralBurst.withValues(alpha: 0.2))
                                          : AppColors.electricBlue.withValues(alpha: 0.2))
                                      : Colors.white.withValues(alpha: 0.05),
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(
                                    color: isSelected ? AppColors.electricBlue : Colors.white12,
                                  ),
                                ),
                                child: Row(
                                  children: [
                                    Icon(
                                      isSelected ? Icons.check_circle_rounded : Icons.radio_button_unchecked_rounded,
                                      size: 18,
                                      color: isSelected ? AppColors.neonCyan : Colors.white38,
                                    ),
                                    const SizedBox(width: AppSpacing.sm),
                                    Expanded(
                                      child: Text(
                                        (currentQ['options'] as List)[idx] as String,
                                        style: AppTypography.bodySmall,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        }),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.sm),

            // Action Buttons
            if (!_isSubmitted)
              SkillGlowButton(
                label: 'SUBMIT ANSWER 🚀',
                width: double.infinity,
                onPressed: _userAnswerIndex == null
                    ? null
                    : () {
                        setState(() {
                          _isSubmitted = true;
                        });
                      },
              )
            else if (!_isClaimed)
              SkillGlowButton(
                label: isCorrect ? 'CLAIM +${widget.xpReward} XP REWARD 🎉' : 'RETRY QUESTION 🔄',
                variant: isCorrect ? SkillButtonVariant.secondary : SkillButtonVariant.primary,
                width: double.infinity,
                onPressed: () {
                  if (isCorrect) {
                    setState(() {
                      _isClaimed = true;
                    });
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('🎉 Claimed +${widget.xpReward} XP! Skill Matrix Updated!'),
                        backgroundColor: AppColors.synthEmerald,
                      ),
                    );
                  } else {
                    setState(() {
                      _isSubmitted = false;
                      _userAnswerIndex = null;
                    });
                  }
                },
              )
            else
              SkillGlowButton(
                label: 'MODULE COMPLETED ✅',
                variant: SkillButtonVariant.secondary,
                width: double.infinity,
                onPressed: () => Navigator.pop(context),
              ),
          ],
        ),
      ),
    );
  }
}
