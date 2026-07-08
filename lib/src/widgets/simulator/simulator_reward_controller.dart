import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import '../../enums/paw_enums.dart';

class SimulatorRewardController extends ChangeNotifier {
  final int awardedPoints;
  final int finalBalance;
  final int? time;
  final TickerProvider vsync;

  SimulatorRewardController({
    required this.awardedPoints,
    required this.finalBalance,
    required this.vsync,
    this.time,
  }) {
    _init();
  }

  final GlobalKey rootKey = GlobalKey();
  final GlobalKey badgeKey = GlobalKey();
  final GlobalKey rewardKey = GlobalKey();
  final GlobalKey mascotKey = GlobalKey();

  Offset _startOffset = Offset.zero;
  Offset get startOffset => _startOffset;

  Offset _targetOffset = Offset.zero;
  Offset get targetOffset => _targetOffset;

  Offset _mascotTopLeft = Offset.zero;
  Offset get mascotTopLeft => _mascotTopLeft;

  bool _isLayoutReady = false;
  bool get isLayoutReady => _isLayoutReady;

  RewardPhase _rewardPhase = RewardPhase.init;
  RewardPhase get rewardPhase => _rewardPhase;

  int _displayedPoints = 0;
  int get displayedPoints => _displayedPoints;

  Timer? _tFly;
  Timer? _tFlash;
  Timer? _tDone;
  Timer? _tWiggle;

  late final AnimationController entryController;
  late final AnimationController wiggleController;

  late final Animation<double> mascotScale;
  late final Animation<double> mascotOpacity;
  late final Animation<double> contentOpacity;
  late final Animation<Offset> contentSlide;
  late final Animation<double> cardScale;
  late final Animation<double> cardOpacity;
  late final Animation<double> wiggleRotation;
  late final Animation<double> wiggleScale;

  void _init() {
    final int startPoints = finalBalance - awardedPoints;
    _displayedPoints = startPoints < 0 ? 0 : startPoints;

    _tFly = Timer(const Duration(milliseconds: 1000), () {
      _rewardPhase = RewardPhase.fly;
      notifyListeners();
    });

    _tFlash = Timer(const Duration(milliseconds: 2600), () {
      _rewardPhase = RewardPhase.flash;
      _displayedPoints = finalBalance;
      notifyListeners();
    });

    _tDone = Timer(const Duration(milliseconds: 3000), () {
      _rewardPhase = RewardPhase.done;
      notifyListeners();
    });

    entryController = AnimationController(
      vsync: vsync,
      duration: const Duration(milliseconds: 1200),
    );

    wiggleController = AnimationController(
      vsync: vsync,
      duration: const Duration(milliseconds: 600),
    );

    mascotScale = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: entryController,
        curve: const Interval(0, 0.33, curve: Curves.easeOutBack),
      ),
    );
    mascotOpacity = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: entryController,
        curve: const Interval(0, 0.33, curve: Curves.easeIn),
      ),
    );

    contentOpacity = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: entryController,
        curve: const Interval(0.25, 0.58, curve: Curves.easeIn),
      ),
    );
    contentSlide = Tween<Offset>(begin: const Offset(0, 0.2), end: Offset.zero)
        .animate(
          CurvedAnimation(
            parent: entryController,
            curve: const Interval(0.25, 0.58, curve: Curves.easeOut),
          ),
        );

    cardScale = Tween<double>(begin: 0.95, end: 1).animate(
      CurvedAnimation(
        parent: entryController,
        curve: const Interval(0.5, 0.83, curve: Curves.easeOutBack),
      ),
    );
    cardOpacity = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: entryController,
        curve: const Interval(0.5, 0.83, curve: Curves.easeIn),
      ),
    );

    wiggleRotation = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween(begin: 0.0, end: -3 * math.pi / 180),
        weight: 12.5,
      ),
      TweenSequenceItem(
        tween: Tween(begin: -3 * math.pi / 180, end: 3 * math.pi / 180),
        weight: 25,
      ),
      TweenSequenceItem(
        tween: Tween(begin: 3 * math.pi / 180, end: 0.0),
        weight: 12.5,
      ),
      TweenSequenceItem(
        tween: Tween(begin: 0.0, end: -3 * math.pi / 180),
        weight: 12.5,
      ),
      TweenSequenceItem(
        tween: Tween(begin: -3 * math.pi / 180, end: 3 * math.pi / 180),
        weight: 25,
      ),
      TweenSequenceItem(
        tween: Tween(begin: 3 * math.pi / 180, end: 0.0),
        weight: 12.5,
      ),
    ]).animate(wiggleController);

    wiggleScale = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 1.0, end: 1.05), weight: 25),
      TweenSequenceItem(tween: Tween(begin: 1.05, end: 1.0), weight: 25),
      TweenSequenceItem(tween: Tween(begin: 1.0, end: 1.05), weight: 25),
      TweenSequenceItem(tween: Tween(begin: 1.05, end: 1.0), weight: 25),
    ]).animate(wiggleController);

    entryController.forward();
    entryController.addListener(notifyListeners);
    wiggleController.addListener(notifyListeners);

    _tWiggle = Timer(const Duration(milliseconds: 1000), () {
      wiggleController.forward();
    });
  }

  void calculateOffsets() {
    final RenderBox? rootBox =
        rootKey.currentContext?.findRenderObject() as RenderBox?;
    final RenderBox? badgeBox =
        badgeKey.currentContext?.findRenderObject() as RenderBox?;
    final badgePos =
        badgeBox?.localToGlobal(Offset.zero, ancestor: rootBox) ?? Offset.zero;

    final RenderBox? rewardBox =
        rewardKey.currentContext?.findRenderObject() as RenderBox?;
    final rewardPos =
        rewardBox?.localToGlobal(Offset.zero, ancestor: rootBox) ?? Offset.zero;

    final RenderBox? mascotBox =
        mascotKey.currentContext?.findRenderObject() as RenderBox?;
    final mascotPos =
        mascotBox?.localToGlobal(Offset.zero, ancestor: rootBox) ?? Offset.zero;

    _targetOffset = Offset(
      badgePos.dx + (badgeBox?.size.width ?? 0) / 2,
      badgePos.dy + (badgeBox?.size.height ?? 0) / 2,
    );

    _startOffset = Offset(
      rewardPos.dx + 12,
      rewardPos.dy + (rewardBox?.size.height ?? 0) / 2,
    );

    _mascotTopLeft = mascotPos;
    _isLayoutReady = true;
    notifyListeners();
  }

  @override
  void dispose() {
    entryController.removeListener(notifyListeners);
    wiggleController.removeListener(notifyListeners);
    entryController.dispose();
    wiggleController.dispose();
    _tFly?.cancel();
    _tFlash?.cancel();
    _tDone?.cancel();
    _tWiggle?.cancel();
    super.dispose();
  }
}
