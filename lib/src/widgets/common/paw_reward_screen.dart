import 'dart:async';

import 'package:flutter/material.dart';
import '../../enums/paw_enums.dart';
import '../../colors/paw_colors.dart';
import '../../utils/paw_format.dart';
import 'paw_reward_controller.dart';
import 'confetti_painter.dart';
import 'design_badge.dart';
import 'glow_ring.dart';
import 'big_paw.dart';
import 'count_up_text.dart';

// Màn hình 2: Hiệu ứng pháo hoa, đếm điểm tăng dần và bay hạt chân mèo con
class PawRewardScreen extends StatefulWidget {
  final PawRewardController controller;
  final int awardedPoints;
  final Offset? flyTargetOffset;
  final VoidCallback onDone;
  final Function(Offset from, Offset to) onStartFly;
  final Color? primaryColor;

  const PawRewardScreen({
    required this.controller,
    required this.awardedPoints,
    required this.onDone,
    required this.onStartFly,
    this.primaryColor,
    super.key,
    this.flyTargetOffset,
  });

  @override
  State<PawRewardScreen> createState() => PawRewardScreenState();
}

class PawRewardScreenState extends State<PawRewardScreen> {
  final GlobalKey _badgeKey = GlobalKey();
  final GlobalKey _pawKey = GlobalKey();

  late Timer _tFly;
  late Timer _tLand;
  late Timer _tDone;
  late Timer _tLoop;

  static const int countStart = 600;
  static const int countDur = 1800;
  static const int flyAt = countStart + countDur + 1600;
  static const int landAt = flyAt + 1800;

  @override
  void initState() {
    super.initState();

    _tFly = Timer(const Duration(milliseconds: flyAt), _triggerFlight);

    _tLand = Timer(const Duration(milliseconds: landAt), () {
      widget.controller.setPhase(RewardPhase.flash);
    });

    _tDone = Timer(const Duration(milliseconds: landAt + 600), () {
      widget.controller.setPhase(RewardPhase.done);
    });

    _tLoop = Timer(const Duration(milliseconds: landAt + 1800), () {
      widget.onDone();
    });
  }

  void _triggerFlight() {
    if (!mounted) return;

    Offset relativeFrom = const Offset(200, 350);
    Offset relativeTo = widget.flyTargetOffset ?? const Offset(340, 38);

    final RenderBox? badgeBox =
        _badgeKey.currentContext?.findRenderObject() as RenderBox?;
    final RenderBox? pawBox =
        _pawKey.currentContext?.findRenderObject() as RenderBox?;
    final RenderBox? shellBox = context.findRenderObject() as RenderBox?;

    if (shellBox != null) {
      final shellOffset = shellBox.localToGlobal(Offset.zero);
      final size = shellBox.size;

      relativeFrom = Offset(size.width / 2.0, size.height / 2.0 - 20.0);
      relativeTo = widget.flyTargetOffset ?? Offset(size.width - 60.0, 38);

      if (badgeBox != null && pawBox != null) {
        final badgeOffset = badgeBox.localToGlobal(Offset.zero);
        final pawOffset = pawBox.localToGlobal(Offset.zero);

        final badgeCenter =
            badgeOffset +
            Offset(badgeBox.size.width / 2.0, badgeBox.size.height / 2.0);
        final pawCenter =
            pawOffset +
            Offset(pawBox.size.width / 2.0, pawBox.size.height / 2.0);

        relativeFrom = pawCenter - shellOffset;
        relativeTo = widget.flyTargetOffset ?? (badgeCenter - shellOffset);
      }
    }

    widget.onStartFly(relativeFrom, relativeTo);
    widget.controller.triggerFlight(relativeFrom, relativeTo);
  }

  @override
  void dispose() {
    _tFly.cancel();
    _tLand.cancel();
    _tDone.cancel();
    _tLoop.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: widget.controller,
      builder: (context, child) {
        final phase = widget.controller.rewardPhase;

        final hidePawAndCounter =
            phase == RewardPhase.fly ||
            phase == RewardPhase.flash ||
            phase == RewardPhase.done;

        final isTablet = MediaQuery.of(context).size.shortestSide >= 600;
        final double pawSize = isTablet ? 160.0 : 128.0;
        final double outerGlowSize = isTablet ? 270.0 : 216.0;
        final double innerGlowSize = isTablet ? 215.0 : 172.0;

        return Scaffold(
          backgroundColor: Colors.transparent,
          body: Stack(
          children: [
            const Positioned.fill(child: FallingConfetti(count: 65)),

            SafeArea(
              bottom: false,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(
                      left: 16,
                      right: 16,
                      top: 14,
                      bottom: 14,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        DesignBadge(
                          badgeKey: _badgeKey,
                          value: widget.controller.displayedPoints
                              .toPawFormat(),
                          phase: phase,
                          type: LoyaltyWidgetType.common,
                        ),
                      ],
                    ),
                  ),

                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Stack(
                          alignment: Alignment.center,
                          children: [
                            AnimatedOpacity(
                              opacity: hidePawAndCounter ? 0.0 : 1.0,
                              duration: const Duration(milliseconds: 400),
                              child: GlowRing(
                                size: outerGlowSize,
                                color: PawColors.rewardOrangeGlow.withValues(
                                  alpha: 0.09,
                                ),
                                beginScale: 1,
                                endScale: 1.07,
                                duration: const Duration(milliseconds: 2600),
                              ),
                            ),
                            AnimatedOpacity(
                              opacity: hidePawAndCounter ? 0.0 : 1.0,
                              duration: const Duration(milliseconds: 400),
                              child: GlowRing(
                                size: innerGlowSize,
                                color: PawColors.rewardOrangeGlow.withValues(
                                  alpha: 0.13,
                                ),
                                beginScale: 1,
                                endScale: 1.1,
                                duration: const Duration(milliseconds: 2100),
                                delay: const Duration(milliseconds: 400),
                              ),
                            ),
                            BigPaw(
                              key: _pawKey,
                              isFlying: hidePawAndCounter,
                              size: pawSize,
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),
                        AnimatedOpacity(
                          opacity: hidePawAndCounter ? 0.0 : 1.0,
                          duration: const Duration(milliseconds: 400),
                          child: AnimatedSlide(
                            offset: hidePawAndCounter
                                ? const Offset(0, 0.5)
                                : Offset.zero,
                            duration: const Duration(milliseconds: 400),
                            child: CountUpText(
                              target: widget.awardedPoints,
                              style: TextStyle(
                                fontSize: 58,
                                fontWeight: FontWeight.w900,
                                color: Color(
                                  0xFFFF6609,
                                ), // Default primary color fallback
                                height: 1,
                                letterSpacing: -1,
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
          ],
        ));
      },
    );
  }
}
