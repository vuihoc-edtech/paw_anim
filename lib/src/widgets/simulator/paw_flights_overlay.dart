// ignore_for_file: prefer_int_literals

import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:paw_anim/src/resource/paw_image.dart';
import '../../models/paw_flight_data.dart';
import '../../utils/animation_extension.dart';

/// [PawFlightsOverlay] - Lớp phủ vẽ 8 chân mèo bay từ Thẻ Điểm thưởng hội tụ lên Huy hiệu góc trên bên phải.
class PawFlightsOverlay extends StatelessWidget {
  final Animation<double> controller;
  final List<PawFlightData> pawFlights;
  final Offset startOffset;
  final Offset targetOffset;

  const PawFlightsOverlay({
    required this.controller,
    required this.pawFlights,
    required this.startOffset,
    required this.targetOffset,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    // Góc xoay gốc của chân mèo là -15 độ (tương tự Tailwind class -rotate-15 trên Web).
    const baseRad = -15 * (math.pi / 180.0);

    final trueDeltaX = targetOffset.dx - startOffset.dx;
    final trueDeltaY = targetOffset.dy - startOffset.dy;

    return Stack(
      children: pawFlights.map((paw) {
        return AnimatedBuilder(
          animation: controller,
          builder: (context, child) {
            // Lấy tiến trình thời gian riêng của từng chân mèo bay (kéo dài 1350ms).
            final t = controller.getIntervalValue(
              paw.d.toDouble(),
              1350,
              curve: Curves.linear,
            );

            // Hoạt ảnh mờ rõ:
            final opacity = TweenSequence<double>([
              TweenSequenceItem(
                tween: Tween(
                  begin: 0.0,
                  end: 1.0,
                ).chain(CurveTween(curve: const Cubic(0.3, 0.0, 0.2, 1.0))),
                weight: 8,
              ),
              TweenSequenceItem(
                tween: Tween(
                  begin: 1.0,
                  end: 1.0,
                ).chain(CurveTween(curve: const Cubic(0.3, 0.0, 0.2, 1.0))),
                weight: 50,
              ),
              TweenSequenceItem(
                tween: Tween(
                  begin: 1.0,
                  end: 0.6,
                ).chain(CurveTween(curve: const Cubic(0.3, 0.0, 0.2, 1.0))),
                weight: 27,
              ),
              TweenSequenceItem(
                tween: Tween(
                  begin: 0.6,
                  end: 0.0,
                ).chain(CurveTween(curve: const Cubic(0.3, 0.0, 0.2, 1.0))),
                weight: 15,
              ),
            ]).transform(t);

            final actualFx = trueDeltaX + (paw.fx - 48.0);
            final actualFy = trueDeltaY + (paw.fy + 390.0);

            final actualMx = paw.mx.toDouble();
            final actualMy = paw.my.toDouble();

            final moveX = TweenSequence<double>([
              TweenSequenceItem(
                tween: Tween(
                  begin: 0.0,
                  end: actualMx,
                ).chain(CurveTween(curve: const Cubic(0.3, 0.0, 0.2, 1.0))),
                weight: 58,
              ),
              TweenSequenceItem(
                tween: Tween(
                  begin: actualMx,
                  end: actualFx,
                ).chain(CurveTween(curve: const Cubic(0.3, 0.0, 0.2, 1.0))),
                weight: 42,
              ),
            ]).transform(t);

            final moveY = TweenSequence<double>([
              TweenSequenceItem(
                tween: Tween(
                  begin: 0.0,
                  end: actualMy,
                ).chain(CurveTween(curve: const Cubic(0.3, 0.0, 0.2, 1.0))),
                weight: 58,
              ),
              TweenSequenceItem(
                tween: Tween(
                  begin: actualMy,
                  end: actualFy,
                ).chain(CurveTween(curve: const Cubic(0.3, 0.0, 0.2, 1.0))),
                weight: 42,
              ),
            ]).transform(t);

            final scale = TweenSequence<double>([
              TweenSequenceItem(
                tween: Tween(
                  begin: 0.4,
                  end: paw.s,
                ).chain(CurveTween(curve: const Cubic(0.3, 0.0, 0.2, 1.0))),
                weight: 58,
              ),
              TweenSequenceItem(
                tween: Tween(
                  begin: paw.s,
                  end: 0.28,
                ).chain(CurveTween(curve: const Cubic(0.3, 0.0, 0.2, 1.0))),
                weight: 42,
              ),
            ]).transform(t);

            final double rad = paw.r * (math.pi / 180.0);
            final rotation =
                TweenSequence<double>([
                  TweenSequenceItem(
                    tween: Tween(
                      begin: 0.0,
                      end: rad,
                    ).chain(CurveTween(curve: const Cubic(0.3, 0.0, 0.2, 1.0))),
                    weight: 58,
                  ),
                  TweenSequenceItem(
                    tween: Tween(
                      begin: rad,
                      end: rad * 1.4,
                    ).chain(CurveTween(curve: const Cubic(0.3, 0.0, 0.2, 1.0))),
                    weight: 42,
                  ),
                ]).transform(t) +
                baseRad;

            // Chuyển đổi timeline từ 0.0 - 1.0 sang trục thời gian ảo 0 - 3200ms
            final progress = controller.value * 3200.0;

            if (progress < paw.d || progress > paw.d + 1350) {
              return const SizedBox.shrink();
            }

            return Positioned(
              left: startOffset.dx - 24.0 + moveX,
              top: startOffset.dy - 24.0 + moveY,
              width: 48,
              height: 48,
              child: Opacity(
                opacity: opacity,
                child: Transform.scale(
                  scale: scale,
                  child: Transform.rotate(
                    angle: rotation,
                    child: SvgPicture.asset(
                      PawImage.catPaws,
                      package: PawImage.packageImage,
                    ),
                  ),
                ),
              ),
            );
          },
        );
      }).toList(),
    );
  }
}
