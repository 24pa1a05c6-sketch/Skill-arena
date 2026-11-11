import 'package:flutter/material.dart';
import 'package:skill_arena/core/theme/tokens/app_colors.dart';
import 'package:skill_arena/core/theme/tokens/app_radius.dart';
import 'package:skill_arena/core/theme/tokens/app_spacing.dart';
import 'package:skill_arena/core/theme/tokens/app_typography.dart';

enum SkillBadgeVariant { info, success, warning, error, premium, live }

class SkillBadge extends StatelessWidget {
  final String label;
  final SkillBadgeVariant variant;
  final bool showPulse;
  final IconData? icon;
  final bool isSmall;

  const SkillBadge({
    super.key,
    required this.label,
    required this.variant,
    this.showPulse = false,
    this.icon,
    this.isSmall = false,
  });

  Color _getBackgroundColor() {
    switch (variant) {
      case SkillBadgeVariant.info:
        return AppColors.electricBlue.withValues(alpha: 0.15);
      case SkillBadgeVariant.success:
      case SkillBadgeVariant.live:
        return AppColors.synthEmerald.withValues(alpha: 0.15);
      case SkillBadgeVariant.warning:
        return AppColors.cyberAmber.withValues(alpha: 0.15);
      case SkillBadgeVariant.error:
        return AppColors.coralBurst.withValues(alpha: 0.15);
      case SkillBadgeVariant.premium:
        return AppColors.royalPurple.withValues(alpha: 0.15);
    }
  }

  Color _getTextColor() {
    switch (variant) {
      case SkillBadgeVariant.info:
        return AppColors.electricBlue;
      case SkillBadgeVariant.success:
      case SkillBadgeVariant.live:
        return AppColors.synthEmerald;
      case SkillBadgeVariant.warning:
        return AppColors.cyberAmber;
      case SkillBadgeVariant.error:
        return AppColors.coralBurst;
      case SkillBadgeVariant.premium:
        return AppColors.royalPurple;
    }
  }

  @override
  Widget build(BuildContext context) {
    final textColor = _getTextColor();
    final textStyle = isSmall
        ? AppTypography.cyberMonoSmall.copyWith(color: textColor)
        : AppTypography.labelMedium.copyWith(color: textColor);

    return Semantics(
      label: '${variant.name}: $label',
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.sm,
          vertical: AppSpacing.xxs,
        ),
        decoration: BoxDecoration(
          color: _getBackgroundColor(),
          borderRadius: AppRadius.borderPill,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) ...[
              Icon(
                icon,
                size: isSmall ? 12 : 16,
                color: textColor,
              ),
              const SizedBox(width: AppSpacing.xxs),
            ],
            if (showPulse || variant == SkillBadgeVariant.live) ...[
              _PulseDot(color: textColor),
              const SizedBox(width: AppSpacing.xxs),
            ],
            Text(
              label,
              style: textStyle,
            ),
          ],
        ),
      ),
    );
  }
}

class _PulseDot extends StatefulWidget {
  final Color color;
  const _PulseDot({required this.color});

  @override
  State<_PulseDot> createState() => _PulseDotState();
}

class _PulseDotState extends State<_PulseDot> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat(reverse: true);
    _animation = Tween<double>(begin: 0.3, end: 1.0).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _animation,
      child: Container(
        width: 6,
        height: 6,
        decoration: BoxDecoration(
          color: widget.color,
          shape: BoxShape.circle,
        ),
      ),
    );
  }
}
