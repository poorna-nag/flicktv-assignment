import 'package:flutter/material.dart';

class AppTiltedLogo extends StatelessWidget {
  const AppTiltedLogo({super.key, this.size = 136});

  final double size;

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      'assets/images/logo.png',
      width: size,
      height: size,
      fit: BoxFit.contain,
      alignment: Alignment.center,
      filterQuality: FilterQuality.high,
    );
  }
}
