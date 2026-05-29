import 'package:flicktv_yourname/core/utils/feature_card.dart';
import 'package:flicktv_yourname/core/widgets/add_money_button.dart';
import 'package:flicktv_yourname/core/widgets/gift_card_row.dart';
import 'package:flicktv_yourname/core/widgets/money_word_mark.dart'
    show MoneyWordmark;
import 'package:flicktv_yourname/core/widgets/top_Icon_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../core/constants/app_colors.dart';
import '../core/constants/app_dimensions.dart';
import '../core/constants/app_strings.dart';
import '../core/utils/home_animations.dart';
import '../core/widgets/app_background.dart';
import '../core/widgets/app_tilted_logo.dart';

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
        // Calculate centerY dynamically so the wallet column is vertically centered on any device
        // back button top padding (36) + row height (54) = 90. Column height is ~224. Half column is 112.
        // target centerY pushes layout down: screenHeight/2 - 90 - 112 = screenHeight/2 - 202.
        _animations.centerY = (screenHeight / 2 - 202).clamp(110.0, 500.0);
        final double travelProgress = ((_animations.centerY - _animations.walletTravelY) / (_animations.centerY - 10.0)).clamp(0.0, 1.0);
        return Scaffold(
          body: AppBackground(
            showConfetti: true,
            introProgress: _animations.backgroundReveal,
            walletTravelProgress: travelProgress,
            child: SafeArea(
              top: false,
              bottom: false,
              child: Stack(
                children: <Widget>[
                  SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.fromLTRB(
                      AppDimensions.screenPadding,
                      55,
                      AppDimensions.screenPadding,
                      120,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            TopIconButton(
                              icon: Icons.arrow_back_ios_new,
                              onTap: _closeScreen,
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
                                      child: const AppTiltedLogo(size: 136),
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
                                child: const Text(
                                  AppStrings.brand,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: AppColors.textPrimary,
                                    fontSize: 26,
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
                                child: const MoneyWordmark(),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
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
                            const SizedBox(height: 8),
                        ],
                        const SizedBox(height: 12),
                        _reveal(
                          opacity: _animations.chromeOpacity,
                          scale: _animations.chromeScale,
                          child: AddMoneyButton(),
                        ),
                        const SizedBox(height: 14),
                        _reveal(
                          opacity: _animations.chromeOpacity,
                          scale: _animations.chromeScale,
                          child: const GiftCardRow(),
                        ),
                        const SizedBox(height: 16),
                        _reveal(
                          opacity: _animations.chromeOpacity * 0.85,
                          scale: _animations.chromeScale,
                          child: const IgnorePointer(
                            child: Text(
                              AppStrings.enjoySeamless,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.white12,
                                fontSize: 34,
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
