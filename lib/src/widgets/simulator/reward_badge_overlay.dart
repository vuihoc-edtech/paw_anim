import 'package:flutter/material.dart';
import '../../configs/reward_animation_configs.dart';
import '../../colors/paw_colors.dart';
import '../../enums/paw_enums.dart';
import '../../utils/animation_extension.dart';
import '../../utils/paw_format.dart';
import '../common/design_badge.dart';

/// [RewardBadgeOverlay] - Lớp hoạt ảnh Huy hiệu điểm thưởng góc trên phải.
class RewardBadgeOverlay extends StatelessWidget {
  final Animation<double> controller;
  final int awardedPoints;
  final Offset targetOffset;
  final int balanceAfter;
  final SimulatorRewardAnimationConfigs configs;
  final bool isMissClaim;
  

  const RewardBadgeOverlay({
    required this.controller,
    required this.awardedPoints,
    required this.targetOffset,
    required this.configs,
    required this.balanceAfter,
    this.isMissClaim = false,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        // A. Huy hiệu chính (DesignBadge)
        AnimatedBuilder(
          animation: controller,
          builder: (context, child) {
            final progress = controller.value * 3200.0;
            final int startPoints = balanceAfter - awardedPoints;
            final int displayedPoints = isMissClaim
                ? balanceAfter
                : (progress >= 2220
                    ? balanceAfter
                    : (startPoints < 0 ? 0 : startPoints));

            final phase = isMissClaim
                ? RewardPhase.done
                : (progress >= 2220
                    ? (progress >= 2720 ? RewardPhase.done : RewardPhase.flash)
                    : RewardPhase.fly);

            return Positioned(
              right: 16,
              top: targetOffset.dy - 14,
              child: DesignBadge(
                value: displayedPoints.toPawFormat(),
                phase: phase,
                type: LoyaltyWidgetType.simulator,
              ),
            );
          },
        ),

        // B. Số cộng bay lên tại khu vực Huy hiệu (Header Plus)
        if (!isMissClaim)
          AnimatedBuilder(
            animation: controller,
            builder: (context, child) {
              final t = controller.getIntervalValue(
                2220,
                420,
                curve: Curves.easeOut,
              );
              final opacity = configs.headerPlusOpacity.transform(t);
              final yTranslation = configs.headerPlusTranslationY.transform(t);

              final progress = controller.value * 3200.0;
              if (progress < 2220 || progress > 2640) {
                return const SizedBox.shrink();
              }

              return Positioned(
                left: targetOffset.dx - 36,
                top: targetOffset.dy + 42 + yTranslation,
                child: Opacity(
                  opacity: opacity,
                  child: Text(
                    '+$awardedPoints',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
              );
            },
          ),

        // C. Hiệu ứng nổ tinh thể phát tỏa ra từ tâm Huy hiệu (Header Burst)
        if (!isMissClaim)
        AnimatedBuilder(
          animation: controller,
          builder: (context, child) {
            final t = controller.getIntervalValue(
              2220,
              500,
              curve: Curves.easeOut,
            );
            final opacity = configs.headerBurstOpacity.transform(t);
            final scale = configs.headerBurstScale.transform(t);

            final progress = controller.value * 3200.0;
            if (progress < 2220 || progress > 2720) {
              return const SizedBox.shrink();
            }

            return Positioned(
              left: targetOffset.dx - 68,
              top: targetOffset.dy - 36,
              width: 120,
              height: 100,
              child: Opacity(
                opacity: opacity,
                child: Transform.scale(
                  scale: scale,
                  child: Stack(
                    children: [
                      // Hạt 1: Trắng
                      Positioned(
                        left: 10,
                        top: 40,
                        width: 6,
                        height: 6,
                        child: Container(
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                          ),
                        ),
                      ),
                      // Hạt 2: Vàng nhạt
                      Positioned(
                        left: 50,
                        top: 10,
                        width: 5,
                        height: 5,
                        child: Container(
                          decoration: const BoxDecoration(
                            color: PawColors.rewardGold,
                            shape: BoxShape.circle,
                          ),
                        ),
                      ),
                      // Hạt 3: Trắng
                      Positioned(
                        left: 90,
                        top: 60,
                        width: 6,
                        height: 6,
                        child: Container(
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                          ),
                        ),
                      ),
                      // Hạt 4: Vàng đậm
                      Positioned(
                        left: 30,
                        top: 80,
                        width: 5,
                        height: 5,
                        child: Container(
                          decoration: const BoxDecoration(
                            color: PawColors.rewardOrange,
                            shape: BoxShape.circle,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}
