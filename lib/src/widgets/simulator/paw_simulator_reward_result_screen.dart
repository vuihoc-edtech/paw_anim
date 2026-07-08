import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:paw_anim/paw_anim.dart';

class PawSimulatorRewardResultScreen extends StatefulWidget {
  final int awardedPoints;
  final int finalBalance;
  final VoidCallback onClose;

  final Widget background;
  final Widget mascot;
  final Widget title;
  final Widget subtitle;

  final Widget statColumn1;
  final Widget statColumn2;

  final Widget rewardLabel;
  final TextStyle rewardValueStyle;

  final VoidCallback? onAnimationComplete;

  const PawSimulatorRewardResultScreen({
    required this.awardedPoints,
    required this.finalBalance,
    required this.onClose,
    required this.background,
    required this.mascot,
    required this.title,
    required this.subtitle,
    required this.statColumn1,
    required this.statColumn2,
    required this.rewardLabel,
    required this.rewardValueStyle,
    this.onAnimationComplete,
    super.key,
  });

  @override
  State<PawSimulatorRewardResultScreen> createState() =>
      _PawSimulatorRewardResultScreenState();
}

class _PawSimulatorRewardResultScreenState
    extends State<PawSimulatorRewardResultScreen>
    with TickerProviderStateMixin {
  late final SimulatorRewardController controller;

  @override
  void initState() {
    super.initState();
    controller = SimulatorRewardController(
      awardedPoints: widget.awardedPoints,
      finalBalance: widget.finalBalance,
      time: 0,
      vsync: this,
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        controller.calculateOffsets();
      }
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox.expand(
        key: controller.rootKey,
        child: Stack(
          children: [
            Positioned.fill(
              child: widget.background,
            ),
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  children: [
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        GestureDetector(
                          onTap: widget.onClose,
                          child: const Icon(
                            Icons.close,
                            color: Colors.white,
                            size: 28,
                          ),
                        ),
                        ListenableBuilder(
                          listenable: controller,
                          builder: (context, _) => DesignBadge(
                            badgeKey: controller.badgeKey,
                            value: controller.displayedPoints.toPawFormat(),
                            phase: controller.rewardPhase,
                            type: LoyaltyWidgetType.simulatorExercise,
                          ),
                        ),
                      ],
                    ),
                    const Spacer(flex: 2),
                    FadeTransition(
                      opacity: controller.mascotOpacity,
                      child: ScaleTransition(
                        scale: controller.mascotScale,
                        child: Container(
                          key: controller.mascotKey,
                          child: widget.mascot,
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    FadeTransition(
                      opacity: controller.contentOpacity,
                      child: SlideTransition(
                        position: controller.contentSlide,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            widget.title,
                            const SizedBox(height: 12),
                            widget.subtitle,
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 32),
                    FadeTransition(
                      opacity: controller.cardOpacity,
                      child: ScaleTransition(
                        scale: controller.cardScale,
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 24),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.12),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: Colors.white.withValues(alpha: 0.2),
                              width: 1.5,
                            ),
                          ),
                          child: Row(
                            children: [
                              Expanded(child: widget.statColumn1),
                              Container(
                                height: 36,
                                width: 1,
                                color: Colors.white.withValues(alpha: 0.2),
                              ),
                              Expanded(child: widget.statColumn2),
                              Container(
                                height: 36,
                                width: 1,
                                color: Colors.white.withValues(alpha: 0.2),
                              ),
                              Expanded(
                                child: AnimatedBuilder(
                                  animation: controller.wiggleController,
                                  builder: (context, child) {
                                    return Transform(
                                      alignment: Alignment.center,
                                      transform: Matrix4.identity()
                                        ..scale(controller.wiggleScale.value, controller.wiggleScale.value)
                                        ..rotateZ(
                                          controller.wiggleRotation.value,
                                        ),
                                      child: child,
                                    );
                                  },
                                  child: Column(
                                    children: [
                                      widget.rewardLabel,
                                      const SizedBox(height: 8),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Container(
                                            key: controller.rewardKey,
                                            child: SvgPicture.asset(
                                              'assets/cat_paws.svg',
                                              package: 'paw_anim',
                                              width: 24,
                                              height: 24,
                                            ),
                                          ),
                                          const SizedBox(width: 6),
                                          Text(
                                            '${widget.awardedPoints}',
                                            style: widget.rewardValueStyle,
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const Spacer(flex: 3),
                  ],
                ),
              ),
            ),
            ListenableBuilder(
              listenable: controller,
              builder: (context, _) {
                if (!controller.isLayoutReady) {
                  return const SizedBox.shrink();
                }
                return Positioned.fill(
                  child: SimulatorRewardEffectsOverlay(
                    awardedPoints: widget.awardedPoints,
                    balanceAfter: widget.finalBalance,
                    startOffset: controller.startOffset,
                    targetOffset: controller.targetOffset,
                    mascotTopLeft: controller.mascotTopLeft,
                    showBadgeOverlay: false,
                    onCompleted: () {
                      widget.onAnimationComplete?.call();
                    },
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
