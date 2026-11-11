import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:skill_arena/core/services/haptic_service.dart';
import 'package:skill_arena/core/theme/tokens/app_colors.dart';
import 'package:skill_arena/core/theme/tokens/app_curves.dart';
import 'package:skill_arena/core/theme/tokens/app_durations.dart';
import 'package:skill_arena/core/theme/tokens/app_gradients.dart';
import 'package:skill_arena/core/theme/tokens/app_radius.dart';
import 'package:skill_arena/core/theme/tokens/app_shadows.dart';
import 'package:skill_arena/core/theme/tokens/app_spacing.dart';
import 'package:skill_arena/core/theme/tokens/app_typography.dart';

enum SkillButtonVariant { primary, secondary, ghost }
enum SkillButtonSize { small, medium, large }

class SkillGlowButton extends StatefulWidget {
  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;
  final SkillButtonVariant variant;
  final SkillButtonSize size;
  final bool isLoading;
  final bool isSuccess;
  final bool isError;
  final double? width;

  const SkillGlowButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon,
    this.variant = SkillButtonVariant.primary,
    this.size = SkillButtonSize.medium,
    this.isLoading = false,
    this.isSuccess = false,
    this.isError = false,
    this.width,
  });

  @override
  State<SkillGlowButton> createState() => _SkillGlowButtonState();
}

