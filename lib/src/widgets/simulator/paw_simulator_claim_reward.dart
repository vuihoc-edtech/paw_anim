import 'package:flutter/material.dart';
import 'effects_overlay.dart';

/// [PawSimulatorClaimReward] - Màn hình kết quả trao thưởng chính ở Simulator.
/// Widget này hiển thị mascot và resultBox được truyền từ app chính.
class PawSimulatorClaimReward extends StatelessWidget {
  final int awardedPoints;
  final int finalBalance;
  final Widget mascot;
  final Widget resultBox;
  final VoidCallback onClose;
  final Offset? flyTargetOffset;
  final VoidCallback? onAnimationComplete;

  const PawSimulatorClaimReward({
    required this.awardedPoints,
    required this.finalBalance,
    required this.mascot,
    required this.resultBox,
    required this.onClose,
    this.flyTargetOffset,
    this.onAnimationComplete,
    super.key,
  });

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
                  flyTargetOffset ?? Offset(width - 52, 28);

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
                      mascot,
                      const SizedBox(height: 12),
                      // Bảng điểm
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          resultBox,
                        ],
                      ),
                    ],
                  ),

                  // Reusable overlay widget for reward animations
                  SimulatorRewardEffectsOverlay(
                    awardedPoints: awardedPoints,
                    balanceAfter: finalBalance,
                    startOffset: startOffset,
                    targetOffset: targetOffset,
                    mascotTopLeft: mascotTopLeft,
                    onCompleted: () {
                      onAnimationComplete?.call();
                      onClose();
                    },
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
