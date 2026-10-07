import 'package:flutter/material.dart';

/// Khung hội thoại trắng (280px) bên dưới nhân vật Bitu, bao gồm:
/// - Mũi tên tam giác trỏ lên trên (16x8)
/// - Dòng thông báo của Bitu
/// - 3 chấm tròn cam sáng dần theo tiến độ chuẩn bị nhiệm vụ.
class CelebrationSpeechBubble extends StatelessWidget {
  const CelebrationSpeechBubble({
    super.key,
    required this.message,
    required this.fontFamily,
    required this.bubbleOpacity,
    required this.bubbleTranslateY,
    required this.bubbleScale,
    required this.messageOpacity,
    required this.messageTranslateY,
    required this.dot1Opacity,
    required this.dot2Opacity,
    required this.dot3Opacity,
    this.primaryColor,
  });

  final String message;
  final String fontFamily;
  final double bubbleOpacity;
  final double bubbleTranslateY;
  final double bubbleScale;
  final double messageOpacity;
  final double messageTranslateY;
  final double dot1Opacity;
  final double dot2Opacity;
  final double dot3Opacity;
  final Color? primaryColor;

  @override
  Widget build(BuildContext context) {
    final clampedBubbleOpacity = bubbleOpacity.clamp(0.0, 1.0);
    final dotColor = primaryColor ?? const Color(0xFFFF6609);

    return SizedBox(
      width: 280,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // 1. Mũi tên tam giác trỏ lên trên (16x8)
          Opacity(
            opacity: clampedBubbleOpacity,
            child: Transform.translate(
              offset: Offset(0, bubbleTranslateY),
              child: const SizedBox(
                width: 16,
                height: 8,
                child: CustomPaint(
                  painter: _TooltipArrowPainter(),
                ),
              ),
            ),
          ),

          // 2. Hộp hội thoại trắng bo góc 12px
          Opacity(
            opacity: clampedBubbleOpacity,
            child: Transform.translate(
              offset: Offset(0, bubbleTranslateY),
              child: Transform.scale(
                scale: bubbleScale,
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // Nội dung tin nhắn:
                      // font-family: Be Vietnam Pro; font-weight: 400 (Regular);
                      // font-size: 16px (body-lg); line-height: 24px (lh-24);
                      // letter-spacing: 0px; text-align: center; color: #000000DE;
                      Opacity(
                        opacity: messageOpacity.clamp(0.0, 1.0),
                        child: Transform.translate(
                          offset: Offset(0, messageTranslateY),
                          child: Text(
                            message,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontFamily: fontFamily,
                              fontFamilyFallback: const [
                                'Be Vietnam Pro',
                                'BeVietnamPro',
                              ],
                              fontSize: 16,
                              height: 24 / 16,
                              leadingDistribution: TextLeadingDistribution.even,
                              fontWeight: FontWeight.w400,
                              fontStyle: FontStyle.normal,
                              letterSpacing: 0,
                              color: const Color(0xDE000000),
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 12),

                      // 3 chấm tròn tiến độ (40w x 8h)
                      SizedBox(
                        width: 40,
                        height: 8,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            _SliderDot(opacity: dot1Opacity, color: dotColor),
                            _SliderDot(opacity: dot2Opacity, color: dotColor),
                            _SliderDot(opacity: dot3Opacity, color: dotColor),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SliderDot extends StatelessWidget {
  const _SliderDot({
    required this.opacity,
    required this.color,
  });

  final double opacity;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: opacity.clamp(0.0, 1.0),
      child: Container(
        width: 8,
        height: 8,
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
        ),
      ),
    );
  }
}

/// Vẽ mũi tên tam giác trắng trỏ lên trên của khung hội thoại (16x8).
class _TooltipArrowPainter extends CustomPainter {
  const _TooltipArrowPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    final path = Path()
      ..moveTo(0, size.height)
      ..lineTo(size.width / 2, 0)
      ..lineTo(size.width, size.height)
      ..close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
