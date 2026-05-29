import 'package:flutter/material.dart';

extension ResponsiveContext on BuildContext {
  double get screenHeight => MediaQuery.of(this).size.height;
  double get screenWidth => MediaQuery.of(this).size.width;

  /// Returns [small], [medium], or [large] based on screen height breakpoints.
  double responsive(double small, double medium, double large) {
    if (screenHeight < 750) return small;
    if (screenHeight < 820) return medium;
    return large;
  }
}
