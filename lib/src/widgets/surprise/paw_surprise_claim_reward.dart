import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lottie/lottie.dart';

import 'celebration_illustration.dart';
import 'celebration_reward_badge.dart';
import 'celebration_speech_bubble.dart';
import 'celebration_timeline_animations.dart';
import 'celebration_title_section.dart';

class PawSurpriseClaimReward extends StatefulWidget {
  final int awardedPoints;
  final int finalBalance;
  final VoidCallback onDone;
  final Color? primaryColor;
  final Offset? flyTargetOffset;

  const PawSurpriseClaimReward({
    required this.awardedPoints,
    required this.finalBalance,
    required this.onDone,
    this.primaryColor,
    this.flyTargetOffset,
    super.key,
  });

  @override
  State<PawSurpriseClaimReward> createState() => _PawSurpriseClaimRewardState();
}

class _PawSurpriseClaimRewardState extends State<PawSurpriseClaimReward>
    with TickerProviderStateMixin {
  static const String _title = 'Chúc mừng';
  static const String _subtitle = 'Cậu đã nhận quà mở nhiệm vụ bí mật';
  static const String _tooltipMessage =
      'Chờ chút nhé! Bitu đang chuẩn bị nhiệm vụ học hôm nay';
  static const String _confettiLottieAsset = 'assets/confetti.json';
  static const String _illustrationEffectsLottieAsset =
      'assets/illustration_effects.json';
  static const String _illustrationImageAsset =
      'assets/bitu_reward_illustration.png';
  static const String _titleFontFamily = 'SVN-Merge';
  static const String _bodyFontFamily = 'BeVietnamPro';
  static const Duration _startDelay = Duration(milliseconds: 250);
  static Future<void>? _fontLoadFuture;

  late final AnimationController _timelineController;
  late final AnimationController _confettiController;
  late final AnimationController _illustrationEffectsController;
  late final CelebrationTimelineAnimations _animations;

  Timer? _startDelayTimer;
  Timer? _illustrationLottieTimer;
  bool _shouldPlayIllustrationEffects = false;
  bool _hasCompleted = false;

  @override
  void initState() {
    super.initState();

    _ensureTitleFontLoaded();

    _timelineController =
        AnimationController(
          vsync: this,
          duration: CelebrationTimelineAnimations.totalDuration,
        )..addStatusListener((status) {
          if (status == AnimationStatus.completed) {
            _handleDone();
          }
        });

    _confettiController = AnimationController(vsync: this);
    _illustrationEffectsController = AnimationController(vsync: this);
    _animations = CelebrationTimelineAnimations(_timelineController);

    _startCelebration();
  }

  void _ensureTitleFontLoaded() {
    _fontLoadFuture ??= () async {
      try {
        final boldData = rootBundle.load(
          'packages/paw_anim/assets/fonts/SVN-Merge-Bold.otf',
        );
        final pkgLoader = FontLoader('packages/paw_anim/$_titleFontFamily')
          ..addFont(boldData);
        final rawLoader = FontLoader(_titleFontFamily)..addFont(boldData);
        await Future.wait([pkgLoader.load(), rawLoader.load()]);
      } catch (_) {
        // Ignore if font is already loaded via FontManifest
      }
    }();
    _fontLoadFuture!.then((_) {
      if (mounted) {
        setState(() {});
      }
    });
  }

  void _startCelebration() {
    _startDelayTimer?.cancel();
    _illustrationLottieTimer?.cancel();
    _shouldPlayIllustrationEffects = false;

    _timelineController.reset();
    _illustrationEffectsController.reset();

    if (_confettiController.duration != null) {
      _confettiController.forward(from: 0.0);
    }

    _startDelayTimer = Timer(_startDelay, () {
      if (!mounted) return;
      _timelineController.forward(from: 0.0);

      _illustrationLottieTimer = Timer(
        CelebrationTimelineAnimations.illustrationLottieDelay,
        () {
          if (!mounted) return;
          _shouldPlayIllustrationEffects = true;
          if (_illustrationEffectsController.duration != null) {
            _illustrationEffectsController.forward(from: 0.0);
          }
        },
      );
    });
  }

  void _handleDone() {
    if (_hasCompleted || !mounted) return;
    _hasCompleted = true;
    widget.onDone();
  }

  @override
  void dispose() {
    _startDelayTimer?.cancel();
    _illustrationLottieTimer?.cancel();
    _timelineController.dispose();
    _confettiController.dispose();
    _illustrationEffectsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        alignment: Alignment.center,
        clipBehavior: Clip.hardEdge,
        children: [
          // 1. Lớp pháo giấy Lottie (646x824)
          Positioned.fill(
            child: IgnorePointer(
              child: Center(
                child: OverflowBox(
                  maxWidth: 646,
                  maxHeight: 824,
                  child: SizedBox(
                    width: 646,
                    height: 824,
                    child: Lottie.asset(
                      _confettiLottieAsset,
                      package: 'paw_anim',
                      controller: _confettiController,
                      fit: BoxFit.contain,
                      repeat: false,
                      onLoaded: (composition) {
                        _confettiController
                          ..duration = composition.duration
                          ..forward(from: 0.0);
                      },
                    ),
                  ),
                ),
              ),
            ),
          ),

          // 2. Nội dung chính của màn hình chúc mừng (căn giữa màn hình)
          Positioned.fill(
            child: SafeArea(
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 390),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: SizedBox(
                      width: double.infinity,
                      child: AnimatedBuilder(
                        animation: _timelineController,
                        builder: (context, _) {
                          return Column(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              CelebrationTitleSection(
                                title: _title,
                                subtitle: _subtitle,
                                titleFontFamily: _titleFontFamily,
                                bodyFontFamily: _bodyFontFamily,
                                titleOpacity: _animations.titleOpacity.value,
                                titleTranslateY:
                                    _animations.titleTranslateY.value,
                                titleScale: _animations.titleScale.value,
                                descriptionOpacity:
                                    _animations.descriptionOpacity.value,
                                descriptionTranslateY:
                                    _animations.descriptionTranslateY.value,
                              ),
                              const SizedBox(height: 8),
                              CelebrationRewardBadge(
                                rewardText: '+${widget.awardedPoints} BiXu',
                                fontFamily: _titleFontFamily,
                                primaryColor: widget.primaryColor,
                                opacity: _animations.rewardOpacity.value,
                                translateY: _animations.rewardTranslateY.value,
                                scale: _animations.rewardScale.value,
                                shakeX: _animations.rewardShakeX.value,
                                shakeRotateRad:
                                    _animations.rewardShakeRotateRad.value,
                              ),
                              CelebrationIllustration(
                                opacity:
                                    _animations.illustrationOpacity.value,
                                translateY:
                                    _animations.illustrationTranslateY.value,
                                scale: _animations.illustrationScale.value,
                                effectsLottieAsset:
                                    _illustrationEffectsLottieAsset,
                                effectsController:
                                    _illustrationEffectsController,
                                onEffectsLoaded: (composition) {
                                  _illustrationEffectsController.duration =
                                      composition.duration;
                                  if (_shouldPlayIllustrationEffects) {
                                    _illustrationEffectsController.forward(
                                      from: 0.0,
                                    );
                                  }
                                },
                                illustrationImageAsset: _illustrationImageAsset,
                              ),
                              CelebrationSpeechBubble(
                                message: _tooltipMessage,
                                fontFamily: _bodyFontFamily,
                                primaryColor: widget.primaryColor,
                                bubbleOpacity:
                                    _animations.bubbleOpacity.value,
                                bubbleTranslateY:
                                    _animations.bubbleTranslateY.value,
                                bubbleScale: _animations.bubbleScale.value,
                                messageOpacity:
                                    _animations.messageOpacity.value,
                                messageTranslateY:
                                    _animations.messageTranslateY.value,
                                dot1Opacity: _animations.dot1Opacity.value,
                                dot2Opacity: _animations.dot2Opacity.value,
                                dot3Opacity: _animations.dot3Opacity.value,
                              ),
                            ],
                          );
                        },
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
