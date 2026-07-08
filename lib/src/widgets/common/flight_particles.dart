import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'mini_paw.dart';

/// Khai báo cấu trúc dữ liệu của từng Hạt chân mèo khi bay
class ParticleDef {
  final int id;
  final double delay; // Độ trễ ra mắt chuẩn hóa trong chu kỳ 1800ms
  final double duration; // Thời lượng bay chuẩn hóa (900ms / 1800ms = 0.5)
  final double size; // Kích thước hạt
  final double midX; // Tọa độ X bung rộng tại thời điểm 30% hành trình
  final double midY; // Tọa độ Y bung rộng tại thời điểm 30% hành trình
  final double rot0; // Góc xoay xuất phát ban đầu
  final double startScale; // Tỷ lệ scale ban đầu

  ParticleDef({
    required this.id,
    required this.delay,
    required this.duration,
    required this.size,
    required this.midX,
    required this.midY,
    required this.rot0,
    required this.startScale,
  });
}

/// Lớp hiển thị tất cả các Hạt chân mèo bay theo đường cong Bezier
class FlightParticles extends StatefulWidget {
  final Offset from;
  final Offset to;
  final Function(int index) onParticleLanded;

  const FlightParticles({
    required this.from,
    required this.to,
    required this.onParticleLanded,
    super.key,
  });

  @override
  State<FlightParticles> createState() => _FlightParticlesState();
}

class _FlightParticlesState extends State<FlightParticles>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late List<ParticleDef> _particles;
  late List<bool> _particleLanded;
  static const int particleCount = 10; // 10 hạt giống bản web

  @override
  void initState() {
    super.initState();
    // Tổng chu kỳ hoạt ảnh kéo dài 1800ms (900ms trễ tích lũy + 900ms bay của hạt cuối)
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    );

    _particleLanded = List.filled(particleCount, false);

    // Tính toán các thông số của hạt bay y hệt bản Web (Framer Motion)
    _particles = List.generate(particleCount, (i) {
      final double angle = (i / particleCount) * math.pi * 2;
      final double spread = 70.0 + (i % 3) * 30.0;
      final double midX = math.cos(angle) * spread;
      final double midY = math.sin(angle) * spread - 30.0;
      final double rot0 =
          (-30.0 + (i / particleCount) * 60.0) * math.pi / 180.0;

      return ParticleDef(
        id: i,
        delay: (i * 100.0) / 1800.0, // Stagger 100ms giữa mỗi hạt
        duration: 900.0 / 1800.0, // Mỗi hạt bay đúng 900ms
        size: 18.0 + (i % 3) * 6.0, // Kích thước 18, 24, 30
        midX: midX,
        midY: midY,
        rot0: rot0,
        startScale: 1,
      );
    });

    // Lắng nghe sự kiện để xác định thời điểm từng hạt đáp vào Badge điểm số
    _controller
      ..addListener(() {
        final double tGlobal = _controller.value;
        for (int i = 0; i < _particles.length; i++) {
          final p = _particles[i];
          final double landingTime = p.delay + p.duration;
          if (tGlobal >= landingTime && !_particleLanded[i]) {
            _particleLanded[i] = true;
            widget.onParticleLanded(i);
          }
        }
      })
      // Bắt đầu bay ngay khi widget được render
      ..forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  // Nội suy tuyến tính đa điểm (Multi-point keyframes interpolation) với Curve easeInOut
  double interpolateKeyframes(
    double t,
    List<double> values,
    List<double> times,
  ) {
    if (t <= times[0]) return values[0];
    if (t >= times[times.length - 1]) return values[values.length - 1];
    for (int i = 0; i < times.length - 1; i++) {
      if (t >= times[i] && t <= times[i + 1]) {
        final double tMin = times[i];
        final double tMax = times[i + 1];
        final double valMin = values[i];
        final double valMax = values[i + 1];
        final double pct = (t - tMin) / (tMax - tMin);
        final double curvedPct = Curves.easeInOut.transform(pct);
        return valMin + (valMax - valMin) * curvedPct;
      }
    }
    return values[values.length - 1];
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        final double tGlobal = _controller.value;
        return Stack(
          clipBehavior: Clip.none,
          children: _particles.map((p) {
            // Tiến độ bay riêng của hạt [0.0, 1.0]
            double tLocal = (tGlobal - p.delay) / p.duration;
            tLocal = tLocal.clamp(0.0, 1.0);

            // Chỉ vẽ hạt khi đang trong tiến trình bay
            if (tLocal <= 0.0 || tLocal >= 1.0) {
              return const SizedBox.shrink();
            }

            // Tính toán vị trí X và Y tuyệt đối theo Keyframes (Times: [0, 0.3, 1])
            final double relativeX = interpolateKeyframes(
              tLocal,
              [0.0, p.midX, widget.to.dx - widget.from.dx],
              [0.0, 0.3, 1.0],
            );
            final double relativeY = interpolateKeyframes(
              tLocal,
              [0.0, p.midY, widget.to.dy - widget.from.dy],
              [0.0, 0.3, 1.0],
            );

            // Tính toán tỷ lệ scale, độ mờ opacity và góc xoay động
            final double scale = interpolateKeyframes(
              tLocal,
              [0.0, 1.1, 0.0],
              [0.0, 0.3, 1.0],
            );
            final double opacity = interpolateKeyframes(
              tLocal,
              [0.0, 1.0, 0.0],
              [0.0, 0.3, 1.0],
            );
            final double rotation = interpolateKeyframes(
              tLocal,
              [p.rot0, 0.0, -p.rot0 * 0.5],
              [0.0, 0.3, 1.0],
            );

            final double xPosition =
                widget.from.dx + relativeX - (p.size / 2.0);
            final double yPosition =
                widget.from.dy + relativeY - (p.size / 2.0);

            return Positioned(
              left: xPosition,
              top: yPosition,
              child: Opacity(
                opacity: opacity.clamp(0.0, 1.0),
                child: Transform.rotate(
                  angle: rotation,
                  child: Transform.scale(
                    scale: scale.clamp(0.0, 2.0),
                    child: MiniPaw(
                      size: p.size,
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
        );
      },
    );
  }
}
