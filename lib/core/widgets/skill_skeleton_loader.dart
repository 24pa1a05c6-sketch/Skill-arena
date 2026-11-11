import 'package:flutter/material.dart';
import 'package:skill_arena/core/theme/tokens/app_colors.dart';
import 'package:skill_arena/core/theme/tokens/app_radius.dart';
import 'package:skill_arena/core/theme/tokens/app_spacing.dart';

class SkillSkeletonLoader extends StatefulWidget {
  final double? width;
  final double height;
  final BorderRadius? borderRadius;
  final bool isCircle;

  const SkillSkeletonLoader({
    super.key,
    this.width,
    this.height = 16.0,
    this.borderRadius,
    this.isCircle = false,
  });

  @override
  State<SkillSkeletonLoader> createState() => _SkillSkeletonLoaderState();
}

class _SkillSkeletonLoaderState extends State<SkillSkeletonLoader> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Alignment> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat();
    _animation = AlignmentTween(
      begin: const Alignment(-1.5, 0.0),
      end: const Alignment(1.5, 0.0),
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.linear,
    ));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: AnimatedBuilder(
        animation: _animation,
        builder: (context, child) {
          return Container(
            width: widget.width,
            height: widget.height,
            decoration: BoxDecoration(
              shape: widget.isCircle ? BoxShape.circle : BoxShape.rectangle,
              borderRadius: widget.isCircle ? null : (widget.borderRadius ?? AppRadius.borderSm),
              gradient: LinearGradient(
                colors: const [
                  AppColors.surfaceLight,
                  AppColors.glassHighlight,
                  AppColors.surfaceLight,
                ],
                stops: const [0.0, 0.5, 1.0],
                begin: Alignment(_animation.value.x - 1.0, 0.0),
                end: Alignment(_animation.value.x + 1.0, 0.0),
              ),
            ),
          );
        },
      ),
    );
  }
}

class SkillSkeletonCard extends StatelessWidget {
  final int lines;
  final bool showAvatar;

  const SkillSkeletonCard({
    super.key,
    this.lines = 3,
    this.showAvatar = false,
  });

  @override
  Widget build(BuildContext context) {
    final lineLayouts = [double.infinity, 0.8, 0.6];
    
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: const BoxDecoration(
        color: AppColors.surfaceLight,
        borderRadius: AppRadius.borderLg,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (showAvatar) ...[
            const SkillSkeletonLoader(
              width: 48,
              height: 48,
              isCircle: true,
            ),
            const SizedBox(width: AppSpacing.md),
          ],
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: List.generate(lines, (index) {
                final double? fractionWidth = lineLayouts[index % lineLayouts.length] == double.infinity 
                  ? null 
                  : lineLayouts[index % lineLayouts.length];
                  
                return Padding(
                  padding: EdgeInsets.only(bottom: index == lines - 1 ? 0 : AppSpacing.sm),
                  child: fractionWidth == null
                      ? const SkillSkeletonLoader(width: double.infinity)
                      : LayoutBuilder(
                          builder: (context, constraints) {
                            return SkillSkeletonLoader(
                              width: constraints.maxWidth * fractionWidth,
                            );
                          },
                        ),
                );
              }),
            ),
          ),
        ],
      ),
    );
  }
}