class _SkillGlowButtonState extends State<SkillGlowButton>
    with TickerProviderStateMixin {
  bool _isHovered = false;
  bool _isPressed = false;
  bool _isFocused = false;
  
  late AnimationController _focusController;
  late AnimationController _shakeController;

  @override
  void initState() {
    super.initState();
    _focusController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );
    
    _shakeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );

    if (widget.isError) {
      _shakeController.forward();
    }
  }

  @override
  void didUpdateWidget(SkillGlowButton oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isError && !oldWidget.isError) {
      _shakeController.forward(from: 0.0);
    }
  }

  @override
  void dispose() {
    _focusController.dispose();
    _shakeController.dispose();
    super.dispose();
  }

  bool get _isDisabled => widget.onPressed == null;
  bool get _isLocked => _isDisabled || widget.isLoading;

  void _handleMouseEnter(PointerEvent details) {
    if (_isLocked) return;
    setState(() => _isHovered = true);
  }

  void _handleMouseExit(PointerEvent details) {
    if (_isLocked) return;
    setState(() {
      _isHovered = false;
      _isPressed = false;
    });
  }

  void _handleTapDown(TapDownDetails details) {
    if (_isLocked) return;
    setState(() => _isPressed = true);
  }

  void _handleTapUp(TapUpDetails details) {
    if (_isLocked) return;
    setState(() => _isPressed = false);
  }

  void _handleTapCancel() {
    if (_isLocked) return;
    setState(() => _isPressed = false);
  }

  void _handleTap() {
    if (_isLocked) return;
    HapticService.lightTap();
    widget.onPressed?.call();
  }
  
  void _handleFocusChange(bool hasFocus) {
    setState(() {
      _isFocused = hasFocus;
      if (hasFocus && !_isLocked) {
        _focusController.repeat(reverse: true);
      } else {
        _focusController
          ..stop()
          ..value = 0.0;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final double scale = _isPressed ? 0.97 : (_isHovered ? 1.03 : 1.0);
    final double opacity = _isDisabled ? 0.4 : 1.0;

    double height;
    TextStyle textStyle;
    double paddingHorizontal;
    double iconSize;

    switch (widget.size) {
      case SkillButtonSize.small:
        height = 36.0;
        textStyle = AppTypography.bodySmall;
        paddingHorizontal = AppSpacing.md;
        iconSize = 16.0;
        break;
      case SkillButtonSize.large:
        height = 56.0;
        textStyle = AppTypography.heading3;
        paddingHorizontal = AppSpacing.xl;
        iconSize = 24.0;
        break;
      case SkillButtonSize.medium:
        height = 48.0;
        textStyle = AppTypography.bodyLarge;
        paddingHorizontal = AppSpacing.lg;
        iconSize = 20.0;
        break;
    }

    height = math.max(height, 48.0); // Touch target minimum

    BoxDecoration decoration;
    Color textColor;
    List<BoxShadow>? shadows;

    if (widget.isSuccess) {
      decoration = const BoxDecoration(
        color: AppColors.synthEmerald,
        borderRadius: AppRadius.borderLg,
      );
      textColor = Colors.white;
    } else {
      switch (widget.variant) {
        case SkillButtonVariant.primary:
          decoration = BoxDecoration(
            gradient: AppGradients.auroraShimmer,
            borderRadius: AppRadius.borderLg,
            border: widget.isError ? Border.all(color: AppColors.coralBurst, width: 2.0) : null,
          );
          textColor = Colors.white;
          if (_isHovered && !_isPressed && !widget.isError && !_isLocked) {
            shadows = AppShadows.neonGlow(AppColors.electricBlue);
          }
          break;
        case SkillButtonVariant.secondary:
          decoration = BoxDecoration(
            color: Colors.transparent,
            borderRadius: AppRadius.borderLg,
            border: Border.all(
              color: widget.isError ? AppColors.coralBurst : AppColors.electricBlue,
              width: _isHovered && !_isLocked ? 2.0 : 1.0,
            ),
          );
          textColor = AppColors.electricBlue;
          break;
        case SkillButtonVariant.ghost:
          decoration = BoxDecoration(
            color: Colors.transparent,
            borderRadius: AppRadius.borderLg,
            border: widget.isError ? Border.all(color: AppColors.coralBurst, width: 2.0) : null,
          );
          textColor = AppColors.textSecondary;
          break;
      }
    }

    final Widget buttonContent = Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (widget.isLoading)
          const SizedBox(
            width: 18.0,
            height: 18.0,
            child: CircularProgressIndicator(
              strokeWidth: 2.0,
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
            ),
          )
        else ...[
          if (widget.icon != null || widget.isSuccess) ...[
            AnimatedSwitcher(
              duration: AppDurations.fast,
              child: Icon(
                widget.isSuccess ? Icons.check_rounded : widget.icon,
                key: ValueKey<bool>(widget.isSuccess),
                size: iconSize,
                color: textColor,
              ),
            ),
            const SizedBox(width: AppSpacing.md),
          ],
          Flexible(
            child: FittedBox(
              fit: BoxFit.scaleDown,
              child: AnimatedDefaultTextStyle(
                duration: AppDurations.fast,
                style: textStyle.copyWith(color: textColor),
                child: Text(widget.label),
              ),
            ),
          ),
        ],
      ],
    );

    Widget button = AnimatedScale(
      scale: scale,
      duration: AppDurations.fast,
      curve: AppCurves.fast,
      child: AnimatedOpacity(
        opacity: opacity,
        duration: AppDurations.fast,
        child: AnimatedContainer(
          duration: AppDurations.fast,
          width: widget.width,
          height: height,
          padding: EdgeInsets.symmetric(horizontal: paddingHorizontal),
          decoration: decoration.copyWith(
            boxShadow: _isPressed ? const [] : shadows,
          ),
          child: Center(
            widthFactor: widget.width == null ? 1.0 : null,
            child: buttonContent,
          ),
        ),
      ),
    );

    // Focus Ring
    if (_isFocused) {
      button = AnimatedBuilder(
        animation: _focusController,
        builder: (context, child) {
          return Container(
            decoration: BoxDecoration(
              borderRadius: AppRadius.borderLg,
              border: Border.all(
                color: AppColors.neonCyan.withValues(alpha: 0.5 + 0.5 * _focusController.value),
                width: 2.0,
              ),
            ),
            child: child,
          );
        },
        child: button,
      );
    }

    // Shake Animation for Error
    if (widget.isError) {
      button = AnimatedBuilder(
        animation: _shakeController,
        builder: (context, child) {
          final double offset = math.sin(_shakeController.value * math.pi * 4) * 8.0;
          return Transform.translate(
            offset: Offset(offset, 0.0),
            child: child,
          );
        },
        child: button,
      );
    }

    return Semantics(
      button: true,
      label: widget.label,
      enabled: !_isLocked,
      child: Focus(
        onFocusChange: _handleFocusChange,
        canRequestFocus: !_isLocked,
        child: MouseRegion(
          onEnter: _handleMouseEnter,
          onExit: _handleMouseExit,
          cursor: _isLocked ? MouseCursor.defer : SystemMouseCursors.click,
          child: GestureDetector(
            onTapDown: _handleTapDown,
            onTapUp: _handleTapUp,
            onTapCancel: _handleTapCancel,
            onTap: _handleTap,
            child: button,
          ),
        ),
      ),
    );
  }
}
