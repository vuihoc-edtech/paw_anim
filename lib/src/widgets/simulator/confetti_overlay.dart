import 'package:flutter/material.dart';
import '../../models/confetti_data.dart';
import '../../configs/reward_animation_configs.dart';
import '../../utils/animation_extension.dart';

/// [ConfettiOverlay] - Lớp phủ vẽ pháo giấy bắn ra khi điểm số xuất hiện tại Thẻ Điểm thưởng.
class ConfettiOverlay extends StatelessWidget {
  final Animation<double> controller;
  final List<ConfettiData> confettiList;
  final Offset startOffset;
  final SimulatorRewardAnimationConfigs configs;

  const ConfettiOverlay({
    required this.controller,
    required this.confettiList,
    required this.startOffset,
    required this.configs,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: confettiList.map((conf) {
        return AnimatedBuilder(
          animation: controller,
          builder: (context, child) {
            // Lấy tiến trình thời gian riêng của từng mẩu pháo giấy (kéo dài 760ms).
            final t = controller.getIntervalValue(
              conf.d,
              760,
              curve: Curves.easeOut,
            );
            final opacity = configs.confettiOpacity.transform(t);
            final moveX = configs.confettiTranslationX.transform(t);
            final moveY = configs.confettiTranslationY.transform(t);
            final scale = configs.confettiScale.transform(t);
            final rotate = configs.confettiRotation.transform(t);

            final progress = controller.value * 3200.0;
            if (progress < conf.d || progress > conf.d + 760) {
              return const SizedBox.shrink();
            }

            return Positioned(
              left: startOffset.dx + (conf.x - 264.0) + moveX,
              top: startOffset.dy + (conf.y - 460.0) + moveY,
              child: Opacity(
                opacity: opacity,
                child: Transform.scale(
                  scale: scale,
                  child: Transform.rotate(
                    angle: rotate,
                    child: Container(
                      width: 6,
                      height: 8,
                      decoration: BoxDecoration(
                        color: conf.color,
                        borderRadius: BorderRadius.circular(2),
                      ),
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
