import 'package:poornima/core/utils/feature_card.dart';
import 'package:poornima/core/widgets/add_money_button.dart';
import 'package:poornima/core/widgets/gift_card_row.dart';
import 'package:poornima/core/widgets/money_word_mark.dart' show MoneyWordmark;
import 'package:poornima/core/widgets/top_icon_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:poornima/core/constants/app_colors.dart';
import 'package:poornima/core/constants/app_dimensions.dart';
import 'package:poornima/core/constants/app_strings.dart';
import 'package:poornima/core/utils/home_animations.dart';
import 'package:poornima/core/utils/responsive_helper.dart';
import 'package:poornima/core/widgets/app_background.dart';
import 'package:poornima/core/widgets/app_tilted_logo.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  late final HomeScreenAnimations _animations;

  @override
  void initState() {
    super.initState();
    _animations = HomeScreenAnimations(this)..start();
  }

  @override
  void dispose() {
    _animations.dispose();
    super.dispose();
  }

  void _closeScreen() {
    HapticFeedback.lightImpact();
    Navigator.maybePop(context);
  }

  Widget _reveal({
    required Widget child,
    required double opacity,
    double scale = 1.0,
    double offsetY = 0.0,
  }) {
    return Opacity(
      opacity: opacity.clamp(0.0, 1.0),
      child: Transform.translate(
        offset: Offset(0, offsetY),
        child: Transform.scale(scale: scale, child: child),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final List<_FeatureSpec> features = <_FeatureSpec>[
      const _FeatureSpec(
        title: AppStrings.singleTapPayments,
        subtitle: AppStrings.singleTapDescription,
      ),
      const _FeatureSpec(
        title: AppStrings.zeroFailures,
        subtitle: AppStrings.zeroFailuresDescription,
      ),
      const _FeatureSpec(
        title: AppStrings.realTimeRefunds,
        subtitle: AppStrings.realTimeRefundsDescription,
      ),
    ];

    return AnimatedBuilder(
      animation: Listenable.merge(<Listenable>[
        _animations.controller,
        _animations.bobController,
      ]),
      builder: (BuildContext context, Widget? _) {
        final double screenHeight = MediaQuery.of(context).size.height;
        _animations.centerY = (screenHeight / 2 - 202).clamp(110.0, 500.0);
        final double travelProgress =
            ((_animations.centerY - _animations.walletTravelY) /
                    (_animations.centerY - 10.0))
                .clamp(0.0, 1.0);

        final double topPadding = context.responsive(36, 48, 60);
        final double bottomPadding = context.responsive(15, 25, 45);
        final double logoSize = context.responsive(95, 110, 130);
        final double brandFontSize = context.responsive(18, 21, 24);
        final double moneyFontSize = context.responsive(34, 40, 46);
        final double enjoySeamlessFontSize = context.responsive(22, 23, 26);

        return Scaffold(
          body: AppBackground(
            showConfetti:
                _animations.controller.value >=
                _animations.confettiTriggerProgress,
            introProgress: _animations.backgroundReveal,
            walletTravelProgress: travelProgress,
            child: SafeArea(
              top: false,
              bottom: false,
              child: Stack(
                children: <Widget>[
                  SingleChildScrollView(
                    physics: const NeverScrollableScrollPhysics(),
                    padding: EdgeInsets.fromLTRB(
                      AppDimensions.screenPadding,
                      topPadding,
                      AppDimensions.screenPadding,
                      bottomPadding,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            _reveal(
                              opacity: _animations.settingsOpacity,
                              scale: _animations.settingsScale,
                              child: TopIconButton(
                                icon: Icons.arrow_back_ios_new,
                                onTap: _closeScreen,
                              ),
                            ),
                            _reveal(
                              opacity: _animations.settingsOpacity,
                              scale: _animations.settingsScale,
                              child: const TopIconButton(
                                icon: Icons.settings_outlined,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: _animations.walletTravelY),
                        Column(
                          children: <Widget>[
                            Center(
                              child: Transform.translate(
                                offset: Offset(0, _animations.walletBobOffset),
                                child: Transform.rotate(
                                  angle: _animations.walletWobbleRotation,
                                  child: Transform.scale(
                                    scale: _animations.walletScale,
                                    child: Opacity(
                                      opacity: _animations.walletOpacity,
                                      child: AppTiltedLogo(size: logoSize),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 6),
                            Center(
                              child: _reveal(
                                opacity: _animations.wordmarkOpacity,
                                offsetY: _animations.wordmarkLift,
                                child: Text(
                                  AppStrings.brand,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: AppColors.textPrimary,
                                    fontSize: brandFontSize,
                                    fontWeight: FontWeight.w800,
                                    letterSpacing: 0.5,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 2),
                            Center(
                              child: _reveal(
                                opacity: _animations.moneyOpacity,
                                scale: _animations.moneyScale,
                                offsetY: _animations.moneyLift,
                                child: MoneyWordmark(fontSize: moneyFontSize),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: context.responsive(4, 6, 8)),
                        for (
                          int index = 0;
                          index < features.length;
                          index++
                        ) ...<Widget>[
                          FeatureCard(
                            title: features[index].title,
                            subtitle: features[index].subtitle,
                            opacity: _animations.cardOpacity(index),
                            offsetY: _animations.cardLift(index),
                            index: index,
                          ),
                          if (index != features.length - 1)
                            SizedBox(height: context.responsive(4, 5, 6)),
                        ],
                        SizedBox(height: context.responsive(6, 8, 10)),
                        _reveal(
                          opacity: _animations.chromeOpacity,
                          scale: _animations.chromeScale,
                          child: AddMoneyButton(),
                        ),
                        SizedBox(height: context.responsive(12, 15, 18)),
                        _reveal(
                          opacity: _animations.chromeOpacity,
                          scale: _animations.chromeScale,
                          child: const GiftCardRow(),
                        ),
                        SizedBox(height: context.responsive(6, 8, 12)),
                        _reveal(
                          opacity: _animations.chromeOpacity * 0.85,
                          scale: _animations.chromeScale,
                          child: IgnorePointer(
                            child: Text(
                              AppStrings.enjoySeamless,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.white12,
                                fontSize: enjoySeamlessFontSize,
                                fontWeight: FontWeight.w900,
                                height: 0.9,
                                letterSpacing: 2,
                              ),
                            ),
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
      },
    );
  }
}

class _FeatureSpec {
  const _FeatureSpec({required this.title, required this.subtitle});

  final String title;
  final String subtitle;
}
