import 'package:poornima/core/constants/app_colors.dart';
import 'package:poornima/core/constants/app_strings.dart';
import 'package:poornima/core/widgets/dark_panel.dart';
import 'package:flutter/material.dart';

class GiftCardRow extends StatelessWidget {
  const GiftCardRow({super.key});

  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;
    final double paddingVertical = screenHeight < 750 ? 4 : (screenHeight < 820 ? 5 : 6);
    final double iconContainerSize = screenHeight < 750 ? 36 : (screenHeight < 820 ? 40 : 44);
    final double titleFontSize = screenHeight < 750 ? 13 : (screenHeight < 820 ? 14.5 : 16);
    final double subtitleFontSize = screenHeight < 750 ? 9.5 : (screenHeight < 820 ? 10.5 : 11.5);

    return DarkPanel(
      borderRadius: 10,
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: paddingVertical),
      child: Row(
        children: <Widget>[
          SizedBox(
            width: iconContainerSize,
            height: iconContainerSize,
            child: FittedBox(
              fit: BoxFit.scaleDown,
              child: const SizedBox(
                width: 48,
                height: 48,
                child: _GiftCardIcon(),
              ),
            ),
          ),
          SizedBox(width: screenHeight < 720 ? 10 : 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  AppStrings.claimGiftCard,
                  style: TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: titleFontSize,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                SizedBox(height: screenHeight < 720 ? 2 : 4),
                Text(
                  AppStrings.claimGiftCardSubtitle,
                  style: TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: subtitleFontSize,
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

class _GiftCardIcon extends StatelessWidget {
  const _GiftCardIcon();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 48,
      height: 48,
      decoration: BoxDecoration(
        color: const Color(0xFF634604),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Center(
        child: SizedBox(
          width: 38,
          height: 38,
          child: Stack(
            clipBehavior: Clip.none,
            alignment: Alignment.center,
            children: <Widget>[
              // Green Card behind
              Positioned(
                bottom: 5,
                left: 3,
                child: Transform.rotate(
                  angle: 0.12,
                  child: Container(
                    width: 25,
                    height: 15,
                    decoration: BoxDecoration(
                      color: const Color(0xFF2B7D18),
                      borderRadius: BorderRadius.circular(2.5),
                      boxShadow: const <BoxShadow>[
                        BoxShadow(
                          color: Colors.black26,
                          blurRadius: 1,
                          offset: Offset(0, 1),
                        ),
                      ],
                    ),
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: Container(
                        width: 4,
                        margin: const EdgeInsets.only(right: 3),
                        color: Colors.white24,
                      ),
                    ),
                  ),
                ),
              ),
              // Gold Card in front
              Positioned(
                top: 5,
                right: 1,
                child: Transform.rotate(
                  angle: -0.22,
                  child: Container(
                    width: 28,
                    height: 17,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: <Color>[
                          Color(0xFFFFF2C2),
                          Color(0xFFE5B55F),
                          Color(0xFFB58028),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(3),
                      boxShadow: const <BoxShadow>[
                        BoxShadow(
                          color: Colors.black38,
                          blurRadius: 2,
                          offset: Offset(0, 1.5),
                        ),
                      ],
                    ),
                    child: Stack(
                      alignment: Alignment.center,
                      children: <Widget>[
                        // Ribbon line vertical
                        Positioned(
                          left: 8,
                          top: 0,
                          bottom: 0,
                          child: Container(
                            width: 2.2,
                            color: const Color(0xFF503503),
                          ),
                        ),
                        // Ribbon line horizontal
                        Positioned(
                          left: 0,
                          right: 0,
                          top: 7,
                          child: Container(
                            height: 2.2,
                            color: const Color(0xFF503503),
                          ),
                        ),
                        // The Bow
                        const Center(
                          child: Icon(
                            Icons.filter_vintage_rounded,
                            size: 10,
                            color: Color(0xFF503503),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
