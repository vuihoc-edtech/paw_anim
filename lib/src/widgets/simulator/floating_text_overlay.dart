import 'package:flutter/material.dart';
import '../../configs/reward_animation_configs.dart';
import '../../utils/animation_extension.dart';

/// [FloatingTextOverlay] - Chữ "+20" nổi lên từ Thẻ Điểm thưởng.
class FloatingTextOverlay extends StatelessWidget {
  final Animation<double> controller;
  final int awardedPoints;
  final Offset startOffset;
  final SimulatorRewardAnimationConfigs configs;

  const FloatingTextOverlay({
    required this.controller,
    required this.awardedPoints,
    required this.startOffset,
    required this.configs,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        AnimatedBuilder(
          animation: controller,
          builder: (context, child) {
            // Khởi động khi điểm số hiện lên (ở mốc 610ms, kéo dài 1000ms).
            final t = controller.getIntervalValue(
              610,
              1000,
              curve: Curves.easeOut,
            );
            final opacity = configs.floatPlusOpacity.transform(t);
            final yTranslation = configs.floatPlusTranslationY.transform(t);

            final progress = controller.value * 3200.0;
            if (progress < 610 || progress > 1610) {
              return const SizedBox.shrink();
            }

            return Positioned(
              left: startOffset.dx - 48.5,
              top: startOffset.dy - 115.0 + yTranslation,
              child: Opacity(
                opacity: opacity,
                child: Text(
                  '+$awardedPoints',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.w900,
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
