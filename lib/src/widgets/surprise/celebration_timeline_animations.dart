import 'dart:math' as math;

import 'package:flutter/material.dart';

/// Quản lý toàn bộ trục thời gian (timeline 4400ms) và các keyframe animation
/// của màn hình chúc mừng nhận thưởng.
class CelebrationTimelineAnimations {
  CelebrationTimelineAnimations(this.controller) {
    _initTitleAnimations();
    _initDescriptionAnimations();
    _initRewardAnimations();
    _initIllustrationAnimations();
    _initBubbleAnimations();
    _initDotAnimations();
  }

  /// Tổng thời lượng của chuỗi keyframe tính từ lúc bắt đầu (4400ms).
  static const Duration totalDuration = Duration(milliseconds: _totalMs);
  static const int _totalMs = 4400;

  /// Độ trễ kích hoạt Lottie hào quang sau lưng nhân vật (780ms).
  static const Duration illustrationLottieDelay = Duration(milliseconds: 780);

  final AnimationController controller;

  // 1. Title ("Chúc mừng"): delay 240ms, duration 618ms
  late final Animation<double> titleOpacity;
  late final Animation<double> titleTranslateY;
  late final Animation<double> titleScale;

  // 2. Subtitle: delay 336ms, duration 473ms
  late final Animation<double> descriptionOpacity;
  late final Animation<double> descriptionTranslateY;

  // 3. Reward ("+100 BiXu") reveal: delay 600ms, duration 691ms
  late final Animation<double> rewardOpacity;
  late final Animation<double> rewardTranslateY;
  late final Animation<double> rewardScale;

  // 4. Reward ("+100 BiXu") shake: delay 2100ms, duration 520ms
  late final Animation<double> rewardShakeX;
  late final Animation<double> rewardShakeRotateRad;

  // 5. Illustration reveal: delay 780ms, duration 873ms
  late final Animation<double> illustrationOpacity;
  late final Animation<double> illustrationTranslateY;
  late final Animation<double> illustrationScale;

  // 6. Speech bubble reveal: delay 1380ms, duration 618ms
  late final Animation<double> bubbleOpacity;
  late final Animation<double> bubbleTranslateY;
  late final Animation<double> bubbleScale;

  // 7. Bubble message reveal: delay 1500ms, duration 436ms
  late final Animation<double> messageOpacity;
  late final Animation<double> messageTranslateY;

  // 8. Ba chấm tròn (Slider dots): 2100ms, 3100ms, 4100ms (duration 300ms)
  late final Animation<double> dot1Opacity;
  late final Animation<double> dot2Opacity;
  late final Animation<double> dot3Opacity;

  Interval _msInterval(
    int delayMs,
    int durationMs, [
    Curve curve = Curves.linear,
  ]) {
    final begin = (delayMs / _totalMs).clamp(0.0, 1.0);
    final end = ((delayMs + durationMs) / _totalMs).clamp(0.0, 1.0);
    return Interval(begin, end, curve: curve);
  }

