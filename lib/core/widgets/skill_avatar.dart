import 'package:flutter/material.dart';
import 'package:skill_arena/core/theme/tokens/app_colors.dart';
import 'package:skill_arena/core/theme/tokens/app_typography.dart';

enum SkillAvatarStatus { online, away, busy, offline }

class SkillAvatar extends StatelessWidget {
  final String? imageUrl;
  final String? initials;
  final double size;
  final bool showStatusRing;
  final SkillAvatarStatus status;
  final int? level;

  const SkillAvatar({
    super.key,
    this.imageUrl,
    this.initials,
    this.size = 48.0,
    this.showStatusRing = false,
    this.status = SkillAvatarStatus.offline,
    this.level,
  });

  Color _getStatusColor() {
    switch (status) {
      case SkillAvatarStatus.online:
        return AppColors.synthEmerald;
      case SkillAvatarStatus.away:
        return AppColors.cyberAmber;
      case SkillAvatarStatus.busy:
        return AppColors.coralBurst;
      case SkillAvatarStatus.offline:
        return AppColors.textTertiary;
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget avatarChild;
    if (imageUrl != null && imageUrl!.isNotEmpty) {
      avatarChild = CircleAvatar(
        radius: size / 2,
        backgroundImage: NetworkImage(imageUrl!),
      );
    } else {
      avatarChild = Container(
        width: size,
        height: size,
        decoration: const BoxDecoration(
          color: AppColors.surfaceLight,
          shape: BoxShape.circle,
        ),
        alignment: Alignment.center,
        child: Text(
          initials ?? '?',
          style: AppTypography.heading3.copyWith(
            color: AppColors.textPrimary,
            fontSize: size * 0.4,
          ),
        ),
      );
    }

    Widget content = avatarChild;

    if (showStatusRing) {
      content = Container(
        width: size + 6,
        height: size + 6,
        padding: const EdgeInsets.all(3),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
            color: _getStatusColor(),
            width: 3.0,
          ),
        ),
        child: avatarChild,
      );
    }

    final double badgeOffset = showStatusRing ? -2.0 : -2.0;

    return Semantics(
      label: 'Avatar${level != null ? " level $level" : ""}${showStatusRing ? " ${status.name}" : ""}',
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          content,
          if (level != null)
            Positioned(
              bottom: badgeOffset,
              right: badgeOffset,
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: AppColors.electricBlue,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: AppColors.cyberBlack,
                    width: 2.0,
                  ),
                ),
                alignment: Alignment.center,
                child: Text(
                  level.toString(),
                  style: AppTypography.cyberMonoSmall.copyWith(
                    color: AppColors.cyberBlack,
                    fontSize: 10,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
