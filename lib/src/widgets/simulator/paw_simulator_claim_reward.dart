import 'dart:async';
import 'package:flutter/material.dart';
import 'effects_overlay.dart';

/// [PawSimulatorClaimReward] - Màn hình kết quả trao thưởng chính ở Simulator.
/// Widget này hiển thị mascot và resultBox được truyền từ app chính.
class PawSimulatorClaimReward extends StatefulWidget {
  final int awardedPoints;
  final int finalBalance;
  final Widget mascot;
  final Widget resultBox;
  final VoidCallback onClose;
  final Offset? flyTargetOffset;
  final VoidCallback? onAnimationComplete;
  final bool isMissClaim;

  const PawSimulatorClaimReward({
    required this.awardedPoints,
    required this.finalBalance,
    required this.mascot,
    required this.resultBox,
    required this.onClose,
    this.flyTargetOffset,
    this.onAnimationComplete,
    this.isMissClaim = false,
    super.key,
  });

  @override
  State<PawSimulatorClaimReward> createState() =>
      _PawSimulatorClaimRewardState();
}

class _PawSimulatorClaimRewardState extends State<PawSimulatorClaimReward> {
  Timer? _timer;
  bool _hasClosed = false;

  @override
  void initState() {
    super.initState();
    if (widget.isMissClaim) {
      _timer = Timer(const Duration(milliseconds: 2000), () {
        if (mounted) {
          _handleClose();
        }
      });
    }
  }

  void _handleClose() {
    if (_hasClosed) return;
    _hasClosed = true;
    _timer?.cancel();
    widget.onAnimationComplete?.call();
    widget.onClose();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        width: double.infinity,
        height: double.infinity,
        color: Colors.transparent,
        child: SafeArea(
          bottom: false,
          child: LayoutBuilder(
            builder: (context, constraints) {
              final width = constraints.maxWidth;
              final height = constraints.maxHeight;

              // Tọa độ bắt đầu từ tâm của ResultBox thứ 3 (Điểm thưởng)
              final startOffset = Offset(width / 2 + 116, height / 2 + 116);

              // Tọa độ đích ở góc trên phải
              final targetOffset =
                  widget.flyTargetOffset ?? Offset(width - 52, 28);

              // Tọa độ góc trên bên trái của Mascot (Mascot có kích thước 260x220, ở giữa màn hình)
              final mascotTopLeft = Offset(width / 2 - 130, height / 2 - 166);

              return Stack(
                clipBehavior: Clip.none,
                alignment: Alignment.center,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // Mascot
                      widget.mascot,
                      const SizedBox(height: 12),
                      // Bảng điểm
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [widget.resultBox],
                      ),
                    ],
                  ),

                  // Reusable overlay widget for reward animations
                    SimulatorRewardEffectsOverlay(
                      awardedPoints: widget.awardedPoints,
                      balanceAfter: widget.finalBalance,
                      startOffset: startOffset,
                      targetOffset: targetOffset,
                      mascotTopLeft: mascotTopLeft,
                      onCompleted: _handleClose,
                      isMissClaim: widget.isMissClaim,
                    ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
