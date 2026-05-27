import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../constants/app_colors.dart';

class AppBackground extends StatelessWidget {
  const AppBackground({
    super.key,
    required this.child,
    this.showConfetti = false,
  });

  final Widget child;
  final bool showConfetti;

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: <Widget>[
        const DecoratedBox(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: <Color>[
                AppColors.backgroundTop,
                Color(0xFF23200F),
                AppColors.background,
                Color(0xFF0F0F12),
              ],
              stops: <double>[0.0, 0.24, 0.5, 1.0],
            ),
          ),
        ),
        const _GlowLayer(),
        const _DotPattern(),
        if (showConfetti) const Positioned.fill(child: _StaticConfetti()),
        child,
      ],
    );
  }
}

class _GlowLayer extends StatelessWidget {
  const _GlowLayer();

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: DecoratedBox(
        decoration: BoxDecoration(
          gradient: RadialGradient(
            center: const Alignment(0.0, -0.3),
            radius: 2,
            colors: <Color>[
              AppColors.backgroundGlow.withValues(alpha: 0.34),
              AppColors.backgroundGlow.withValues(alpha: 0.12),
              Colors.transparent,
            ],
            stops: const <double>[0.0, 0.48, 1.0],
          ),
        ),
      ),
    );
  }
}

class _DotPattern extends StatelessWidget {
  const _DotPattern();

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: CustomPaint(
        painter: _DotPatternPainter(),
        child: const SizedBox.expand(),
      ),
    );
  }
}

class _DotPatternPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()..color = Colors.white.withValues(alpha: 0.08);
    final double topSectionHeight = size.height * 0.18;
    const double gap = 15;
    const double dotSize = 4;

    for (double y = 0; y < topSectionHeight; y += gap) {
      final int rowIndex = (y / gap).floor();
      final double rowOffset = rowIndex.isEven ? 0 : gap * 0.5;
      for (double x = -gap; x < size.width + gap; x += gap) {
        final double dx = x + rowOffset;
        final double fade = (1 - (y / topSectionHeight)).clamp(0.0, 1.0);
        paint.color = Colors.white.withValues(alpha: 0.06 * fade);
        canvas.drawRRect(
          RRect.fromRectAndRadius(
            Rect.fromLTWH(dx, y, dotSize, dotSize),
            const Radius.circular(1),
          ),
          paint,
        );
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _StaticConfetti extends StatefulWidget {
  const _StaticConfetti();

  @override
  State<_StaticConfetti> createState() => _StaticConfettiState();
}

class _StaticConfettiState extends State<_StaticConfetti>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final List<_ConfettiParticle> _particles;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10),
    );
    _particles = List<_ConfettiParticle>.generate(28, (int index) {
      final double seed = index * 13.123;
      final double x = (math.sin(seed) * 0.5 + 0.5);
      final double y = (math.cos(seed * 0.7) * 0.5 + 0.5) * 0.18;
      return _ConfettiParticle(
        x: x,
        y: y,
        size: 5 + (index % 3) * 2,
        speed: 0.08 + (index % 5) * 0.02,
        rotation: index * 0.3,
        spin: (index.isEven ? 1 : -1) * 0.8,
        color: <Color>[
          AppColors.pink,
          AppColors.blue,
          AppColors.yellow,
          AppColors.accentSoft,
        ][index % 4],
      );
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) {
        return;
      }
      Future<void>.delayed(const Duration(milliseconds: 900), () {
        if (!mounted) {
          return;
        }
        _controller.repeat();
      });
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: AnimatedBuilder(
        animation: _controller,
        builder: (_, _) {
          return CustomPaint(
            painter: _ConfettiPainter(
              particles: _particles,
              progress: _controller.value,
            ),
            child: const SizedBox.expand(),
          );
        },
      ),
    );
  }
}

class _ConfettiParticle {
  const _ConfettiParticle({
    required this.x,
    required this.y,
    required this.size,
    required this.speed,
    required this.rotation,
    required this.spin,
    required this.color,
  });

  final double x;
  final double y;
  final double size;
  final double speed;
  final double rotation;
  final double spin;
  final Color color;
}

class _ConfettiPainter extends CustomPainter {
  const _ConfettiPainter({required this.particles, required this.progress});

  final List<_ConfettiParticle> particles;
  final double progress;

  @override
  void paint(Canvas canvas, Size size) {
    for (final _ConfettiParticle particle in particles) {
      final double travel = ((progress * particle.speed) + particle.y) % 1.0;
      final double dx = particle.x * size.width;
      final double dy = travel * size.height * 0.55;
      final double angle =
          particle.rotation + progress * particle.spin * math.pi * 2;

      canvas.save();
      canvas.translate(dx, dy);
      canvas.rotate(angle);
      final Paint paint = Paint()
        ..color = particle.color.withValues(alpha: 0.9);
      final RRect rect = RRect.fromRectAndRadius(
        Rect.fromCenter(
          center: Offset.zero,
          width: particle.size * 1.6,
          height: particle.size,
        ),
        Radius.circular(particle.size * 0.2),
      );
      canvas.drawRRect(rect, paint);
      canvas.restore();
    }
  }

  @override
  bool shouldRepaint(covariant _ConfettiPainter oldDelegate) =>
      oldDelegate.progress != progress || oldDelegate.particles != particles;
}
