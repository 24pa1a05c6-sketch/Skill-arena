import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:skill_arena/core/code_executor/code_executor_contract.dart';
import 'package:skill_arena/core/theme/tokens/app_colors.dart';
import 'package:skill_arena/core/theme/tokens/app_spacing.dart';
import 'package:skill_arena/core/theme/tokens/app_typography.dart';
import 'package:skill_arena/core/widgets/aurora_background.dart';
import 'package:skill_arena/core/widgets/skill_badge.dart';
import 'package:skill_arena/core/widgets/skill_glass_card.dart';
import 'package:skill_arena/core/widgets/skill_glow_button.dart';
import 'package:skill_arena/core/widgets/skill_input_field.dart';
import 'package:skill_arena/features/coding_arena/presentation/providers/coding_arena_provider.dart';
import 'package:skill_arena/features/coding_arena/presentation/widgets/proctor_warnings_sheet.dart';

/// Flagship Live Coding Arena & AI Proctoring Screen.
class LiveCodingArenaScreen extends ConsumerStatefulWidget {
  const LiveCodingArenaScreen({super.key});

  @override
  ConsumerState<LiveCodingArenaScreen> createState() => _LiveCodingArenaScreenState();
}

class _LiveCodingArenaScreenState extends ConsumerState<LiveCodingArenaScreen> {
  final TextEditingController _codeController = TextEditingController();

  @override
  void initState() {
    super.initState();
    final initialCode = ref.read(codingArenaProvider).currentCode;
    _codeController.text = initialCode;
  }

  @override
  void dispose() {
    _codeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(codingArenaProvider);
    final notifier = ref.read(codingArenaProvider.notifier);
    final currentProblem = state.problems.isNotEmpty ? state.problems[state.currentProblemIndex] : null;

    return Scaffold(
      backgroundColor: AppColors.deepSpaceObsidian,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text('LIVE CODING ARENA ⚡', style: AppTypography.heading3),
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: AppSpacing.md),
            child: InkWell(
              onTap: () {
                showModalBottomSheet(
                  context: context,
                  backgroundColor: Colors.transparent,
                  isScrollControlled: true,
                  builder: (_) => const ProctorWarningsSheet(),
                );
              },
              child: SkillBadge(
                label: 'AI PROCTOR: ${state.proctorViolationsCount == 0 ? "SECURE ✅" : "${state.proctorViolationsCount} WARNINGS ⚠️"}',
                variant: state.proctorViolationsCount == 0 ? SkillBadgeVariant.success : SkillBadgeVariant.warning,
                isSmall: true,
              ),
            ),
          ),
        ],
      ),
      body: AuroraBackground(
        child: state.isLoading || currentProblem == null
            ? const Center(child: CircularProgressIndicator(color: AppColors.electricBlue))
            : ListView(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.lg,
                  vertical: AppSpacing.md,
                ),
                children: [
                  // Problem Header Card
                  SkillGlassCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(child: Text(currentProblem.title, style: AppTypography.heading3)),
                            SkillBadge(label: currentProblem.difficulty, variant: SkillBadgeVariant.premium, isSmall: true),
                          ],
                        ),
                        const SizedBox(height: AppSpacing.xs),
                        Text(currentProblem.description, style: AppTypography.bodySmall),
                        const SizedBox(height: AppSpacing.sm),
                        Row(
                          children: [
                            Text('Time Limit: ${currentProblem.timeLimitMs}ms', style: AppTypography.cyberMonoSmall),
                            const SizedBox(width: AppSpacing.md),
                            Text('Memory Limit: ${currentProblem.memoryLimitMb}MB', style: AppTypography.cyberMonoSmall),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: AppSpacing.md),

                  // Code Editor Card
                  SkillGlassCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('DART CODE EDITOR 💻', style: AppTypography.labelLarge),
                            SkillBadge(label: state.selectedLanguage.toUpperCase(), variant: SkillBadgeVariant.info, isSmall: true),
                          ],
                        ),
                        const SizedBox(height: AppSpacing.xs),
                        SkillInputField(
                          controller: _codeController,
                          maxLines: 8,
                          hint: 'Write your Dart code solution here...',
                          onChanged: notifier.updateCode,
                        ),
                        const SizedBox(height: AppSpacing.md),
                        SkillGlowButton(
                          label: state.isExecuting ? 'RUNNING TEST SUITE...' : 'RUN & SUBMIT SOLUTION 🚀',
                          isLoading: state.isExecuting,
                          width: double.infinity,
                          onPressed: () {
                            notifier.executeCode();
                          },
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: AppSpacing.md),

                  // Execution Results Console
                  if (state.latestResult != null) _buildResultConsole(state.latestResult!),
                ],
              ),
      ),
    );
  }

  Widget _buildResultConsole(ExecutionResult result) {
    final isSuccess = result.status == ExecutionStatus.success;

    return SkillGlassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('EXECUTION RESULT', style: AppTypography.labelLarge),
              SkillBadge(
                label: result.status.name.toUpperCase(),
                variant: isSuccess ? SkillBadgeVariant.success : SkillBadgeVariant.live,
                isSmall: true,
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            'Test Cases: ${result.passedTestCases}/${result.totalTestCases} Passed',
            style: AppTypography.cyberMono.copyWith(color: isSuccess ? AppColors.synthEmerald : AppColors.coralBurst),
          ),
          const SizedBox(height: AppSpacing.xs),
          Text('Runtime: ${result.runtimeMs}ms | Memory: ${result.memoryKb}KB', style: AppTypography.cyberMonoSmall),
          const SizedBox(height: AppSpacing.sm),
          Container(
            padding: const EdgeInsets.all(AppSpacing.sm),
            decoration: BoxDecoration(
              color: Colors.black45,
              borderRadius: BorderRadius.circular(8),
            ),
            width: double.infinity,
            child: Text(
              isSuccess ? result.stdout : result.stderr,
              style: AppTypography.cyberMonoSmall.copyWith(
                color: isSuccess ? AppColors.neonCyan : AppColors.coralBurst,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
