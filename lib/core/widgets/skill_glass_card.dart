import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:skill_arena/core/theme/tokens/app_blur.dart';
import 'package:skill_arena/core/theme/tokens/app_colors.dart';
import 'package:skill_arena/core/theme/tokens/app_curves.dart';
import 'package:skill_arena/core/theme/tokens/app_durations.dart';
import 'package:skill_arena/core/theme/tokens/app_radius.dart';
import 'package:skill_arena/core/theme/tokens/app_spacing.dart';

class SkillGlassCard extends StatefulWidget {
  final Widget child;
  final double? width;
  final double? height;
  final EdgeInsetsGeometry? padding;
  final BorderRadius? borderRadius;
  final bool isDisabled;
  final bool isLoading;
  final bool isSuccess;
  final bool isError;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;

  const SkillGlassCard({
    super.key,
    required this.child,
    this.width,
    this.height,
    this.padding,
    this.borderRadius,
    this.isDisabled = false,
    this.isLoading = false,
    this.isSuccess = false,
    this.isError = false,
    this.onTap,
    this.onLongPress,
  });

  @override
  State<SkillGlassCard> createState() => _SkillGlassCardState();
}

class _SkillGlassCardState extends State<SkillGlassCard>
    with SingleTickerProviderStateMixin {
  bool _isHovered = false;
  bool _isPressed = false;
  
  late AnimationController _shimmerController;

  @override
  void initState() {
    super.initState();
    _shimmerController = AnimationController(
      vsync: this,
      duration: AppDurations.slow,
    );
    if (widget.isLoading) {
      _shimmerController.repeat();
    }
  }

  @override
  void didUpdateWidget(SkillGlassCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isLoading && !oldWidget.isLoading) {
      _shimmerController.repeat();
    } else if (!widget.isLoading && oldWidget.isLoading) {
      _shimmerController.stop();
    }
  }

  @override
  void dispose() {
    _shimmerController.dispose();
    super.dispose();
  }

  void _handleMouseEnter(PointerEvent details) {
    if (widget.isDisabled) return;
    setState(() => _isHovered = true);
  }

  void _handleMouseExit(PointerEvent details) {
    if (widget.isDisabled) return;
    setState(() {
      _isHovered = false;
      _isPressed = false;
    });
  }

  void _handleTapDown(TapDownDetails details) {
    if (widget.isDisabled) return;
    setState(() => _isPressed = true);
  }

  void _handleTapUp(TapUpDetails details) {
    if (widget.isDisabled) return;
    setState(() => _isPressed = false);
  }

  void _handleTapCancel() {
    if (widget.isDisabled) return;
    setState(() => _isPressed = false);
  }

  @override
  Widget build(BuildContext context) {
    final BorderRadius radius = widget.borderRadius ?? AppRadius.borderLg;
    final double scale = _isPressed ? 0.97 : (_isHovered ? 1.02 : 1.0);
    final double opacity = widget.isDisabled ? 0.4 : 1.0;

    Color borderStart = const Color.fromRGBO(255, 255, 255, 0.12);
    Color borderEnd = const Color.fromRGBO(255, 255, 255, 0.02);

    if (widget.isSuccess) {
      borderStart = AppColors.synthEmerald.withValues(alpha: 0.5);
      borderEnd = AppColors.synthEmerald.withValues(alpha: 0.1);
    } else if (widget.isError) {
      borderStart = AppColors.coralBurst.withValues(alpha: 0.5);
      borderEnd = AppColors.coralBurst.withValues(alpha: 0.1);
    } else if (_isHovered) {
      borderStart = const Color.fromRGBO(255, 255, 255, 0.20);
      borderEnd = const Color.fromRGBO(255, 255, 255, 0.05);
    }

    String semanticsLabel = 'Card';
    if (widget.isLoading) {
      semanticsLabel = 'Loading';
    } else if (widget.isSuccess) {
      semanticsLabel = 'Success';
    } else if (widget.isError) {
      semanticsLabel = 'Error';
    } else if (widget.isDisabled) {
      semanticsLabel = 'Disabled';
    }

    return Semantics(
      label: semanticsLabel,
      button: widget.onTap != null,
      enabled: !widget.isDisabled,
      child: AnimatedOpacity(
        duration: AppDurations.fast,
        opacity: opacity,
        child: MouseRegion(
          onEnter: _handleMouseEnter,
          onExit: _handleMouseExit,
          cursor: (widget.isDisabled || (widget.onTap == null && widget.onLongPress == null))
              ? MouseCursor.defer
              : SystemMouseCursors.click,
          child: GestureDetector(
            onTapDown: _handleTapDown,
            onTapUp: _handleTapUp,
            onTapCancel: _handleTapCancel,
            onTap: widget.isDisabled || widget.isLoading ? null : widget.onTap,
            onLongPress: widget.isDisabled || widget.isLoading ? null : widget.onLongPress,
            child: AnimatedScale(
              scale: scale,
              duration: AppDurations.fast,
              curve: AppCurves.fast,
              child: ClipRRect(
                borderRadius: radius,
                child: BackdropFilter(
                  filter: ImageFilter.blur(
                    sigmaX: AppBlur.glass,
                    sigmaY: AppBlur.glass,
                  ),
                  child: Container(
                    width: widget.width,
                    height: widget.height,
                    constraints: const BoxConstraints(
                      minWidth: 48.0,
                      minHeight: 48.0,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.surfaceLight,
                      borderRadius: radius,
                    ),
                    child: Stack(
                      children: [
                        // Glass Border 
                        Positioned.fill(
                          child: AnimatedContainer(
                            duration: AppDurations.fast,
                            decoration: BoxDecoration(
                              borderRadius: radius,
                              gradient: LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: [borderStart, borderEnd],
                              ),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(1.0),
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: radius,
                                  color: const Color.fromRGBO(11, 14, 20, 0.70),
                                ),
                              ),
                            ),
                          ),
                        ),
                        // Loading Shimmer
                        if (widget.isLoading)
                          Positioned.fill(
                            child: AnimatedBuilder(
                              animation: _shimmerController,
                              builder: (context, child) {
                                return Container(
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      begin: Alignment(
                                        -2.0 + _shimmerController.value * 4,
                                        -2.0 + _shimmerController.value * 4,
                                      ),
                                      end: Alignment(
                                        -1.0 + _shimmerController.value * 4,
                                        -1.0 + _shimmerController.value * 4,
                                      ),
                                      colors: [
                                        Colors.white.withValues(alpha: 0.0),
                                        Colors.white.withValues(alpha: 0.1),
                                        Colors.white.withValues(alpha: 0.0),
                                      ],
                                      stops: const [0.0, 0.5, 1.0],
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        // Content
                        Padding(
                          padding: widget.padding ?? const EdgeInsets.all(AppSpacing.md),
                          child: widget.child,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
