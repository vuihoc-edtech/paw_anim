import 'package:flutter/material.dart';

import 'stroked_celebration_text.dart';

/// Cụm điểm thưởng (mặc định: "+100 BiXu") kèm hiệu ứng xuất hiện (pop-in)
/// và lắc nhẹ (reward-shake) ở mốc 2100ms.
class CelebrationRewardBadge extends StatelessWidget {
  const CelebrationRewardBadge({
    super.key,
    required this.rewardText,
    required this.fontFamily,
    required this.opacity,
    required this.translateY,
    required this.scale,
    required this.shakeX,
    required this.shakeRotateRad,
    this.primaryColor,
  });

  final String rewardText;
  final String fontFamily;
  final double opacity;
  final double translateY;
  final double scale;
  final double shakeX;
  final double shakeRotateRad;
  final Color? primaryColor;

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: opacity.clamp(0.0, 1.0),
      child: Transform.translate(
        offset: Offset(0, translateY),
        child: Transform.scale(
          scale: scale,
          child: Transform.translate(
            offset: Offset(shakeX, 0),
            child: Transform.rotate(
              angle: shakeRotateRad,
              child: SizedBox(
                height: 64,
                child: Center(
                  // Chữ "+100 BiXu":
                  // font-family: SVN-Merge; font-weight: 700 (Bold);
                  // font-size: 48px (fs-48); line-height: 100% (1.0);
                  // letter-spacing: 0%; vertical-align: middle;
                  // background: var(--primary-main, #FF6609);
                  child: StrokedCelebrationText(
                    text: rewardText,
                    fontFamily: fontFamily,
                    fontFamilyFallback: const ['SVN-Merge', 'Coiny'],
                    fontWeight: FontWeight.w700,
                    fontSize: 48,
                    lineHeight: 1.0,
                    letterSpacing: 0,
                    fillColor: primaryColor ?? const Color(0xFFFF6609),
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
