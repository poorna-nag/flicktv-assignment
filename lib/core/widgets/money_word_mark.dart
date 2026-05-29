import 'package:flicktv_yourname/core/constants/app_colors.dart';
import 'package:flicktv_yourname/core/constants/app_strings.dart';
import 'package:flutter/material.dart';

class MoneyWordmark extends StatelessWidget {
  const MoneyWordmark({super.key});

  @override
  Widget build(BuildContext context) {
    return const Text(
      AppStrings.money,
      textAlign: TextAlign.center,
      style: TextStyle(
        color: AppColors.textPrimary,
        fontSize: 48,
        fontWeight: FontWeight.w900,
        height: 0.95,
        letterSpacing: 4,
      ),
    );
  }
}
