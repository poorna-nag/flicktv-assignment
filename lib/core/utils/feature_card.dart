import 'package:flicktv_yourname/core/constants/app_colors.dart';
import 'package:flicktv_yourname/core/widgets/dark_panel.dart';
import 'package:flutter/material.dart';

class FeatureCard extends StatelessWidget {
  const FeatureCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.opacity,
    required this.offsetY,
    required this.index,
  });

  final String title;
  final String subtitle;
  final double opacity;
  final double offsetY;
  final int index;

  Widget _buildIcon() {
    switch (index) {
      case 0:
        return Stack(
          alignment: Alignment.center,
          children: <Widget>[
            const Icon(
              Icons.phone_iphone_rounded,
              color: Colors.white38,
              size: 26,
            ),
            Positioned(
              right: 6,
              bottom: 6,
              child: Container(
                padding: const EdgeInsets.all(2),
                decoration: const BoxDecoration(
                  color: AppColors.accentBright,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.touch_app_rounded,
                  color: Colors.white,
                  size: 14,
                ),
              ),
            ),
          ],
        );
      case 1:
        return Stack(
          alignment: Alignment.center,
          children: <Widget>[
            const Icon(
              Icons.phone_iphone_rounded,
              color: Colors.white38,
              size: 26,
            ),
            Positioned(
              right: 6,
              bottom: 6,
              child: Container(
                padding: const EdgeInsets.all(2),
                decoration: const BoxDecoration(
                  color: Colors.green,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.check_rounded,
                  color: Colors.white,
                  size: 12,
                ),
              ),
            ),
          ],
        );
      case 2:
      default:
        return Stack(
          alignment: Alignment.center,
          children: <Widget>[
            const Icon(
              Icons.phone_iphone_rounded,
              color: Colors.white38,
              size: 26,
            ),
            Positioned(
              right: 4,
              bottom: 4,
              child: Transform.rotate(
                angle: -0.15,
                child: Container(
                  width: 18,
                  height: 12,
                  decoration: BoxDecoration(
                    color: AppColors.gold,
                    borderRadius: BorderRadius.circular(2),
                    boxShadow: const <BoxShadow>[
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 1,
                        offset: Offset(0, 1),
                      ),
                    ],
                  ),
                  child: const Center(
                    child: Icon(
                      Icons.credit_card_rounded,
                      color: Colors.black,
                      size: 9,
                    ),
                  ),
                ),
              ),
            ),
          ],
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: opacity.clamp(0.0, 1.0),
      child: Transform.translate(
        offset: Offset(0, offsetY),
        child: DarkPanel(
          borderRadius: 24,
          padding: const EdgeInsets.all(16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  color: const Color(0xFF1F1F1F),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: _buildIcon(),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      title,
                      style: const TextStyle(
                        color: AppColors.textPrimary,
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      subtitle,
                      style: const TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 13,
                        height: 1.4,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
