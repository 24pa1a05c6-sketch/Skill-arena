import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:skill_arena/core/theme/tokens/app_colors.dart';
import 'package:skill_arena/core/theme/tokens/app_spacing.dart';
import 'package:skill_arena/core/theme/tokens/app_typography.dart';
import 'package:skill_arena/core/widgets/aurora_background.dart';
import 'package:skill_arena/core/widgets/skill_badge.dart';
import 'package:skill_arena/core/widgets/skill_glass_card.dart';
import 'package:skill_arena/core/widgets/skill_glow_button.dart';
import 'package:skill_arena/core/widgets/skill_skeleton_loader.dart';
import 'package:skill_arena/features/academy_core/domain/entities/course.dart';
import 'package:skill_arena/features/academy_core/presentation/providers/academy_provider.dart';
import 'package:skill_arena/features/academy_core/presentation/widgets/course_module_detail_sheet.dart';
import 'package:skill_arena/features/academy_core/presentation/widgets/course_video_lesson_sheet.dart';

/// Academy Core Screen.
class AcademyCoreScreen extends ConsumerWidget {
  const AcademyCoreScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(academyProvider);
    final notifier = ref.read(academyProvider.notifier);

    final filteredCourses = state.selectedCategory == 'ALL'
        ? state.courses
        : state.courses.where((c) => c.category == state.selectedCategory).toList();

    return Scaffold(
      backgroundColor: AppColors.deepSpaceObsidian,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text('ACADEMY CORE', style: AppTypography.heading3),
        centerTitle: true,
      ),
      body: AuroraBackground(
        child: state.isLoading
            ? ListView(
                padding: const EdgeInsets.all(AppSpacing.lg),
                children: const [
                  SkillSkeletonCard(lines: 2),
                  SizedBox(height: AppSpacing.md),
                  SkillSkeletonCard(),
                ],
              )
            : ListView(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.lg,
                  vertical: AppSpacing.md,
                ),
                children: [
                  _buildHeader(state),
                  const SizedBox(height: AppSpacing.lg),
                  _buildCategoryTabs(state, notifier),
                  const SizedBox(height: AppSpacing.lg),
                  _buildContinueLearning(state, context),
                  const SizedBox(height: AppSpacing.lg),
                  Text('SKILL TRACKS', style: AppTypography.labelLarge),
                  const SizedBox(height: AppSpacing.sm),
                  _buildCoursesList(filteredCourses, context),
                ],
              ),
      ),
    );
  }

  Widget _buildHeader(AcademyState state) {
    return SkillGlassCard(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Daily Streak', style: AppTypography.bodySmall),
              const SizedBox(height: AppSpacing.xxs),
              Text(
                '${state.dailyStreak} Day Streak 🔥',
                style: AppTypography.cyberMono.copyWith(color: AppColors.cyberAmber),
              ),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text('Earned Today', style: AppTypography.bodySmall),
              const SizedBox(height: AppSpacing.xxs),
              Text(
                '+${state.xpEarnedToday} XP',
                style: AppTypography.cyberMono.copyWith(color: AppColors.synthEmerald),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryTabs(AcademyState state, AcademyNotifier notifier) {
    final categories = ['ALL', 'FLUTTER', 'CYBER', 'AI', 'WEB3'];
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: categories.map((cat) {
          final isSelected = state.selectedCategory == cat;
          return Padding(
            padding: const EdgeInsets.only(right: AppSpacing.xs),
            child: GestureDetector(
              onTap: () => notifier.setCategory(cat),
              child: SkillBadge(
                label: cat,
                variant: isSelected ? SkillBadgeVariant.info : SkillBadgeVariant.premium,
                isSmall: true,
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildContinueLearning(AcademyState state, BuildContext context) {
    final activeCourse = state.courses.firstWhere(
      (c) => c.progress > 0 && c.progress < 1,
      orElse: () => state.courses.first,
    );

    return SkillGlassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('CONTINUE LEARNING', style: AppTypography.bodySmall),
          const SizedBox(height: AppSpacing.xs),
          Text(activeCourse.title, style: AppTypography.heading3),
          const SizedBox(height: AppSpacing.md),
          Row(
            children: [
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: activeCourse.progress,
                    backgroundColor: Colors.white10,
                    color: AppColors.electricBlue,
                    minHeight: 8,
                  ),
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Text(
                '${(activeCourse.progress * 100).toInt()}%',
                style: AppTypography.cyberMonoSmall,
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          SkillGlowButton(
            label: 'CONTINUE MODULE ${activeCourse.completedModules + 1}',
            width: double.infinity,
            onPressed: () {
              showModalBottomSheet(
                context: context,
                backgroundColor: Colors.transparent,
                isScrollControlled: true,
                builder: (_) => CourseModuleDetailSheet(
                  title: activeCourse.title,
                  category: activeCourse.category,
                  xpReward: activeCourse.xpReward,
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildCoursesList(List<Course> filteredCourses, BuildContext context) {
    return Column(
      children: filteredCourses.map((course) {
        return Padding(
          padding: const EdgeInsets.only(bottom: AppSpacing.sm),
          child: SkillGlassCard(
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(course.title, style: AppTypography.heading3),
                      Text('Level: ${course.level}', style: AppTypography.bodySmall),
                      const SizedBox(height: AppSpacing.xxs),
                      Row(
                        children: [
                          SkillBadge(
                            label: course.category,
                            variant: SkillBadgeVariant.info,
                            isSmall: true,
                          ),
                          const SizedBox(width: AppSpacing.xs),
                          Text(
                            '${course.totalModules} modules • ${course.xpReward} XP',
                            style: AppTypography.cyberMonoSmall,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.play_circle_fill_rounded, color: AppColors.neonCyan, size: 36),
                  onPressed: () {
                    showModalBottomSheet(
                      context: context,
                      backgroundColor: Colors.transparent,
                      isScrollControlled: true,
                      builder: (_) => CourseVideoLessonSheet(
                        courseTitle: course.title,
                        lessonTitle: 'Module 1: High-Performance Architecture Fundamentals',
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }
}
