import 'package:flutter/material.dart';

class AppTiltedLogo extends StatelessWidget {
  const AppTiltedLogo({super.key, this.size = 136});

  final double size;

  @override
  Widget build(BuildContext context) {
    return Transform.rotate(
      angle: -0.28,
      child: Image.asset(
        'assets/images/logo.png',
        width: size,
        height: size,
        fit: BoxFit.contain,
      ),
    );
  }
}
