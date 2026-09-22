import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:paw_anim/src/resource/paw_image.dart';

/// Widget Chân mèo lớn (BigPaw) ở tâm màn hình nhận thưởng
class BigPaw extends StatefulWidget {
  final bool isFlying;
  final double size;

  const BigPaw({required this.isFlying, this.size = 160.0, super.key});

  @override
  State<BigPaw> createState() => _BigPawState();
}

class _BigPawState extends State<BigPaw> with TickerProviderStateMixin {
  late AnimationController _idleController;
  late AnimationController _entryController;
  late AnimationController _flyController;

  late Animation<double> _entryScaleAnimation;
  late Animation<double> _entryOpacityAnimation;

  late Animation<double> _scaleAnimation;
  late Animation<double> _rotateAnimation;
  late Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();
    // Idle animation: Nhịp thở nhấp nhô và lắc lư xoay nhẹ tuần hoàn 5.6s
    _idleController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 5600),
    )..repeat();

    // Entry animation: Hiện lớn lên từ 0.0 -> 1.0 kèm độ mượt easeOutBack
    _entryController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );

    _entryScaleAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _entryController, curve: Curves.easeOutBack),
    );
    _entryOpacityAnimation = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(CurvedAnimation(parent: _entryController, curve: Curves.easeOut));

    // Bắt đầu hiệu ứng xuất hiện ngay lập tức
    _entryController.forward();

    // Fly animation: Hiệu ứng co nhỏ và mờ dần khi chuẩn bị "bắn" các hạt đi
    _flyController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );

    _scaleAnimation = Tween<double>(
      begin: 1,
      end: 0,
    ).animate(CurvedAnimation(parent: _flyController, curve: Curves.easeIn));
    _rotateAnimation = Tween<double>(
      begin: 0,
      end: 15.0 * math.pi / 180.0,
    ).animate(CurvedAnimation(parent: _flyController, curve: Curves.easeIn));
    _opacityAnimation = Tween<double>(
      begin: 1,
      end: 0,
    ).animate(CurvedAnimation(parent: _flyController, curve: Curves.easeIn));
  }

  @override
  void didUpdateWidget(covariant BigPaw oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Khi kích hoạt trạng thái bay, dừng hoạt ảnh và chạy hoạt ảnh biến mất
    if (widget.isFlying && !oldWidget.isFlying) {
      _idleController.stop();
      _flyController.forward();
    } else if (!widget.isFlying && oldWidget.isFlying) {
      _flyController.reverse().then((_) {
        if (mounted) {
          _idleController.repeat();
        }
      });
    }
  }

  @override
  void dispose() {
    _idleController.dispose();
    _entryController.dispose();
    _flyController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: Listenable.merge([
        _idleController,
        _flyController,
        _entryController,
      ]),
      builder: (context, child) {
        double yOffset = 0;
        double rAngle = 0;

        // Tính toán chuyển động nhấp nhô & lắc lư tự nhiên (Idle math)
        if (!widget.isFlying) {
          // Hoạt ảnh đi lên/đi xuống: Y dao động từ 0 -> -10 -> 0 trong chu kỳ 2.8s
          final double bobT = (_idleController.value * 2.0) % 1.0;
          yOffset = -10.0 * math.sin(bobT * math.pi);

          // Hoạt ảnh lắc lư (Wiggle): Xoay góc [0, -9, 9, -5, 5, 0] độ trong 700ms đầu của chu kỳ 3.7s
          final double wiggleTime = _idleController.value * 5.6;
          final double cycleTime = wiggleTime % 3.7;
          if (cycleTime < 0.7) {
            final double t = cycleTime / 0.7; // Chuẩn hóa thời gian về [0, 1]
            const listT = [0.0, 0.2, 0.4, 0.6, 0.8, 1.0];
            const listRot = [0.0, -9.0, 9.0, -5.0, 5.0, 0.0];
            double deg = 0;
            for (int i = 0; i < listT.length - 1; i++) {
              if (t >= listT[i] && t <= listT[i + 1]) {
                final double segT = (t - listT[i]) / (listT[i + 1] - listT[i]);
                deg = listRot[i] + (listRot[i + 1] - listRot[i]) * segT;
                break;
              }
            }
            rAngle = deg * math.pi / 180.0;
          }
        } else {
          // Nếu đang biến mất để chuẩn bị bay, lấy góc xoay từ hoạt ảnh biến mất
          rAngle = _rotateAnimation.value;
        }

        // Tỉ lệ scale = tỉ lệ lúc xuất hiện * tỉ lệ lúc biến mất bay đi
        final double scale =
            _entryScaleAnimation.value *
            (widget.isFlying ? _scaleAnimation.value : 1.0);
        // Độ mờ opacity = độ mờ lúc xuất hiện * độ mờ lúc biến mất bay đi
        final double opacity =
            _entryOpacityAnimation.value *
            (widget.isFlying ? _opacityAnimation.value : 1.0);

        final double baseSize = widget.size;

        return Opacity(
          opacity: opacity,
          child: Transform.translate(
            offset: Offset(0, yOffset),
            child: Transform.rotate(
              angle: rAngle,
              child: Transform.scale(
                scale: scale,
                child: SizedBox(
                  width: baseSize,
                  height: baseSize,
                  child: SvgPicture.asset(
                    PawImage.catPaws,
                    package: PawImage.packageImage,
                    fit: BoxFit.fill,
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
