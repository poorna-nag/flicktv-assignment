import 'package:poornima/core/constants/app_colors.dart';
import 'package:poornima/core/constants/app_strings.dart';
import 'package:flutter/material.dart';

class AddMoneyButton extends StatelessWidget {
  const AddMoneyButton({super.key});

  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;
    final double buttonHeight = screenHeight < 750 ? 44 : (screenHeight < 820 ? 48 : 52);
    final double fontSize = screenHeight < 750 ? 15 : (screenHeight < 820 ? 17 : 18.5);

    return Container(
      height: buttonHeight,
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.accentBright,
        borderRadius: BorderRadius.circular(15),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.18),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(4),
          onTap: () {},
          child: Center(
            child: Text(
              AppStrings.addMoney,
              style: TextStyle(
                color: Colors.white,
                fontSize: fontSize,
                fontWeight: FontWeight.w800,
                letterSpacing: -0.2,
              ),
            ),
          ),
        ),
      ),
    );
  }
}