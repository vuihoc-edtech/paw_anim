import 'dart:math' as math;
import 'package:flutter/material.dart';

class ConfettiPiece {
  final int id;
  final double x; // start X percent (5..95)
  final double y; // start Y percent (-40..-10)
  final Color color;
  final double w;
  final double h;
  final bool isRound;
  final double rot;
  final double vx; // drift X in logical pixels
  final double vy; // speed Y factor (roughly height multiplier)
  final double spin;
  final double delay; // delay fraction of animation (0..0.8)
  final double duration; // duration fraction (2.5..4.0 seconds)

  ConfettiPiece({
    required this.id,
    required this.x,
    required this.y,
    required this.color,
    required this.w,
    required this.h,
    required this.isRound,
    required this.rot,
    required this.vx,
    required this.vy,
    required this.spin,
    required this.delay,
    required this.duration,
  });

  factory ConfettiPiece.random(int id, int totalCount) {
    // Seed using id to keep values consistent per piece
    final rand = math.Random(id * 17 + 23);
    final colors = [
      const Color(0xFFF7AE3C),
      const Color(0xFF91CD56),
      const Color(0xFF31B9DF),
      const Color(0xFFB61885),
      const Color(0xFF8B389A),
      const Color(0xFFF75851),
      const Color(0xFF5861AB),
      const Color(0xFFFF6609),
    ];
    final round = id % 4 == 0;
    final w = id % 3 == 1 ? 3.0 : 6.0 + rand.nextDouble() * 6.0;
    final h = id % 3 == 1
        ? 14.0 + rand.nextDouble() * 10.0
        : 5.0 + rand.nextDouble() * 8.0;

    return ConfettiPiece(
      id: id,
      x: 5.0 + rand.nextDouble() * 90.0,
      y: -10.0 - rand.nextDouble() * 30.0,
      color: colors[id % colors.length],
      w: round ? w : w,
      h: round ? w : h,
      isRound: round,
      rot: rand.nextDouble() * 360.0,
      vx: (rand.nextDouble() - 0.5) * 60.0,
      vy: 80.0 + rand.nextDouble() * 80.0,
      spin: rand.nextDouble() * 400.0 - 200.0,
      delay: (id / totalCount) * 0.8,
      duration: 2.5 + rand.nextDouble() * 1.5,
    );
  }
}

class ConfettiPainter extends CustomPainter {
  final List<ConfettiPiece> pieces;
  final double animationTime; // elapsed time in seconds (0.0 to 4.5)
  static const Cubic confettiEase = Cubic(0.1, 0.3, 0.6, 1);

  ConfettiPainter({required this.pieces, required this.animationTime});

  @override
  void paint(Canvas canvas, Size size) {
    for (final p in pieces) {
      if (animationTime < p.delay) continue;

      // Elapsed progress for this piece
      final double elapsed = animationTime - p.delay;
      if (elapsed > p.duration) continue;

      final double t = elapsed / p.duration; // 0.0 to 1.0
      final double easedT = confettiEase.transform(t);

      // Interpolate positions
      final double curX = (p.x / 100.0) * size.width + (p.vx * easedT);
      // y drops from initial off-screen start to beyond the screen (vy + 100% of height)
      final double startY = (p.y / 100.0) * size.height;
      final double endY = size.height + (p.vy / 100.0) * size.height;
      final double curY = startY + (endY - startY) * easedT;

      final double rotation = p.rot + (p.spin * t);

      // Opacity follows [1, 1, 0.9, 0] curve
      double opacity = 1;
      if (t > 0.8) {
        opacity = 1.0 - ((t - 0.8) / 0.2); // fade out in the last 20%
      }
      opacity = opacity.clamp(0.0, 1.0);

      final paint = Paint()
        ..color = p.color.withValues(alpha: opacity * 0.85)
        ..style = PaintingStyle.fill;

      canvas
        ..save()
        ..translate(curX, curY)
        ..rotate(rotation * math.pi / 180.0);

      if (p.isRound) {
        canvas.drawCircle(Offset.zero, p.w / 2, paint);
      } else {
        canvas.drawRRect(
          RRect.fromRectAndRadius(
            Rect.fromLTWH(-p.w / 2, -p.h / 2, p.w, p.h),
            const Radius.circular(2),
          ),
          paint,
        );
      }

      canvas.restore();
    }
  }

  @override
  bool shouldRepaint(covariant ConfettiPainter oldDelegate) {
    return oldDelegate.animationTime != animationTime;
  }
}

class FallingConfetti extends StatefulWidget {
  final int count;
  const FallingConfetti({super.key, this.count = 70});

  @override
  State<FallingConfetti> createState() => _FallingConfettiState();
}

class _FallingConfettiState extends State<FallingConfetti>
    with SingleTickerProviderStateMixin {
  late List<ConfettiPiece> _pieces;
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _pieces = List.generate(
      widget.count,
      (i) => ConfettiPiece.random(i, widget.count),
    );

    // The maximum duration for a piece is delay (0.8 max) + duration (4.0 max) = 4.8 seconds.
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 4800),
    )..forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        final elapsedSeconds = _controller.value * 4.8;
        return CustomPaint(
          painter: ConfettiPainter(
            pieces: _pieces,
            animationTime: elapsedSeconds,
          ),
          child: const SizedBox.expand(),
        );
      },
    );
  }
}
