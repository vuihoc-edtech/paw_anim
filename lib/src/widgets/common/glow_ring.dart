import 'dart:async';

import 'package:flutter/material.dart';

class GlowRing extends StatefulWidget {
  final double size;
  final Color color;
  final double beginScale;
  final double endScale;
  final Duration duration;
  final Duration? delay;

  const GlowRing({
    required this.size,
    required this.color,
    required this.beginScale,
    required this.endScale,
    required this.duration,
    super.key,
    this.delay,
  });

  @override
  State<GlowRing> createState() => _GlowRingState();
}

class _GlowRingState extends State<GlowRing>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: widget.duration);

    // Chu trình thở đi từ 1.0 -> scale đích -> 1.0
    _scaleAnimation = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween<double>(
          begin: widget.beginScale,
          end: widget.endScale,
        ).chain(CurveTween(curve: Curves.easeInOut)),
        weight: 50,
      ),
      TweenSequenceItem(
        tween: Tween<double>(
          begin: widget.endScale,
          end: widget.beginScale,
        ).chain(CurveTween(curve: Curves.easeInOut)),
        weight: 50,
      ),
    ]).animate(_controller);

    if (widget.delay != null) {
      Future.delayed(widget.delay!, () {
        if (mounted) {
          _controller.repeat();
        }
      });
    } else {
      _controller.repeat();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _scaleAnimation,
      child: Container(
        width: widget.size,
        height: widget.size,
        decoration: BoxDecoration(shape: BoxShape.circle, color: widget.color),
      ),
    );
  }
}
