import 'package:flutter/material.dart';

import 'stroked_celebration_text.dart';

/// Cụm tiêu đề chính ("Chúc mừng") và mô tả phụ ("Cậu đã nhận quà mở nhiệm vụ bí mật").
class CelebrationTitleSection extends StatelessWidget {
  const CelebrationTitleSection({
    super.key,
    required this.title,
    required this.subtitle,
    required this.titleFontFamily,
    required this.bodyFontFamily,
    required this.titleOpacity,
    required this.titleTranslateY,
    required this.titleScale,
    required this.descriptionOpacity,
    required this.descriptionTranslateY,
  });

  final String title;
  final String subtitle;
  final String titleFontFamily;
  final String bodyFontFamily;
  final double titleOpacity;
  final double titleTranslateY;
  final double titleScale;
  final double descriptionOpacity;
  final double descriptionTranslateY;

  // background: linear-gradient(180deg, #F4B63E 0%, #F08E05 50%, #F3AF2A 100%)
  static const _titleGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
      Color(0xFFF4B63E),
      Color(0xFFF08E05),
      Color(0xFFF3AF2A),
    ],
    stops: [0.0, 0.5, 1.0],
  );

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // Tiêu đề "Chúc mừng":
        // font-family: SVN-Merge; font-weight: 700; font-size: 40px;
        // line-height: 64px; letter-spacing: 0%; vertical-align: middle;
        Opacity(
          opacity: titleOpacity.clamp(0.0, 1.0),
          child: Transform.translate(
            offset: Offset(0, titleTranslateY),
            child: Transform.scale(
              scale: titleScale,
              child: SizedBox(
                height: 64,
                child: Center(
                  child: StrokedCelebrationText(
                    text: title,
                    fontFamily: titleFontFamily,
                    fontFamilyFallback: const ['SVN-Merge', 'Coiny'],
                    fontWeight: FontWeight.w700,
                    fontSize: 40,
                    lineHeight: 64 / 40,
                    letterSpacing: 0,
                    gradient: _titleGradient,
                  ),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 4),
        // Mô tả phụ "Cậu đã nhận quà mở nhiệm vụ bí mật":
        // font-family: Be Vietnam Pro; font-weight: 400 (Regular);
        // font-size: 16px (body-lg); line-height: 24px (lh-24);
        // letter-spacing: 0px; text-align: center; color: #FFFFFF;
        Opacity(
          opacity: descriptionOpacity.clamp(0.0, 1.0),
          child: Transform.translate(
            offset: Offset(0, descriptionTranslateY),
            child: Text(
              subtitle,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: bodyFontFamily,
                fontFamilyFallback: const ['Be Vietnam Pro', 'BeVietnamPro'],
                fontSize: 16,
                height: 24 / 16,
                leadingDistribution: TextLeadingDistribution.even,
                fontWeight: FontWeight.w400,
                fontStyle: FontStyle.normal,
                letterSpacing: 0,
                color: const Color(0xFFFFFFFF),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