  void _initTitleAnimations() {
    const curve = Cubic(0.2, 0.8, 0.2, 1.0);
    final parent = CurvedAnimation(
      parent: controller,
      curve: _msInterval(240, 618),
    );

    titleOpacity = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween<double>(begin: 0.0, end: 1.0).chain(
          CurveTween(curve: curve),
        ),
        weight: 75,
      ),
      TweenSequenceItem(tween: ConstantTween<double>(1.0), weight: 25),
    ]).animate(parent);

    titleTranslateY = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween<double>(begin: 8.0, end: 0.0).chain(
          CurveTween(curve: curve),
        ),
        weight: 75,
      ),
      TweenSequenceItem(tween: ConstantTween<double>(0.0), weight: 25),
    ]).animate(parent);

    titleScale = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween<double>(begin: 0.97, end: 1.01).chain(
          CurveTween(curve: curve),
        ),
        weight: 75,
      ),
      TweenSequenceItem(
        tween: Tween<double>(begin: 1.01, end: 1.0).chain(
          CurveTween(curve: curve),
        ),
        weight: 25,
      ),
    ]).animate(parent);
  }

  void _initDescriptionAnimations() {
    final parent = CurvedAnimation(
      parent: controller,
      curve: _msInterval(336, 473, Curves.easeOut),
    );
    descriptionOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(parent);
    descriptionTranslateY = Tween<double>(begin: 5.0, end: 0.0).animate(parent);
  }

  void _initRewardAnimations() {
    const revealCurve = Cubic(0.2, 0.85, 0.25, 1.15);
    final revealParent = CurvedAnimation(
      parent: controller,
      curve: _msInterval(600, 691),
    );

    rewardOpacity = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween<double>(begin: 0.0, end: 1.0).chain(
          CurveTween(curve: revealCurve),
        ),
        weight: 68,
      ),
      TweenSequenceItem(tween: ConstantTween<double>(1.0), weight: 32),
    ]).animate(revealParent);

    rewardTranslateY = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween<double>(begin: 10.0, end: 0.0).chain(
          CurveTween(curve: revealCurve),
        ),
        weight: 68,
      ),
      TweenSequenceItem(tween: ConstantTween<double>(0.0), weight: 32),
    ]).animate(revealParent);

    rewardScale = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween<double>(begin: 0.9, end: 1.08).chain(
          CurveTween(curve: revealCurve),
        ),
        weight: 68,
      ),
      TweenSequenceItem(
        tween: Tween<double>(begin: 1.08, end: 1.0).chain(
          CurveTween(curve: revealCurve),
        ),
        weight: 32,
      ),
    ]).animate(revealParent);

    final shakeParent = CurvedAnimation(
      parent: controller,
      curve: _msInterval(2100, 520),
    );

    rewardShakeX = _buildKeyframedTween(
      values: const [0.0, 3.0, -3.0, 2.0, -1.0, 0.0],
      weights: const [18, 18, 18, 18, 28],
      curve: Curves.easeInOut,
    ).animate(shakeParent);

    double degToRad(double deg) => deg * math.pi / 180.0;
    rewardShakeRotateRad = _buildKeyframedTween(
      values: [
        0.0,
        degToRad(0.5),
        degToRad(-0.5),
        degToRad(0.3),
        degToRad(-0.2),
        0.0,
      ],
      weights: const [18, 18, 18, 18, 28],
      curve: Curves.easeInOut,
    ).animate(shakeParent);
  }

  void _initIllustrationAnimations() {
    const curve = Cubic(0.2, 0.85, 0.25, 1.08);
    final parent = CurvedAnimation(
      parent: controller,
      curve: _msInterval(780, 873),
    );

    illustrationOpacity = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween<double>(begin: 0.0, end: 1.0).chain(
          CurveTween(curve: curve),
        ),
        weight: 72,
      ),
      TweenSequenceItem(tween: ConstantTween<double>(1.0), weight: 28),
    ]).animate(parent);

    illustrationTranslateY = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween<double>(begin: 16.0, end: 0.0).chain(
          CurveTween(curve: curve),
        ),
        weight: 72,
      ),
      TweenSequenceItem(tween: ConstantTween<double>(0.0), weight: 28),
    ]).animate(parent);

    illustrationScale = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween<double>(begin: 0.92, end: 1.04).chain(
          CurveTween(curve: curve),
        ),
        weight: 72,
      ),
      TweenSequenceItem(
        tween: Tween<double>(begin: 1.04, end: 1.0).chain(
          CurveTween(curve: curve),
        ),
        weight: 28,
      ),
    ]).animate(parent);
  }

  void _initBubbleAnimations() {
    final bubbleParent = CurvedAnimation(
      parent: controller,
      curve: _msInterval(1380, 618, Curves.easeOut),
    );
    bubbleOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(bubbleParent);
    bubbleTranslateY =
        Tween<double>(begin: 10.0, end: 0.0).animate(bubbleParent);
    bubbleScale = Tween<double>(begin: 0.97, end: 1.0).animate(bubbleParent);

    final messageParent = CurvedAnimation(
      parent: controller,
      curve: _msInterval(1500, 436, Curves.easeOut),
    );
    messageOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(messageParent);
    messageTranslateY =
        Tween<double>(begin: 4.0, end: 0.0).animate(messageParent);
  }

  void _initDotAnimations() {
    dot1Opacity = Tween<double>(begin: 0.32, end: 1.0).animate(
      CurvedAnimation(
        parent: controller,
        curve: _msInterval(2100, 300, Curves.easeOut),
      ),
    );
    dot2Opacity = Tween<double>(begin: 0.32, end: 1.0).animate(
      CurvedAnimation(
        parent: controller,
        curve: _msInterval(3100, 300, Curves.easeOut),
      ),
    );
    dot3Opacity = Tween<double>(begin: 0.32, end: 1.0).animate(
      CurvedAnimation(
        parent: controller,
        curve: _msInterval(4100, 300, Curves.easeOut),
      ),
    );
  }

  TweenSequence<double> _buildKeyframedTween({
    required List<double> values,
    required List<double> weights,
    required Curve curve,
  }) {
    return TweenSequence<double>([
      for (int i = 0; i < weights.length; i++)
        TweenSequenceItem<double>(
          tween: Tween<double>(begin: values[i], end: values[i + 1]).chain(
            CurveTween(curve: curve),
          ),
          weight: weights[i],
        ),
    ]);
  }
}
