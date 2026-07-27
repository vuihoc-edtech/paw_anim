import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../enums/paw_enums.dart';

/// Badge hiển thị điểm số trên góc phải, tự động nảy theo mốc thời gian của web
class DesignBadge extends StatefulWidget {
  final String value;
  final RewardPhase phase; // Lấy phase để kích hoạt hoạt ảnh đúng thời điểm
  final GlobalKey? badgeKey;
  final LoyaltyWidgetType type;

  /// Màu chính (text + border). Nếu null, dùng màu mặc định theo [type].
  final Color? mainColor;

  /// Màu nền badge. Nếu null, dùng màu mặc định theo [type].
  final Color? backgroundColor;

  /// TextStyle cho giá trị điểm. Nếu null, dùng style mặc định.
  final TextStyle? valueTextStyle;
  final bool isRewardResult;


  const DesignBadge({
    required this.value,
    required this.phase,
    required this.type,
    this.badgeKey,
    this.mainColor,
    this.backgroundColor,
    this.valueTextStyle,
    this.isRewardResult = false,
    super.key,
  });

  @override
  State<DesignBadge> createState() => _DesignBadgeState();
}

class _DesignBadgeState extends State<DesignBadge>
    with SingleTickerProviderStateMixin {
  late AnimationController _bounceController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _glowScaleAnimation;
  late Animation<double> _glowOpacityAnimation;

  @override
  void initState() {
    super.initState();
    // Hoạt ảnh kéo dài 500ms y hệt web
    _bounceController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );

    // Chuỗi keyframe nảy của web: [1.0, 1.3, 0.9, 1.1, 1.0]
    _scaleAnimation = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween<double>(
          begin: 1,
          end: 1.3,
        ).chain(CurveTween(curve: Curves.easeOut)),
        weight: 25,
      ),
      TweenSequenceItem(
        tween: Tween<double>(
          begin: 1.3,
          end: 0.9,
        ).chain(CurveTween(curve: Curves.easeInOut)),
        weight: 25,
      ),
      TweenSequenceItem(
        tween: Tween<double>(
          begin: 0.9,
          end: 1.1,
        ).chain(CurveTween(curve: Curves.easeInOut)),
        weight: 25,
      ),
      TweenSequenceItem(
        tween: Tween<double>(
          begin: 1.1,
          end: 1,
        ).chain(CurveTween(curve: Curves.easeInOut)),
        weight: 25,
      ),
    ]).animate(_bounceController);

    // Hoạt ảnh loé sáng: scale từ 0.6 -> 1.6, opacity từ 0.9 -> 0.0
    _glowScaleAnimation = Tween<double>(begin: 0.6, end: 1.6).animate(
      CurvedAnimation(parent: _bounceController, curve: Curves.easeOut),
    );
    _glowOpacityAnimation = Tween<double>(begin: 0.9, end: 0).animate(
      CurvedAnimation(parent: _bounceController, curve: Curves.easeOut),
    );
  }

  @override
  void didUpdateWidget(covariant DesignBadge oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Chỉ kích hoạt nảy đúng 1 lần duy nhất khi phase chuyển sang flash
    if (widget.phase == RewardPhase.flash &&
        oldWidget.phase != RewardPhase.flash) {
      _bounceController.forward(from: 0);
    }
  }

  @override
  void dispose() {
    _bounceController.dispose();
    super.dispose();
  }

  Color _defaultMainColor() {
    switch (widget.type) {
      case LoyaltyWidgetType.simulatorExercise:
        return Colors.white;
      case LoyaltyWidgetType.simulator:
      case LoyaltyWidgetType.common:
        return const Color(0xFFFF6609); // AppColors.subjectDuoMath equivalent
    }
  }

  Color _defaultBackgroundColor() {
    switch (widget.type) {
      case LoyaltyWidgetType.simulatorExercise:
        return Colors.transparent;
      case LoyaltyWidgetType.simulator:
      case LoyaltyWidgetType.common:
        return Colors.white.withValues(alpha: 0.08);
    }
  }

  @override
  Widget build(BuildContext context) {
    final mainClr = widget.mainColor ?? _defaultMainColor();
    final bgClr = widget.backgroundColor ?? _defaultBackgroundColor();

    return Stack(
      key: widget.badgeKey,
      clipBehavior: Clip.none,
      children: [
        // 1. Vòng hào quang loé sáng (Badge Glow Flash)
        AnimatedBuilder(
          animation: _bounceController,
          builder: (context, child) {
            final double glowOpacity = _glowOpacityAnimation.value;
            final double glowScale = _glowScaleAnimation.value;
            if (glowOpacity <= 0.001) return const SizedBox.shrink();

            return Positioned.fill(
              child: Center(
                child: Opacity(
                  opacity: glowOpacity.clamp(0.0, 1.0),
                  child: Transform.scale(
                    scale: glowScale,
                    child: SizedBox(
                      width: 120,
                      height: 120,
                      child: Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: RadialGradient(
                            colors: [
                              const Color(0xFFFFD600).withValues(alpha: 0.7),
                              const Color(0xFFFF6609).withValues(alpha: 0.4),
                              Colors.transparent,
                            ],
                            stops: const [0.0, 0.5, 0.75],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        ),

        // 2. Nội dung Badge nảy co giãn lò xo (Pill + Paw)
        ScaleTransition(
          scale: _scaleAnimation,
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              // Pill container on the right
              Padding(
                padding: const EdgeInsets.only(left: 22),
                child: Container(
                  height: 28,
                  padding: const EdgeInsets.only(left: 16, right: 8),
                  decoration: BoxDecoration(
                    color: bgClr,
                    border: Border.all(color: mainClr, width: 1.5),
                    borderRadius: const BorderRadius.only(
                      topRight: Radius.circular(50),
                      bottomRight: Radius.circular(50),
                    ),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    widget.value,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: mainClr,
                    ),
                  ),
                ),
              ),

              // Paw Icon on the left (overlapping the pill)
              Padding(
                padding: const EdgeInsets.only(left: 6),
                child: SizedBox(
                  width: 28,
                  height: 28,
                  child: SvgPicture.asset(
                     widget.isRewardResult
                                                  ? 'assets/cat_paws_white.svg'
                                                  : 'assets/cat_paws.svg',
                    package: 'paw_anim',
                    fit: BoxFit.fill,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
