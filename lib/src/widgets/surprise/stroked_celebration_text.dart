import 'package:flutter/material.dart';

/// Widget vẽ chữ nghệ thuật có:
/// - Viền trắng dày 6px bo góc tròn (`StrokeJoin.round`)
/// - Bóng đổ cứng bên dưới màu `#E65C08`
/// - Màu nền bên trong dạng chuyển sắc ([gradient]) hoặc đơn sắc ([fillColor]).
class StrokedCelebrationText extends StatelessWidget {
  const StrokedCelebrationText({
    super.key,
    required this.text,
    required this.fontFamily,
    required this.fontSize,
    this.package = 'paw_anim',
    this.fontWeight = FontWeight.w700,
    this.fontStyle = FontStyle.normal,
    this.lineHeight = 1.0,
    this.letterSpacing = 0.0,
    this.fontFamilyFallback,
    this.gradient,
    this.fillColor,
    this.strokeWidth = 6.0,
    this.strokeColor = Colors.white,
    this.shadowColor = const Color(0xFFE65C08),
    this.shadowOffset = const Offset(0, 1.5),
  });

  final String text;
  final String fontFamily;
  final double fontSize;
  final String? package;
  final FontWeight fontWeight;
  final FontStyle fontStyle;
  final double lineHeight;
  final double letterSpacing;
  final List<String>? fontFamilyFallback;
  final Gradient? gradient;
  final Color? fillColor;
  final double strokeWidth;
  final Color strokeColor;
  final Color shadowColor;
  final Offset shadowOffset;

  @override
  Widget build(BuildContext context) {
    final baseStyle = TextStyle(
      fontFamily: fontFamily,
      package: package,
      fontFamilyFallback: fontFamilyFallback,
      fontSize: fontSize,
      fontWeight: fontWeight,
      fontStyle: fontStyle,
      letterSpacing: letterSpacing,
      height: lineHeight,
      leadingDistribution: TextLeadingDistribution.even,
    );

    return Stack(
      alignment: Alignment.center,
      children: [
        // 1. Lớp bóng đổ cứng phía dưới viền chữ
        Transform.translate(
          offset: shadowOffset,
          child: Text(
            text,
            textAlign: TextAlign.center,
            style: baseStyle.copyWith(
              foreground: Paint()
                ..style = PaintingStyle.stroke
                ..strokeWidth = strokeWidth
                ..strokeJoin = StrokeJoin.round
                ..strokeCap = StrokeCap.round
                ..color = shadowColor,
            ),
          ),
        ),

        // 2. Lớp viền trắng bo tròn
        Text(
          text,
          textAlign: TextAlign.center,
          style: baseStyle.copyWith(
            foreground: Paint()
              ..style = PaintingStyle.stroke
              ..strokeWidth = strokeWidth
              ..strokeJoin = StrokeJoin.round
              ..strokeCap = StrokeCap.round
              ..color = strokeColor,
          ),
        ),

        // 3. Lớp tô màu bên trong (Gradient hoặc màu đơn sắc)
        if (gradient != null)
          ShaderMask(
            blendMode: BlendMode.srcIn,
            shaderCallback: (bounds) => gradient!.createShader(
              Rect.fromLTWH(0, 0, bounds.width, bounds.height),
            ),
            child: Text(
              text,
              textAlign: TextAlign.center,
              style: baseStyle.copyWith(color: Colors.white),
            ),
          )
        else
          Text(
            text,
            textAlign: TextAlign.center,
            style: baseStyle.copyWith(
              color: fillColor ?? const Color(0xFFFF6609),
            ),
          ),
      ],
    );
  }
}
