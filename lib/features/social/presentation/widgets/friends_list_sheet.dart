import 'package:flutter/material.dart';
import 'package:skill_arena/core/theme/tokens/app_colors.dart';
import 'package:skill_arena/core/theme/tokens/app_spacing.dart';
import 'package:skill_arena/core/theme/tokens/app_typography.dart';
import 'package:skill_arena/core/widgets/skill_avatar.dart';
import 'package:skill_arena/core/widgets/skill_badge.dart';
import 'package:skill_arena/core/widgets/skill_glass_card.dart';

/// Friends & Social Connections Sheet.
class FriendsListSheet extends StatefulWidget {
  const FriendsListSheet({super.key});

  @override
  State<FriendsListSheet> createState() => _FriendsListSheetState();
}

class _FriendsListSheetState extends State<FriendsListSheet> {
  final List<Map<String, dynamic>> _friends = [
    {'name': 'Alex_Vanguard', 'elo': 2310, 'online': true, 'initials': 'AV'},
    {'name': 'CyberNinja', 'elo': 2240, 'online': true, 'initials': 'CN'},
    {'name': 'CodeQueen', 'elo': 2190, 'online': false, 'initials': 'CQ'},
  ];

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
                Text('FRIENDS & ARENA SQUAD 👥', style: AppTypography.heading3),
                IconButton(
                  icon: const Icon(Icons.close, color: Colors.white70),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.sm),

            Expanded(
              child: ListView.builder(
                itemCount: _friends.length,
                itemBuilder: (ctx, idx) {
                  final item = _friends[idx];
                  final isOnline = item['online'] as bool;
                  return Padding(
                    padding: const EdgeInsets.only(bottom: AppSpacing.xs),
                    child: SkillGlassCard(
                      child: Row(
                        children: [
                          SkillAvatar(
                            initials: item['initials'] as String,
                            size: 40,
                            showStatusRing: true,
                            status: isOnline ? SkillAvatarStatus.online : SkillAvatarStatus.offline,
                          ),
                          const SizedBox(width: AppSpacing.sm),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(item['name'] as String, style: AppTypography.labelLarge),
                                Text('ELO ${item['elo']} • ${isOnline ? "Online" : "Offline"}', style: AppTypography.cyberMonoSmall),
                              ],
                            ),
                          ),
                          SkillBadge(
                            label: isOnline ? 'INVITE' : 'OFFLINE',
                            variant: isOnline ? SkillBadgeVariant.success : SkillBadgeVariant.info,
                            isSmall: true,
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
