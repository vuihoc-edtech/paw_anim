import 'package:flutter/material.dart';
import '../../models/sparkle_data.dart';
import '../../configs/reward_animation_configs.dart';
import '../../resource/paw_colors.dart';
import '../../utils/animation_extension.dart';

/// [SparklesOverlay] - Lớp phủ vẽ các hạt tinh thể lấp lánh xung quanh Mascot.
class SparklesOverlay extends StatelessWidget {
  final Animation<double> controller;
  final List<SparkleData> sparkles;
  final Offset mascotTopLeft;
  final SimulatorRewardAnimationConfigs configs;

  const SparklesOverlay({
    required this.controller,
    required this.sparkles,
    required this.mascotTopLeft,
    required this.configs,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: sparkles.map((sparkle) {
        return AnimatedBuilder(
          animation: controller,
          builder: (context, child) {
            // Lấy tiến trình thời gian riêng của từng hạt lấp lánh (kéo dài 900ms).
            final t = controller.getIntervalValue(
              sparkle.d,
              900,
              curve: Curves.easeOut,
            );
            final scale = configs.sparkleScale.transform(t);
            final opacity = configs.sparkleOpacity.transform(t);
            final translateY = configs.sparkleTranslationY.transform(t);

            // Kiểm tra ẩn/hiển thị hạt lấp lánh theo dòng thời gian chính.
            final progress = controller.value * 3200.0;
            if (progress < sparkle.d || progress > sparkle.d + 900) {
              return const SizedBox.shrink();
            }

            return Positioned(
              left: mascotTopLeft.dx + 7.5 + sparkle.x,
              top: mascotTopLeft.dy - 18.0 + sparkle.y + translateY,
              width: sparkle.size,
              height: sparkle.size,
              child: Opacity(
                opacity: opacity,
                child: Transform.scale(
                  scale: scale,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          // ignore: deprecated_member_use
                          color: PawColors.rewardGold.withOpacity(0.55),
                          blurRadius: 12,
                          spreadRadius: 4,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        );
      }).toList(),
    );
  }
}
