import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

/// Cụm nhân vật Bitu mở hộp quà (192x256) kết hợp hiệu ứng Lottie hào quang (320x320) phía sau.
class CelebrationIllustration extends StatelessWidget {
  const CelebrationIllustration({
    super.key,
    required this.opacity,
    required this.translateY,
    required this.scale,
    required this.effectsLottieAsset,
    required this.effectsController,
    required this.onEffectsLoaded,
    required this.illustrationImageAsset,
  });

  final double opacity;
  final double translateY;
  final double scale;
  final String effectsLottieAsset;
  final AnimationController effectsController;
  final void Function(LottieComposition composition) onEffectsLoaded;
  final String illustrationImageAsset;

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: opacity.clamp(0.0, 1.0),
      child: Transform.translate(
        offset: Offset(0, translateY),
        child: Transform.scale(
          scale: scale,
          child: Padding(
            padding: const EdgeInsets.all(32),
            child: SizedBox(
              width: 256,
              height: 256,
              child: Stack(
                alignment: Alignment.center,
                clipBehavior: Clip.none,
                children: [
                  // 1. Hiệu ứng hào quang lấp lánh (320x320)
                  Positioned(
                    width: 320,
                    height: 320,
                    child: IgnorePointer(
                      child: Lottie.asset(
                        effectsLottieAsset,
                        package: 'paw_anim',
                        controller: effectsController,
                        fit: BoxFit.contain,
                        repeat: false,
                        onLoaded: onEffectsLoaded,
                      ),
                    ),
                  ),

                  // 2. Minh hoạ nhân vật Bitu mở hộp quà (192x256)
                  SizedBox(
                    width: 192,
                    height: 256,
                    child: Image.asset(
                      illustrationImageAsset,
                      package: 'paw_anim',
                      width: 192,
                      height: 256,
                      fit: BoxFit.contain,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
