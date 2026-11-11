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
import 'package:skill_arena/features/economy/domain/entities/marketplace_item.dart';
import 'package:skill_arena/features/economy/presentation/providers/economy_provider.dart';
import 'package:skill_arena/features/economy/presentation/widgets/asset_inspection_sheet.dart';
import 'package:skill_arena/features/economy/presentation/widgets/token_topup_sheet.dart';

/// Flagship Vault Marketplace & Digital Economy Screen.
class VaultMarketplaceScreen extends ConsumerWidget {
  const VaultMarketplaceScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(economyProvider);
    final notifier = ref.read(economyProvider.notifier);

    return Scaffold(
      backgroundColor: AppColors.deepSpaceObsidian,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text('THE VAULT MARKETPLACE 💎', style: AppTypography.heading3),
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
                  // Wallet Balance Card
                  SkillGlassCard(
                    padding: const EdgeInsets.all(AppSpacing.lg),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('ARENA WALLET BALANCE', style: AppTypography.labelLarge),
                        const SizedBox(height: AppSpacing.xs),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(
                                '${state.wallet.tokenBalance} \$ARENA',
                                style: AppTypography.heading1.copyWith(color: AppColors.cyberAmber),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            const SizedBox(width: AppSpacing.xs),
                            SkillGlowButton(
                              label: '+ TOP UP',
                              size: SkillButtonSize.small,
                              onPressed: () {
                                showModalBottomSheet(
                                  context: context,
                                  backgroundColor: Colors.transparent,
                                  isScrollControlled: true,
                                  builder: (_) => const TokenTopupSheet(),
                                );
                              },
                            ),
                          ],
                        ),
                        const SizedBox(height: AppSpacing.sm),
                        Row(
                          children: [
                            Text('${state.wallet.coins} Coins', style: AppTypography.cyberMonoSmall),
                            const SizedBox(width: AppSpacing.md),
                            Text('${state.wallet.referralBonus} Referral XP', style: AppTypography.cyberMonoSmall.copyWith(color: AppColors.neonCyan)),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: AppSpacing.lg),

                  // Catalog Section
                  Text('FEATURED VAULT ASSETS', style: AppTypography.labelLarge),
                  const SizedBox(height: AppSpacing.sm),

                  ...state.catalog.map((item) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: AppSpacing.md),
                      child: InkWell(
                        onTap: () {
                          showModalBottomSheet(
                            context: context,
                            backgroundColor: Colors.transparent,
                            isScrollControlled: true,
                            builder: (_) => AssetInspectionSheet(
                              title: item.title,
                              rarity: item.rarity.name.toUpperCase(),
                              price: item.priceTokens,
                            ),
                          );
                        },
                        child: _buildItemCard(context, item, notifier),
                      ),
                    );
                  }),
                ],
              ),
      ),
    );
  }

  Widget _buildItemCard(BuildContext context, MarketplaceItem item, EconomyNotifier notifier) {
    SkillBadgeVariant rarityVariant = SkillBadgeVariant.info;
    if (item.rarity == ItemRarity.epic) rarityVariant = SkillBadgeVariant.live;
    if (item.rarity == ItemRarity.legendary) rarityVariant = SkillBadgeVariant.premium;

    return SkillGlassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  item.title,
                  style: AppTypography.heading3,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: AppSpacing.xs),
              SkillBadge(
                label: item.rarity.name.toUpperCase(),
                variant: rarityVariant,
                isSmall: true,
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(item.description, style: AppTypography.bodySmall),
          const SizedBox(height: AppSpacing.md),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${item.priceTokens} \$ARENA',
                style: AppTypography.cyberMono.copyWith(color: AppColors.cyberAmber),
              ),
              SkillGlowButton(
                label: item.isOwned ? (item.isEquipped ? 'EQUIPPED ✅' : 'EQUIP 🛡️') : 'UNLOCK ASSET 🚀',
                variant: item.isOwned ? SkillButtonVariant.secondary : SkillButtonVariant.primary,
                size: SkillButtonSize.small,
                onPressed: () {
                  if (!item.isOwned) {
                    notifier.purchaseItem(item);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Unlocked ${item.title}! Added to Inventory.')),
                    );
                  } else {
                    showModalBottomSheet(
                      context: context,
                      backgroundColor: Colors.transparent,
                      isScrollControlled: true,
                      builder: (_) => AssetInspectionSheet(
                        title: item.title,
                        rarity: item.rarity.name.toUpperCase(),
                        price: item.priceTokens,
                      ),
                    );
                  }
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
