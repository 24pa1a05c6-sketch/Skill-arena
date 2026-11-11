import 'dart:math' show pi, cos, sin;
import 'package:flutter/material.dart';
import 'package:skill_arena/core/theme/tokens/app_colors.dart';
import 'package:skill_arena/core/theme/tokens/app_curves.dart';
import 'package:skill_arena/core/theme/tokens/app_durations.dart';
import 'package:skill_arena/core/theme/tokens/app_typography.dart';

class SkillRadarChart extends StatefulWidget {
  final Map<String, double> data;
  final double size;
  final Color? fillColor;
  final Color? strokeColor;
  final Color? gridColor;
  final bool animate;

  const SkillRadarChart({
    super.key,
    required this.data,
    this.size = 200,
    this.fillColor,
    this.strokeColor,
    this.gridColor,
    this.animate = true,
  });

  @override
  State<SkillRadarChart> createState() => _SkillRadarChartState();
}

class _SkillRadarChartState extends State<SkillRadarChart> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: AppDurations.slow,
    );

    _animation = CurvedAnimation(
      parent: _controller,
      curve: AppCurves.medium,
    );

    if (widget.animate) {
      _controller.forward();
    } else {
      _controller.value = 1.0;
    }
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
          return CustomPaint(
            size: Size(widget.size, widget.size),
            painter: _RadarChartPainter(
              data: widget.data,
              animationValue: _animation.value,
              fillColor: widget.fillColor ?? AppColors.electricBlue.withValues(alpha: 0.2),
              strokeColor: widget.strokeColor ?? AppColors.electricBlue,
              gridColor: widget.gridColor ?? AppColors.textTertiary.withValues(alpha: 0.15),
            ),
          );
        },
      ),
    );
  }
}

class _RadarChartPainter extends CustomPainter {
  final Map<String, double> data;
  final double animationValue;
  final Color fillColor;
  final Color strokeColor;
  final Color gridColor;

  _RadarChartPainter({
    required this.data,
    required this.animationValue,
    required this.fillColor,
    required this.strokeColor,
    required this.gridColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final centerX = size.width / 2;
    final centerY = size.height / 2;
    final radius = size.width / 2;
    final sides = data.length;
    final angle = (2 * pi) / sides;

    // Draw grid pentagons
    final gridPaint = Paint()
      ..color = gridColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.5;

    for (var i = 1; i <= 4; i++) {
      final r = radius * (i * 0.25);
      final path = Path();
      for (var j = 0; j < sides; j++) {
        final x = centerX + r * cos(angle * j - pi / 2);
        final y = centerY + r * sin(angle * j - pi / 2);
        if (j == 0) {
          path.moveTo(x, y);
        } else {
          path.lineTo(x, y);
        }
      }
      path.close();
      canvas.drawPath(path, gridPaint);
    }

    // Draw axis lines
    for (var j = 0; j < sides; j++) {
      final x = centerX + radius * cos(angle * j - pi / 2);
      final y = centerY + radius * sin(angle * j - pi / 2);
      canvas.drawLine(Offset(centerX, centerY), Offset(x, y), gridPaint);
    }

    // Draw data polygon
    final dataPath = Path();
    final points = <Offset>[];
    int index = 0;
    for (final value in data.values) {
      final currentRadius = radius * (value * animationValue);
      final x = centerX + currentRadius * cos(angle * index - pi / 2);
      final y = centerY + currentRadius * sin(angle * index - pi / 2);
      points.add(Offset(x, y));
      if (index == 0) {
        dataPath.moveTo(x, y);
      } else {
        dataPath.lineTo(x, y);
      }
      index++;
    }
    dataPath.close();

    final fillPaint = Paint()
      ..color = fillColor
      ..style = PaintingStyle.fill;
    
    final strokePaint = Paint()
      ..color = strokeColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;

    canvas
      ..drawPath(dataPath, fillPaint)
      ..drawPath(dataPath, strokePaint);

    // Draw data points
    final pointPaint = Paint()
      ..color = strokeColor
      ..style = PaintingStyle.fill;

    for (final point in points) {
      canvas.drawCircle(point, 4, pointPaint);
    }

    // Draw labels
    index = 0;
    for (final label in data.keys) {
      final labelRadius = radius + 20; // offset labels slightly
      final x = centerX + labelRadius * cos(angle * index - pi / 2);
      final y = centerY + labelRadius * sin(angle * index - pi / 2);

      final textSpan = TextSpan(
        text: label,
        style: AppTypography.labelMedium.copyWith(color: AppColors.textSecondary),
      );
      final textPainter = TextPainter(
        text: textSpan,
        textDirection: TextDirection.ltr,
      );
      textPainter
        ..layout()
        ..paint(
          canvas,
          Offset(x - textPainter.width / 2, y - textPainter.height / 2),
        );
      index++;
    }
  }

  @override
  bool shouldRepaint(covariant _RadarChartPainter oldDelegate) {
    return oldDelegate.animationValue != animationValue ||
        oldDelegate.data != data ||
        oldDelegate.fillColor != fillColor ||
        oldDelegate.strokeColor != strokeColor ||
        oldDelegate.gridColor != gridColor;
  }
}
