import 'package:poornima/core/constants/app_colors.dart';
import 'package:poornima/core/widgets/dark_panel.dart';
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
        return Image.asset('assets/images/tap.png', fit: BoxFit.cover);
      case 1:
        return Image.asset('assets/images/wifi.png', fit: BoxFit.cover);
      case 2:
      default:
        return Image.asset('assets/images/money.png', fit: BoxFit.cover);
    }
  }

  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;
    final double cardPadding = screenHeight < 750 ? 10 : (screenHeight < 820 ? 12 : 14);
    final double iconContainerSize = screenHeight < 750 ? 40 : (screenHeight < 820 ? 45 : 50);
    final double titleFontSize = screenHeight < 750 ? 13 : (screenHeight < 820 ? 14.5 : 16);
    final double subtitleFontSize = screenHeight < 750 ? 10.5 : (screenHeight < 820 ? 11.5 : 12.5);

    return Opacity(
      opacity: opacity.clamp(0.0, 1.0),
      child: Transform.translate(
        offset: Offset(0, offsetY),
        child: DarkPanel(
          borderRadius: screenHeight < 750 ? 18 : 24,
          padding: EdgeInsets.all(cardPadding),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                width: iconContainerSize,
                height: iconContainerSize,
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(screenHeight < 750 ? 12 : 16),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(screenHeight < 750 ? 12 : 16),
                  child: _buildIcon(),
                ),
              ),
              SizedBox(width: screenHeight < 720 ? 10 : 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      title,
                      style: TextStyle(
                        color: AppColors.textPrimary,
                        fontSize: titleFontSize,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    SizedBox(height: screenHeight < 720 ? 3 : 5),
                    Text(
                      subtitle,
                      style: TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: subtitleFontSize,
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
