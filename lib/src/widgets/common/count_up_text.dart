import 'package:flutter/material.dart';

class CountUpText extends StatefulWidget {
  final int target;
  final int from;
  final Duration duration;
  final Duration delay;
  final TextStyle style;

  const CountUpText({
    required this.target,
    required this.style,
    super.key,
    this.from = 0,
    this.duration = const Duration(milliseconds: 1800),
    this.delay = const Duration(milliseconds: 600),
  });

  @override
  State<CountUpText> createState() => _CountUpTextState();
}

class _CountUpTextState extends State<CountUpText>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: widget.duration);
    _animation =
        Tween<double>(
          begin: widget.from.toDouble(),
          end: widget.target.toDouble(),
        ).animate(
          CurvedAnimation(
            parent: _controller,
            curve: const Cubic(0.1, 0.3, 0.6, 1),
          ),
        );

    Future.delayed(widget.delay, () {
      if (mounted) {
        _controller.forward();
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Text('+${_animation.value.round()}', style: widget.style);
      },
    );
  }
}
