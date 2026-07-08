import 'package:flutter/animation.dart';

extension PawAnimationExtension on Animation<double> {
  /// Lấy giá trị progress [0.0 - 1.0] của một khoảng thời gian nhỏ
  /// trong tổng thời lượng animation.
  double getIntervalValue(
    double startMs,
    double durationMs, {
    Curve curve = Curves.linear,
    double totalDurationMs = 3200.0,
  }) {
    final progress = value;
    final start = startMs / totalDurationMs;
    final end = (startMs + durationMs) / totalDurationMs;

    if (progress <= start) return 0.0;
    if (progress >= end) return 1.0;

    final t = (progress - start) / (end - start);
    return curve.transform(t).clamp(0.0, 1.0);
  }
}
