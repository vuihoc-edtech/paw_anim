import 'package:flutter/material.dart';
import 'package:paw_anim/paw_anim.dart';

class PawCommonClaimReward extends StatefulWidget {
  final int awardedPoints;
  final int finalBalance;
  final VoidCallback onDone;
  final Color? primaryColor;
  final Offset? flyTargetOffset;

  const PawCommonClaimReward({
    required this.awardedPoints,
    required this.finalBalance,
    required this.onDone,
    this.primaryColor,
    this.flyTargetOffset,
    super.key,
  });

  @override
  State<PawCommonClaimReward> createState() => _PawCommonClaimRewardState();
}

class _PawCommonClaimRewardState extends State<PawCommonClaimReward> {
  late final PawRewardController _controller;

  @override
  void initState() {
    super.initState();
    _controller = PawRewardController();
    _controller.startRewardAnimation(
      widget.awardedPoints,
      finalBalance: widget.finalBalance,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: _controller,
      builder: (context, child) {
        return Stack(
          children: [
            PawRewardScreen(
              controller: _controller,
              awardedPoints: widget.awardedPoints,
              primaryColor: widget.primaryColor,
              flyTargetOffset: widget.flyTargetOffset,
              onStartFly: (from, to) {
                // Controller handles coordinates and flags internally
              },
              onDone: widget.onDone,
            ),
            if (_controller.showFlight &&
                _controller.fromOffset != null &&
                _controller.toOffset != null)
              FlightParticles(
                from: _controller.fromOffset!,
                to: _controller.toOffset!,
                onParticleLanded: _controller.onParticleLanded,
              ),
          ],
        );
      },
    );
  }
}
