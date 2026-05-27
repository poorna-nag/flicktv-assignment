import 'package:flutter/material.dart';

import '../core/constants/app_colors.dart';
import '../core/widgets/app_tilted_logo.dart';
import 'custom_card.dart';

export 'custom_button.dart';
export 'custom_card.dart';

class BenefitTile extends StatelessWidget {
  const BenefitTile({
    super.key,
    required this.icon,
    required this.title,
    required this.description,
    required this.accentColor,
    this.selected = false,
    this.onTap,
  });

  final IconData icon;
  final String title;
  final String description;
  final Color accentColor;
  final bool selected;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return CustomCard(
      // color: selected ? AppColors.surfaceElevated : AppColors.surface,
      borderRadius: 20,
      padding: const EdgeInsets.all(16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: accentColor.withOpacity(0.16),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: selected
                    ? accentColor.withOpacity(0.9)
                    : accentColor.withOpacity(0.55),
              ),
            ),
            child: Icon(icon, color: accentColor, size: 26),
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
                  description,
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
    );
  }
}

class BrandHeroBadge extends StatelessWidget {
  const BrandHeroBadge({super.key, this.size = 150});

  final double size;

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: 'home-hero-badge',
      child: AppTiltedLogo(size: size),
    );
  }
}

class QuickPill extends StatelessWidget {
  const QuickPill({
    super.key,
    required this.label,
    required this.icon,
    this.selected = false,
    this.onTap,
  });

  final String label;
  final IconData icon;
  final bool selected;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: CustomCard(
        borderRadius: 16,
        padding: const EdgeInsets.all(12),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(
              icon,
              color: selected ? AppColors.accentSoft : AppColors.textMuted,
              size: 28,
            ),
            const SizedBox(height: 8),
            Text(
              label,
              style: TextStyle(
                color: selected
                    ? AppColors.textPrimary
                    : AppColors.textSecondary,
                fontSize: 12,
                fontWeight: selected ? FontWeight.w700 : FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
