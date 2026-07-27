import 'package:flutter/material.dart';
import '../../configs/reward_animation_configs.dart';
import 'confetti_overlay.dart';
import 'floating_text_overlay.dart';
import 'paw_flights_overlay.dart';
import 'reward_badge_overlay.dart';
import 'sparkles_overlay.dart';

/// [SimulatorRewardEffectsOverlay] - Widget tự quản lý hiệu ứng trao thưởng
/// bao gồm pháo giấy, lấp lánh xung quanh mascot, chữ bay lên, và chân mèo bay hội tụ.
///
/// **Không** quản lý AudioPlayer — app chính tự play sound thông qua [onPlaySound].
class SimulatorRewardEffectsOverlay extends StatefulWidget {
  final int awardedPoints;
  final int balanceAfter;
  final Offset startOffset;
  final Offset targetOffset;
  final Offset mascotTopLeft;
  final VoidCallback? onCompleted;
  final bool showBadgeOverlay;
  final bool isMissClaim;

  const SimulatorRewardEffectsOverlay({
    required this.awardedPoints,
    required this.balanceAfter,
    required this.startOffset,
    required this.targetOffset,
    required this.mascotTopLeft,
    this.onCompleted,
    this.showBadgeOverlay = true,
    this.isMissClaim = false,
    super.key,
  });

  @override
  State<SimulatorRewardEffectsOverlay> createState() =>
      _SimulatorRewardEffectsOverlayState();
}

class _SimulatorRewardEffectsOverlayState
    extends State<SimulatorRewardEffectsOverlay>
    with SingleTickerProviderStateMixin {
  late final AnimationController _animationController;
  final SimulatorRewardAnimationConfigs _configs =
      SimulatorRewardAnimationConfigs();

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: widget.isMissClaim
          ? const Duration(milliseconds: 2000)
          : const Duration(milliseconds: 3200),
    );

    _animationController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        widget.onCompleted?.call();
      }
    });

    // Chạy hiệu ứng & gọi callback âm thanh
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        // 1. Sparkles Overlay
        Positioned.fill(
          child: SparklesOverlay(
            controller: _animationController,
            configs: _configs,
            sparkles: _configs.sparkles,
            mascotTopLeft: widget.mascotTopLeft,
          ),
        ),

        // 2. Confetti Overlay
        
        Positioned.fill(
          child: ConfettiOverlay(
            controller: _animationController,
            configs: _configs,
            confettiList: _configs.confettiList,
            startOffset: widget.startOffset,
          ),
        ),

        // 3. Paw Flights Overlay
        if (!widget.isMissClaim)
          Positioned.fill(
            child: PawFlightsOverlay(
              controller: _animationController,
              pawFlights: _configs.pawFlights,
              startOffset: widget.startOffset,
              targetOffset: widget.targetOffset,
            ),
          ),

        // 4. Floating Text (Center) Overlay
        if (!widget.isMissClaim)
          Positioned.fill(
            child: FloatingTextOverlay(
              controller: _animationController,
              configs: _configs,
              startOffset: widget.startOffset,
              awardedPoints: widget.awardedPoints,
            ),
          ),

        // 5. Reward Badge & Header Overlay
        if (widget.showBadgeOverlay)
          Positioned.fill(
            child: RewardBadgeOverlay(
              controller: _animationController,
              configs: _configs,
              targetOffset: widget.targetOffset,
              awardedPoints: widget.awardedPoints,
              balanceAfter: widget.balanceAfter,
              isMissClaim: widget.isMissClaim,
            ),
          ),
      ],
    );
  }
}
