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
import 'package:skill_arena/features/recruiter/domain/entities/job_model.dart';
import 'package:skill_arena/features/recruiter/presentation/providers/recruiter_provider.dart';
import 'package:skill_arena/features/recruiter/presentation/widgets/job_application_sheet.dart';
import 'package:skill_arena/features/recruiter/presentation/widgets/verified_certificate_sheet.dart';

/// Flagship Recruiter & Talent Portal Screen.
class RecruiterPortalScreen extends ConsumerWidget {
  const RecruiterPortalScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(recruiterProvider);
    final notifier = ref.read(recruiterProvider.notifier);

    return Scaffold(
      backgroundColor: AppColors.deepSpaceObsidian,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text('RECRUITER & TALENT PORTAL 🎯', style: AppTypography.heading3),
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
                  // Verification Banner
                  InkWell(
                    onTap: () {
                      showModalBottomSheet(
                        context: context,
                        backgroundColor: Colors.transparent,
                        isScrollControlled: true,
                        builder: (_) => const VerifiedCertificateSheet(),
                      );
                    },
                    child: SkillGlassCard(
                      padding: const EdgeInsets.all(AppSpacing.lg),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Text('VERIFIED TALENT STATUS', style: AppTypography.labelLarge, overflow: TextOverflow.ellipsis),
                              ),
                              const SizedBox(width: AppSpacing.xs),
                              const SkillBadge(label: 'VERIFIED ARCHITECT', variant: SkillBadgeVariant.premium, isSmall: true),
                            ],
                          ),
                          const SizedBox(height: AppSpacing.sm),
                          Text(
                            'Your profile is verified with ${state.certificates.length} Blockchain Skill Certificates.',
                            style: AppTypography.bodySmall,
                          ),
                          const SizedBox(height: AppSpacing.md),
                          Row(
                            children: [
                              Text('94% Top Match Rate', style: AppTypography.cyberMonoSmall.copyWith(color: AppColors.neonCyan)),
                              const SizedBox(width: AppSpacing.md),
                              Text('100% Verified ELO', style: AppTypography.cyberMonoSmall.copyWith(color: AppColors.cyberAmber)),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.lg),

                  // Open Job Listings Section
                  Text('OPEN ENTERPRISE POSITIONS', style: AppTypography.labelLarge),
                  const SizedBox(height: AppSpacing.sm),

                  ...state.jobs.map((job) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: AppSpacing.md),
                      child: _buildJobCard(context, job, state.appliedJobIds.contains(job.id), notifier),
                    );
                  }),
                ],
              ),
      ),
    );
  }

  Widget _buildJobCard(BuildContext context, JobModel job, bool isApplied, RecruiterNotifier notifier) {
    return SkillGlassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(child: Text(job.title, style: AppTypography.heading3)),
              SkillBadge(label: job.jobType, variant: SkillBadgeVariant.info, isSmall: true),
            ],
          ),
          const SizedBox(height: AppSpacing.xs),
          Text('${job.companyName} • ${job.location}', style: AppTypography.bodySmall),
          const SizedBox(height: AppSpacing.sm),
          Text(
            job.salaryRange,
            style: AppTypography.cyberMono.copyWith(color: AppColors.cyberAmber),
          ),
          const SizedBox(height: AppSpacing.md),
          Wrap(
            spacing: AppSpacing.xs,
            runSpacing: AppSpacing.xs,
            children: job.requiredSkills.map((skill) {
              return SkillBadge(label: skill, variant: SkillBadgeVariant.info, isSmall: true);
            }).toList(),
          ),
          const SizedBox(height: AppSpacing.md),
          SkillGlowButton(
            label: isApplied ? 'APPLICATION SUBMITTED ✅' : 'APPLY WITH VERIFIED SKILLS 🚀',
            variant: isApplied ? SkillButtonVariant.secondary : SkillButtonVariant.primary,
            width: double.infinity,
            onPressed: () {
              if (!isApplied) {
                notifier.applyForJob(job.id);
              }
              showModalBottomSheet(
                context: context,
                backgroundColor: Colors.transparent,
                isScrollControlled: true,
                builder: (_) => JobApplicationSheet(
                  company: job.companyName,
                  role: job.title,
                  matchRate: '94%',
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
