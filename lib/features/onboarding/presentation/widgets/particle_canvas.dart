import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:skill_arena/core/theme/tokens/app_colors.dart';

/// Floating particle canvas overlay for ambient cyber energy effects.
class ParticleCanvas extends StatefulWidget {
  final int particleCount;

  const ParticleCanvas({
    super.key,
    this.particleCount = 25,
  });

  @override
  State<ParticleCanvas> createState() => _ParticleCanvasState();
}

class _ParticleCanvasState extends State<ParticleCanvas>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final List<_Particle> _particles;
  final math.Random _random = math.Random();

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10),
    )..repeat();

    _particles = List.generate(widget.particleCount, (_) {
      return _Particle(
        x: _random.nextDouble(),
        y: _random.nextDouble(),
        radius: _random.nextDouble() * 2.5 + 1.0,
        speed: _random.nextDouble() * 0.0005 + 0.0002,
        opacity: _random.nextDouble() * 0.5 + 0.2,
        color: _random.nextBool()
            ? AppColors.neonCyan
            : (_random.nextBool()
                ? AppColors.electricBlue
                : AppColors.royalPurple),
      );
    });
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
        animation: _controller,
        builder: (context, _) {
          return CustomPaint(
            painter: _ParticlePainter(_particles, _controller.value),
            size: Size.infinite,
          );
        },
      ),
    );
  }
}

class _Particle {
  double x;
  double y;
  final double radius;
  final double speed;
  final double opacity;
  final Color color;

  _Particle({
    required this.x,
    required this.y,
    required this.radius,
    required this.speed,
    required this.opacity,
    required this.color,
  });
}

class _ParticlePainter extends CustomPainter {
  final List<_Particle> particles;
  final double progress;

  _ParticlePainter(this.particles, this.progress);

  @override
  void paint(Canvas canvas, Size size) {
    for (final particle in particles) {
      final double dy = (particle.y - progress * particle.speed * 100) % 1.0;
      final double y = (dy < 0 ? dy + 1.0 : dy) * size.height;
      final double x = particle.x * size.width;

      final paint = Paint()
        ..color = particle.color.withValues(alpha: particle.opacity)
        ..style = PaintingStyle.fill;

      canvas.drawCircle(Offset(x, y), particle.radius, paint);
    }
  }

  @override
  bool shouldRepaint(covariant _ParticlePainter oldDelegate) => true;
}
