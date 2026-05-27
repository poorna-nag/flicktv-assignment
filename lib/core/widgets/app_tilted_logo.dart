import 'package:flutter/material.dart';


class AppTiltedLogo extends StatelessWidget {
  const AppTiltedLogo({
    super.key,
    this.size = 136,
  });

  final double size;

  @override
  Widget build(BuildContext context) {
    return Transform.rotate(
      angle: -0.28,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: <Color>[
              Color(0xFFF2C530),
              Color(0xFFB89414),
              Color(0xFF826D12),
            ],
          ),
          borderRadius: BorderRadius.circular(size * 0.22),
          boxShadow: <BoxShadow>[
            BoxShadow(
              color: Colors.black.withOpacity(0.34),
              blurRadius: 30,
              offset: const Offset(0, 16),
            ),
          ],
        ),
        child: Stack(
          children: <Widget>[
            Positioned(
              top: 0,
              right: 0,
              child: Container(
                width: size * 0.68,
                height: size * 0.42,
                decoration: const BoxDecoration(
                  color: Color(0xFF4D870A),
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(28),
                    bottomLeft: Radius.circular(26),
                  ),
                ),
              ),
            ),
            Center(
              child: Transform.rotate(
                angle: 0.28,
                child: const Text(
                  '₹',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 58,
                    fontWeight: FontWeight.w900,
                    height: 1,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
