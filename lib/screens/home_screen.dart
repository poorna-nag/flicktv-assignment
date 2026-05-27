import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../core/constants/app_colors.dart';
import '../core/constants/app_dimensions.dart';
import '../core/constants/app_strings.dart';
import '../core/widgets/app_background.dart';
import '../widgets/reusable_widgets.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _fadeAnimation;
  late final Animation<Offset> _slideAnimation;
  int _selectedBenefit = 0;
  int _selectedShortcut = -1;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..forward();
    final Animation<double> curved = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutCubic,
    );
    _fadeAnimation = curved;
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 1),
      end: Offset.zero,
    ).animate(curved);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _showActionSheet(
    BuildContext context, {
    required String title,
    required String subtitle,
  }) {
    HapticFeedback.lightImpact();
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: CustomCard(
              borderRadius: 28,
              // color: const Color(0xFF1F2024),
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Center(
                    child: Container(
                      width: 56,
                      height: 5,
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(99),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    title,
                    style: const TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 24,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 14.5,
                      height: 1.45,
                    ),
                  ),
                  const SizedBox(height: 18),
                  CustomCard(
                    // color: AppColors.surfaceMuted,
                    borderRadius: 20,
                    child: Row(
                      children: const <Widget>[
                        Icon(Icons.bolt_rounded, color: AppColors.accentSoft),
                        SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            'Fast and polished interaction',
                            style: TextStyle(
                              color: AppColors.textPrimary,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 14),
                  CustomButton(
                    label: 'Understood',
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final List<Map<String, Object>> benefits = <Map<String, Object>>[
      <String, Object>{
        'icon': Icons.flash_on_rounded,
        'title': AppStrings.singleTapPayments,
        'description': AppStrings.singleTapDescription,
        'accent': AppColors.accentSoft,
      },
      <String, Object>{
        'icon': Icons.verified_rounded,
        'title': AppStrings.zeroFailures,
        'description': AppStrings.zeroFailuresDescription,
        'accent': AppColors.blue,
      },
      <String, Object>{
        'icon': Icons.currency_rupee_rounded,
        'title': AppStrings.realTimeRefunds,
        'description': AppStrings.realTimeRefundsDescription,
        'accent': AppColors.gold,
      },
    ];

    final List<Map<String, Object>> quickShortcuts = <Map<String, Object>>[
      <String, Object>{'label': 'Rewards', 'icon': Icons.card_giftcard_rounded},
      <String, Object>{'label': 'Safety', 'icon': Icons.shield_rounded},
      <String, Object>{'label': 'Support', 'icon': Icons.support_agent_rounded},
      <String, Object>{
        'label': 'Wallet',
        'icon': Icons.account_balance_wallet_rounded,
      },
    ];

    return Scaffold(
      body: AppBackground(
        showConfetti: true,
        child: SafeArea(
          bottom: false,
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(
                maxWidth: AppDimensions.contentMaxWidth,
              ),
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.fromLTRB(
                  AppDimensions.screenPadding,
                  8,
                  AppDimensions.screenPadding,
                  28,
                ),
                child: FadeTransition(
                  opacity: _fadeAnimation,
                  child: SlideTransition(
                    position: _slideAnimation,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        Align(
                          alignment: Alignment.centerRight,
                          child: SizedBox(
                            width: 54,
                            height: 54,
                            child: CustomCard(
                              borderRadius: 100,
                              padding: EdgeInsets.zero,
                              child: const Center(
                                child: Icon(
                                  Icons.settings,
                                  color: Colors.white,
                                  size: 26,
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 22),
                        Center(
                          child: Transform.scale(
                            scale:
                                1 +
                                math.sin(_controller.value * math.pi) * 0.015,
                            child: const BrandHeroBadge(size: 154),
                          ),
                        ),
                        const SizedBox(height: 22),
                        const Center(
                          child: Text(
                            AppStrings.brand,
                            style: TextStyle(
                              color: AppColors.textPrimary,
                              fontSize: 25,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 2.2,
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        const Center(
                          child: Text(
                            AppStrings.money,
                            style: TextStyle(
                              color: AppColors.textPrimary,
                              fontSize: 54,
                              fontWeight: FontWeight.w900,
                              height: 0.95,
                              letterSpacing: -1.8,
                            ),
                          ),
                        ),
                        const SizedBox(height: 14),
                        const Text(
                          AppStrings.enjoySeamless,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: AppColors.textPrimary,
                            fontSize: 20,
                            fontWeight: FontWeight.w800,
                            height: 1.25,
                          ),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'Zero payment failures, instant refunds, and a fast lane to pay, claim, and manage every wallet action.',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: AppColors.textSecondary,
                            fontSize: 14.5,
                            height: 1.45,
                          ),
                        ),
                        const SizedBox(height: 22),
                        for (
                          int index = 0;
                          index < benefits.length;
                          index++
                        ) ...<Widget>[
                          BenefitTile(
                            icon: benefits[index]['icon']! as IconData,
                            title: benefits[index]['title']! as String,
                            description:
                                benefits[index]['description']! as String,
                            accentColor: benefits[index]['accent']! as Color,
                            selected: _selectedBenefit == index,
                            onTap: () {
                              setState(() => _selectedBenefit = index);
                              HapticFeedback.selectionClick();
                            },
                          ),
                          if (index != benefits.length - 1)
                            const SizedBox(height: 12),
                        ],
                        const SizedBox(height: 18),
                        CustomButton(
                          label: AppStrings.addMoney,
                          icon: Icons.add_rounded,
                          onPressed: () => _showActionSheet(
                            context,
                            title: 'Add money instantly',
                            subtitle:
                                'This reference screen keeps the interaction lightweight. A full payment flow can be plugged in later.',
                          ),
                        ),
                        const SizedBox(height: 12),
                        CustomCard(
                          borderRadius: 24,
                          // color: AppColors.surfaceElevated,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 18,
                            vertical: 16,
                          ),
                          child: Row(
                            children: const <Widget>[
                              _GiftCardIcon(),
                              SizedBox(width: 14),
                              Expanded(
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
                                        fontSize: 12.5,
                                        height: 1.35,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Icon(
                                Icons.chevron_right_rounded,
                                color: AppColors.textMuted,
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 14),
                        GridView.builder(
                          itemCount: quickShortcuts.length,
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                mainAxisExtent: 92,
                                crossAxisSpacing: 12,
                                mainAxisSpacing: 12,
                              ),
                          itemBuilder: (BuildContext context, int index) {
                            final Map<String, Object> item =
                                quickShortcuts[index];
                            final bool selected = _selectedShortcut == index;
                            return QuickPill(
                              label: item['label']! as String,
                              icon: item['icon']! as IconData,
                              selected: selected,
                              onTap: () {
                                setState(() => _selectedShortcut = index);
                                HapticFeedback.selectionClick();
                              },
                            );
                          },
                        ),
                        const SizedBox(height: 20),
                        CustomCard(
                          borderRadius: 24,
                          // color: const Color(0xFF202127),
                          padding: const EdgeInsets.all(20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: const <Widget>[
                              Text(
                                'Built for instant action',
                                style: TextStyle(
                                  color: AppColors.textPrimary,
                                  fontSize: 24,
                                  fontWeight: FontWeight.w900,
                                ),
                              ),
                              SizedBox(height: 10),
                              Text(
                                'Tap the green action bar to top up instantly or use the gift card panel to open the secondary flow. Everything stays within one polished screen.',
                                style: TextStyle(
                                  color: AppColors.textSecondary,
                                  fontSize: 14,
                                  height: 1.45,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 34),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _GiftCardIcon extends StatelessWidget {
  const _GiftCardIcon();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 46,
      height: 46,
      decoration: BoxDecoration(
        color: AppColors.surfaceMuted,
        borderRadius: BorderRadius.circular(15),
      ),
      child: const Icon(Icons.card_giftcard_rounded, color: AppColors.gold),
    );
  }
}
