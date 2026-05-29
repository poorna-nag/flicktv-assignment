import 'package:poornima/core/constants/app_colors.dart';
import 'package:poornima/core/constants/app_strings.dart';
import 'package:flutter/material.dart';

class MoneyWordmark extends StatelessWidget {
  const MoneyWordmark({super.key, this.fontSize = 48});

  final double fontSize;

  @override
  Widget build(BuildContext context) {
    return Text(
      AppStrings.money,
      textAlign: TextAlign.center,
      style: TextStyle(
        color: AppColors.textPrimary,
        fontSize: fontSize,
        fontWeight: FontWeight.w900,
        height: 0.95,
        letterSpacing: 4,
      ),
    );
  }
}
