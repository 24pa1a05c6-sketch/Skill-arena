import 'package:flutter/material.dart';
import 'package:skill_arena/core/theme/tokens/app_colors.dart';
import 'package:skill_arena/core/theme/tokens/app_spacing.dart';
import 'package:skill_arena/core/theme/tokens/app_typography.dart';
import 'package:skill_arena/core/widgets/skill_badge.dart';
import 'package:skill_arena/core/widgets/skill_glass_card.dart';
import 'package:skill_arena/core/widgets/skill_glow_button.dart';

/// Cryptographic Blockchain Certificate Verification Sheet.
class VerifiedCertificateSheet extends StatelessWidget {
  final String title;
  final String sha256Hash;

  const VerifiedCertificateSheet({
    super.key,
    this.title = 'Vanguard Senior Flutter Architect Certificate',
    this.sha256Hash = '0x8f3a9e2d1c4b5a6f7e8d9c0b1a2f3e4d5c6b7a8f9e0d1c2b3a4f5e6d7c8b9a0f',
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.8,
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
                Text('VERIFIED CREDENTIAL 🔐', style: AppTypography.heading3),
                IconButton(
                  icon: const Icon(Icons.close, color: Colors.white70),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.sm),

            SkillGlassCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(child: Text(title, style: AppTypography.heading3.copyWith(color: AppColors.neonCyan))),
                      const SkillBadge(label: 'BLOCKCHAIN VERIFIED ✅', variant: SkillBadgeVariant.success, isSmall: true),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  Text('Issued to: Jashwanth V. (ELO 2450)', style: AppTypography.bodySmall),
                  Text('Authority: Skill Arena Global Certification Authority', style: AppTypography.cyberMonoSmall),
                  const SizedBox(height: AppSpacing.md),
                  Text('CRYPTOGRAPHIC SHA-256 HASH:', style: AppTypography.cyberMonoSmall.copyWith(color: AppColors.cyberAmber)),
                  Container(
                    padding: const EdgeInsets.all(AppSpacing.xs),
                    decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(sha256Hash, style: AppTypography.cyberMonoSmall.copyWith(fontSize: 9, color: AppColors.neonCyan)),
                  ),
                ],
              ),
            ),
            const Spacer(),

            SkillGlowButton(
              label: 'SHARE VERIFICATION LINK WITH RECRUITERS 🌐',
              width: double.infinity,
              onPressed: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Copied verified link: https://skillarena.dev/verify/0x8f3a9e...')),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
