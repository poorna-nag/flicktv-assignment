import 'package:flutter/material.dart';

class Responsive {
  static bool isCompact(BuildContext context) =>
      MediaQuery.sizeOf(context).width < 380;

  static bool isWide(BuildContext context) => MediaQuery.sizeOf(context).width >= 600;

  static double maxContentWidth(BuildContext context) {
    final double width = MediaQuery.sizeOf(context).width;
    return width.clamp(0.0, 480.0);
  }

  static double clampFont(
    BuildContext context, {
    required double min,
    required double max,
    required double factor,
  }) {
    final double width = MediaQuery.sizeOf(context).width;
    return (width * factor).clamp(min, max);
  }
}
