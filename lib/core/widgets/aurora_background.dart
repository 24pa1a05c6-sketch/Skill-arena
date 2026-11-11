import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:skill_arena/core/theme/tokens/app_colors.dart';

class AuroraBackground extends StatefulWidget {
  final Widget child;

  const AuroraBackground({
    super.key,
    required this.child,
  });

  @override
  State<AuroraBackground> createState() => _AuroraBackgroundState();
}

class _AuroraBackgroundState extends State<AuroraBackground>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 15),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(color: AppColors.deepSpaceObsidian),
        RepaintBoundary(
          child: AnimatedBuilder(
            animation: _controller,
            builder: (context, _) {
              return CustomPaint(
                painter: _AuroraPainter(_controller.value),
                size: Size.infinite,
              );
            },
          ),
        ),
        widget.child,
      ],
    );
  }
}

class _AuroraPainter extends CustomPainter {
  final double progress;

  _AuroraPainter(this.progress);

  @override
  void paint(Canvas canvas, Size size) {
    final double centerX = size.width / 2;
    final double centerY = size.height / 2;

    // Orb 1: Large, Electric Blue, circular drift
    final double x1 = centerX + math.cos(progress * 2 * math.pi) * 100;
    final double y1 = centerY + math.sin(progress * 2 * math.pi) * 50;
    _drawOrb(
      canvas,
      Offset(x1, y1),
      200,
      AppColors.electricBlue.withValues(alpha: 0.15),
    );

    // Orb 2: Medium, Royal Purple, opposite direction
    final double x2 = centerX + math.cos(progress * 2 * math.pi + math.pi) * 80;
    final double y2 = centerY + math.sin(progress * 2 * math.pi + math.pi) * 120;
    _drawOrb(
      canvas,
      Offset(x2, y2),
      150,
      AppColors.royalPurple.withValues(alpha: 0.12),
    );

    // Orb 3: Small, Neon Cyan, subtle float
    final double x3 = centerX + math.cos(progress * 4 * math.pi) * 60;
    final double y3 = centerY + math.sin(progress * 4 * math.pi) * 60;
    _drawOrb(
      canvas,
      Offset(x3, y3),
      100,
      AppColors.neonCyan.withValues(alpha: 0.08),
    );
  }

  void _drawOrb(Canvas canvas, Offset center, double radius, Color color) {
    final paint = Paint()
      ..shader = RadialGradient(
        colors: [color, color.withValues(alpha: 0.0)],
        stops: const [0.0, 1.0],
      ).createShader(Rect.fromCircle(center: center, radius: radius));
    canvas.drawCircle(center, radius, paint);
  }

  @override
  bool shouldRepaint(covariant _AuroraPainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}
