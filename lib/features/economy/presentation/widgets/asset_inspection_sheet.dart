import 'package:flutter/material.dart';
import 'package:skill_arena/core/theme/tokens/app_colors.dart';
import 'package:skill_arena/core/theme/tokens/app_spacing.dart';
import 'package:skill_arena/core/theme/tokens/app_typography.dart';
import 'package:skill_arena/core/widgets/skill_badge.dart';
import 'package:skill_arena/core/widgets/skill_glass_card.dart';
import 'package:skill_arena/core/widgets/skill_glow_button.dart';

/// Digital Asset Details & Equip Modal Sheet.
class AssetInspectionSheet extends StatefulWidget {
  final String title;
  final String rarity;
  final int price;

  const AssetInspectionSheet({
    super.key,
    required this.title,
    required this.rarity,
    required this.price,
  });

  @override
  State<AssetInspectionSheet> createState() => _AssetInspectionSheetState();
}

class _AssetInspectionSheetState extends State<AssetInspectionSheet> {
  bool _isEquipped = false;
  bool _inWishlist = false;

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
                      Text(widget.title, style: AppTypography.heading3),
                      SkillBadge(label: widget.rarity, variant: SkillBadgeVariant.premium),
                    ],
                  ),
                ),
                IconButton(
                  icon: Icon(_inWishlist ? Icons.favorite_rounded : Icons.favorite_border_rounded, color: AppColors.coralBurst),
                  onPressed: () {
                    setState(() {
                      _inWishlist = !_inWishlist;
                    });
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(_inWishlist ? 'Added to Wishlist ❤️' : 'Removed from Wishlist')),
                    );
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.close, color: Colors.white70),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.md),

            // Asset Preview Box
            Container(
              height: 160,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.black45,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.neonCyan.withValues(alpha: 0.3)),
              ),
              child: const Center(
                child: Icon(Icons.shield_outlined, size: 72, color: AppColors.neonCyan),
              ),
            ),
            const SizedBox(height: AppSpacing.md),

            SkillGlassCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('ASSET EFFECT & BOOSTS', style: AppTypography.labelLarge),
                  const SizedBox(height: AppSpacing.xs),
                  Text('• Grants +1.25x Battle XP Multiplier', style: AppTypography.bodySmall),
                  Text('• Custom Cyber Neon Avatar Border in Global Chat', style: AppTypography.bodySmall),
                ],
              ),
            ),
            const Spacer(),

            SkillGlowButton(
              label: _isEquipped ? 'UNEQUIP ASSET 🛡️' : 'EQUIP TO PROFILE ⚡',
              variant: _isEquipped ? SkillButtonVariant.secondary : SkillButtonVariant.primary,
              width: double.infinity,
              onPressed: () {
                setState(() {
                  _isEquipped = !_isEquipped;
                });
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(_isEquipped ? 'Asset equipped to your profile!' : 'Asset unequipped.')),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
