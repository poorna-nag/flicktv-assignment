import 'dart:ui';
import 'package:flutter/material.dart';

class CustomCard extends StatelessWidget {
  const CustomCard({
    super.key,
    required this.child,
    this.borderRadius = 26,
    this.padding = const EdgeInsets.all(18),
    this.margin,
  });

  final Widget child;

  final double borderRadius;
  final EdgeInsetsGeometry padding;
  final EdgeInsetsGeometry? margin;

  @override
  Widget build(BuildContext context) {
    final Widget content = ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 14, sigmaY: 14),
        child: Container(
          margin: margin,
          padding: padding,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(borderRadius),

            // Glass background
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Colors.white.withOpacity(0.18),
                Colors.white.withOpacity(0.06),
              ],
            ),

            // Soft border
            border: Border.all(
              color: Colors.white.withOpacity(0.22),
              width: 1.2,
            ),

            // Glow + depth
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.50),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
              BoxShadow(
                color: Colors.white.withOpacity(0.08),
                blurRadius: 8,
                offset: const Offset(-2, -2),
              ),
            ],
          ),

          child: child,
        ),
      ),
    );

    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(borderRadius),
        splashColor: Colors.white.withOpacity(0.08),
        highlightColor: Colors.transparent,
        child: content,
      ),
    );
  }
}
