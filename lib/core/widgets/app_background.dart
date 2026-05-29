import 'dart:math' as math;

import 'package:flutter/material.dart';

import 'package:poornima/core/constants/app_colors.dart';

class AppBackground extends StatelessWidget {
  const AppBackground({
    super.key,
    required this.child,
    this.showConfetti = false,
    this.introProgress = 1.0,
    this.walletTravelProgress = 1.0,
  });

  final Widget child;
  final bool showConfetti;
  final double introProgress;
  final double walletTravelProgress;

  @override
  Widget build(BuildContext context) {
    final double reveal = Curves.easeOut.transform(
      (introProgress * 1.25).clamp(0.0, 1.0),
    );

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
        Opacity(
          opacity: reveal,
          child: _GlowLayer(walletTravelProgress: walletTravelProgress),
        ),
        Opacity(opacity: reveal, child: const _DotPattern()),
        if (showConfetti) const Positioned.fill(child: _StaticConfetti()),
        child,
      ],
    );
  }
}

class _GlowLayer extends StatelessWidget {
  const _GlowLayer({required this.walletTravelProgress});

  final double walletTravelProgress;

  @override
  Widget build(BuildContext context) {
    final double centerAlignmentY = -0.15 - (0.7 * walletTravelProgress);
    final double radiusValue = 1.6 - (0.4 * walletTravelProgress);
    final double brightnessMult = 1.0 - (0.15 * walletTravelProgress);

    return IgnorePointer(
      child: DecoratedBox(
        decoration: BoxDecoration(
          gradient: RadialGradient(
            center: Alignment(0.0, centerAlignmentY),
            radius: radiusValue,
            colors: <Color>[
              AppColors.backgroundGlow.withValues(alpha: 0.38 * brightnessMult),
              AppColors.backgroundGlow.withValues(alpha: 0.12 * brightnessMult),
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
    final Paint paint = Paint()..color = Colors.white.withValues(alpha: 0.09);
    final double topSectionHeight = size.height * 0.32;
    const double gap = 15;


    for (double y = 0; y < topSectionHeight; y += gap) {
      final int rowIndex = (y / gap).floor();
      final double rowOffset = rowIndex.isEven ? 0 : gap * 0.5;
      for (double x = -gap; x < size.width + gap; x += gap) {
        final double dx = x + rowOffset;
        final double fade = (1 - (y / topSectionHeight)).clamp(0.0, 1.0);
        paint.color = Colors.white.withValues(alpha: 0.08 * fade);
        final double currentDotSize = 1.2 + 3.3 * fade;
        canvas.drawRRect(
          RRect.fromRectAndRadius(
            Rect.fromLTWH(dx, y, currentDotSize, currentDotSize),
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
      duration: const Duration(milliseconds: 5200),
    );
    _particles = List<_ConfettiParticle>.generate(36, (int index) {
      final bool fromLeft = index.isEven;
      final double seed = index * 13.123;
      final double originX = fromLeft ? -0.02 : 1.02;
      final double originY = 0.5 + (math.sin(seed * 0.7) * 0.5 + 0.5) * 0.1;
      final double speedX = (0.12 + (index % 6) * 0.11) * (fromLeft ? 1 : -1);
      final double speedY = -1.05 - (index % 3) * 0.08;
      return _ConfettiParticle(
        originX: originX,
        originY: originY,
        speedX: speedX,
        speedY: speedY,
        size: 8 + (index % 3) * 2,
        rotation: index * 0.3,
        spin: (index.isEven ? 1 : -1) * 0.8,
        color: <Color>[
          AppColors.pink,
          AppColors.blue,
          AppColors.green,
          AppColors.yellow,
          AppColors.error,
        ][index % 5],
      );
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) {
        return;
      }
      _controller.forward(from: 0.0);
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
    required this.originX,
    required this.originY,
    required this.speedX,
    required this.speedY,
    required this.size,
    required this.rotation,
    required this.spin,
    required this.color,
  });

  final double originX;
  final double originY;
  final double speedX;
  final double speedY;
  final double size;
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
      final double time = progress * 3.0;
      final double x = particle.originX + (particle.speedX * time);
      final double y =
          particle.originY + (particle.speedY * time) + (0.63 * time * time);
      if (x < -0.4 || x > 1.4 || y < -0.25 || y > 1.55) {
        continue;
      }
      final double dx = x * size.width;
      final double drift =
          math.sin((progress * math.pi * 2) + particle.rotation) *
          size.width *
          0.02 *
          particle.spin;
      final double dy = y * size.height;
      final double angle =
          particle.rotation + progress * particle.spin * math.pi * 2;
      final double fade = y < 0.2
          ? (y / 0.2).clamp(0.0, 0.95)
          : y > 0.45
          ? 0.0
          : y > 0.35
          ? ((0.45 - y) / 0.1).clamp(0.0, 1.0) * 0.95
          : 0.95;

      canvas.save();
      canvas.translate(dx + drift, dy);
      canvas.rotate(angle);
      final Paint paint = Paint()
        ..color = particle.color.withValues(alpha: fade);
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
