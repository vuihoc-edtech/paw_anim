import 'package:flutter/material.dart';

/// Dữ liệu cấu hình cho mỗi mẩu pháo giấy (confetti).
class ConfettiData {
  final double x;
  final double y;
  final Color color;
  final double angle;
  final double d;

  const ConfettiData({
    required this.x,
    required this.y,
    required this.color,
    required this.angle,
    required this.d,
  });
}
