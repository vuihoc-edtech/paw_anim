import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

/// Widget Chân mèo nhỏ (MiniPaw) được dùng làm hạt bay (Particle)
class MiniPaw extends StatelessWidget {
  final double size;

  const MiniPaw({
    required this.size,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: Transform.rotate(
        angle: -15 * math.pi / 180,
        child: SvgPicture.asset(
          'assets/cat_paws.svg',
          package: 'paw_anim',
          fit: BoxFit.fill,
        ),
      ),
    );
  }
}
