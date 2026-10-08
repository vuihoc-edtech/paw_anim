import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:paw_anim/src/resource/paw_image.dart';
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
    return ScaleTransition(
      key: widget.badgeKey,
      scale: _scaleAnimation,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          // Pill container on the right
          Container(
            padding: const .symmetric(horizontal: 18),
            height: 28,
            decoration: BoxDecoration(
              color: bgClr,
              border: Border.all(color: mainClr, width: 1.5),
              borderRadius: .circular(16),
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
          // Paw Icon on the left (overlapping the pill)
          Positioned(
            left: -12,
            child: SvgPicture.asset(
              width: 28,
              height: 28,
              widget.isRewardResult ? PawImage.catPawsWhite : PawImage.catPaws,
              package: PawImage.packageImage,
              fit: BoxFit.fill,
            ),
          ),
        ],
      ),
    );
  }
}
