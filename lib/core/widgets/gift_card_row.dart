import 'package:flicktv_yourname/core/constants/app_colors.dart';
import 'package:flicktv_yourname/core/constants/app_strings.dart';
import 'package:flicktv_yourname/core/widgets/dark_panel.dart';
import 'package:flutter/material.dart';

class GiftCardRow extends StatelessWidget {
  const GiftCardRow({super.key});

  @override
  Widget build(BuildContext context) {
    return DarkPanel(
      borderRadius: 24,
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
      child: Row(
        children: <Widget>[
          Container(
            width: 46,
            height: 40,
            decoration: BoxDecoration(
              color: const Color(0xFF1F1F1F),
              borderRadius: BorderRadius.circular(15),
            ),
            child: const Icon(
              Icons.card_giftcard_rounded,
              color: AppColors.gold,
            ),
          ),
          const SizedBox(width: 14),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  AppStrings.claimGiftCard,
                  style: TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  AppStrings.claimGiftCardSubtitle,
                  style: TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 12,
                    height: 1.35,
                  ),
                ),
              ],
            ),
          ),
          const Icon(Icons.chevron_right_rounded, color: AppColors.textMuted),
        ],
      ),
    );
  }
}
