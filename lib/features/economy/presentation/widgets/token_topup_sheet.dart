import 'package:flutter/material.dart';
import 'package:skill_arena/core/theme/tokens/app_colors.dart';
import 'package:skill_arena/core/theme/tokens/app_spacing.dart';
import 'package:skill_arena/core/theme/tokens/app_typography.dart';
import 'package:skill_arena/core/widgets/skill_glass_card.dart';
import 'package:skill_arena/core/widgets/skill_glow_button.dart';

/// $ARENA Token Top-Up Packages Sheet.
class TokenTopupSheet extends StatelessWidget {
  const TokenTopupSheet({super.key});

  @override
  Widget build(BuildContext context) {
    final packages = [
      {'tokens': '500 \$ARENA', 'price': '\$4.99', 'bonus': '+50 Bonus'},
      {'tokens': '1,200 \$ARENA', 'price': '\$9.99', 'bonus': '+200 Bonus'},
      {'tokens': '3,000 \$ARENA', 'price': '\$24.99', 'bonus': '+600 Bonus (Best Value)'},
    ];

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
                Text('TOP-UP \$ARENA TOKENS 💎', style: AppTypography.heading3),
                IconButton(
                  icon: const Icon(Icons.close, color: Colors.white70),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.sm),

            Expanded(
              child: ListView.builder(
                itemCount: packages.length,
                itemBuilder: (ctx, idx) {
                  final pkg = packages[idx];
                  return Padding(
                    padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                    child: SkillGlassCard(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(pkg['tokens']!, style: AppTypography.heading3.copyWith(color: AppColors.neonCyan)),
                              Text(pkg['bonus']!, style: AppTypography.cyberMonoSmall.copyWith(color: AppColors.synthEmerald)),
                            ],
                          ),
                          SkillGlowButton(
                            label: pkg['price']!,
                            size: SkillButtonSize.small,
                            onPressed: () {
                              Navigator.pop(context);
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('Purchased ${pkg['tokens']} successfully! Balance updated.')),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
