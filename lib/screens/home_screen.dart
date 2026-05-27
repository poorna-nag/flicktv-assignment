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
        return Scaffold(
          body: AppBackground(
            showConfetti: true,
            introProgress: _animations.backgroundReveal,
            child: SafeArea(
              bottom: false,
              child: Stack(
                children: <Widget>[
                  SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.fromLTRB(
                      AppDimensions.screenPadding,
                      8,
                      AppDimensions.screenPadding,
                      220,
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
                        const SizedBox(height: 22),
                        Center(
                          child: Transform.translate(
                            offset: Offset(
                              0,
                              _animations.walletTravelY +
                                  _animations.walletBobOffset,
                            ),
                            child: Transform.rotate(
                              angle: _animations.walletWobbleRotation,
                              child: Transform.scale(
                                scale: _animations.walletScale,
                                child: Opacity(
                                  opacity: _animations.walletOpacity,
                                  child: const AppTiltedLogo(size: 122),
                                ),
                              ),
                            ),
                          ),
                        ),
                        // const SizedBox(height: 6),
                        Center(
                          child: _reveal(
                            opacity: _animations.wordmarkOpacity,
                            offsetY: _animations.wordmarkLift,
                            child: const Text(
                              AppStrings.brand,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: AppColors.textPrimary,
                                fontSize: 32,
                                fontWeight: FontWeight.w800,
                                letterSpacing: 0.2,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Center(
                          child: _reveal(
                            opacity: _animations.moneyOpacity,
                            scale: _animations.moneyScale,
                            offsetY: _animations.moneyLift,
                            child: const _MoneyWordmark(),
                          ),
                        ),
                        const SizedBox(height: 12),
                        for (
                          int index = 0;
                          index < features.length;
                          index++
                        ) ...<Widget>[
                          _FeatureCard(
                            title: features[index].title,
                            subtitle: features[index].subtitle,
                            opacity: _animations.cardOpacity(index),
                            offsetY: _animations.cardLift(index),
                          ),
                          if (index != features.length - 1)
                            const SizedBox(height: 12),
                        ],
                        const SizedBox(height: 12),
                        _reveal(
                          opacity: _animations.chromeOpacity,
                          scale: _animations.chromeScale,
                          child: _AddMoneyButton(),
                        ),
                        const SizedBox(height: 12),
                        _reveal(
                          opacity: _animations.chromeOpacity,
                          scale: _animations.chromeScale,
                          child: const _GiftCardRow(),
                        ),
                        const SizedBox(height: 20),
                        _reveal(
                          opacity: _animations.chromeOpacity * 0.85,
                          scale: _animations.chromeScale,
                          child: const IgnorePointer(
                            child: Text(
                              AppStrings.enjoySeamless,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.white24,
                                fontSize: 30,
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

class _MoneyWordmark extends StatelessWidget {
  const _MoneyWordmark();

  @override
  Widget build(BuildContext context) {
    return const Text(
      AppStrings.money,
      textAlign: TextAlign.center,
      style: TextStyle(
        color: AppColors.textPrimary,
        fontSize: 58,
        fontWeight: FontWeight.w900,
        height: 0.95,
        letterSpacing: 2,
      ),
    );
  }
}

class _FeatureCard extends StatelessWidget {
  const _FeatureCard({
    required this.title,
    required this.subtitle,
    required this.opacity,
    required this.offsetY,
  });

  final String title;
  final String subtitle;
  final double opacity;
  final double offsetY;

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: opacity.clamp(0.0, 1.0),
      child: Transform.translate(
        offset: Offset(0, offsetY),
        child: _DarkPanel(
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
                child: const Icon(
                  Icons.phone_iphone_rounded,
                  color: AppColors.gold,
                  size: 27,
                ),
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

class _AddMoneyButton extends StatelessWidget {
  const _AddMoneyButton();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 54,
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
          child: const Center(
            child: Text(
              AppStrings.addMoney,
              style: TextStyle(
                color: Colors.white,
                fontSize: 19,
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

class _GiftCardRow extends StatelessWidget {
  const _GiftCardRow();

  @override
  Widget build(BuildContext context) {
    return _DarkPanel(
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

class _DarkPanel extends StatelessWidget {
  const _DarkPanel({
    required this.child,
    this.padding = const EdgeInsets.all(18),
    this.borderRadius = 24,
  });

  final Widget child;
  final EdgeInsetsGeometry padding;
  final double borderRadius;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      decoration: BoxDecoration(
        color: const Color(0xFF2A2A2A),
        borderRadius: BorderRadius.circular(borderRadius),
        border: Border.all(color: Colors.white.withValues(alpha: 0.06)),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.24),
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: child,
    );
  }
}
