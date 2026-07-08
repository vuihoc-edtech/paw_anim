import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../models/confetti_data.dart';
import '../models/paw_flight_data.dart';
import '../models/sparkle_data.dart';

class SimulatorRewardAnimationConfigs {
  // 1. DỮ LIỆU CẤU HÌNH HẠT LẤP LÁNH (SPARKLES) XUNG QUANH MASCOT
  final List<SparkleData> sparkles = const [
    SparkleData(x: 44, y: 0, size: 8, d: 270),
    SparkleData(x: 202, y: 16, size: 5.5, d: 310),
    SparkleData(x: 21, y: 55, size: 5.5, d: 350),
    SparkleData(x: 226, y: 70, size: 8, d: 390),
    SparkleData(x: 112, y: 112, size: 8, d: 430),
  ];

  // 2. DỮ LIỆU CẤU HÌNH PHÁO GIẤY (CONFETTI POP) BUNG RA TỪ THẺ ĐIỂM THƯỞNG
  final List<ConfettiData> confettiList = const [
    ConfettiData(x: 222, y: 395, color: Color(0xFFFFD967), angle: 26, d: 660),
    ConfettiData(x: 218, y: 398, color: Color(0xFF67B0FF), angle: -24, d: 740),
    ConfettiData(x: 262, y: 382, color: Color(0xFFFF7B67), angle: 30, d: 820),
    ConfettiData(x: 268, y: 384, color: Color(0xFF67FF9A), angle: -18, d: 900),
    ConfettiData(x: 224, y: 392, color: Color(0xFFE967FF), angle: 45, d: 980),
    ConfettiData(x: 260, y: 388, color: Color(0xFFFFC067), angle: -35, d: 1060),
  ];

  // 3. DỮ LIỆU CẤU HÌNH ĐƯỜNG BAY CỦA 8 CHÂN MÈO (PAW FLIGHTS) HỘI TỤ
  final List<PawFlightData> pawFlights = const [
    PawFlightData(
      mx: -76,
      my: -150,
      fx: 38,
      fy: -388,
      r: -18,
      s: 0.82,
      d: 1000,
    ),
    PawFlightData(mx: -42, my: -198, fx: 46, fy: -392, r: 24, s: 0.72, d: 1065),
    PawFlightData(mx: 24, my: -170, fx: 54, fy: -386, r: -32, s: 0.9, d: 1130),
    PawFlightData(mx: 66, my: -218, fx: 42, fy: -396, r: 18, s: 0.78, d: 1195),
    PawFlightData(
      mx: -10,
      my: -238,
      fx: 58,
      fy: -390,
      r: -10,
      s: 0.84,
      d: 1260,
    ),
    PawFlightData(mx: 82, my: -184, fx: 50, fy: -394, r: 34, s: 0.74, d: 1325),
    PawFlightData(mx: 38, my: -260, fx: 44, fy: -388, r: -26, s: 0.88, d: 1390),
    PawFlightData(mx: -58, my: -222, fx: 52, fy: -392, r: 14, s: 0.8, d: 1455),
  ];

  // ==========================================
  // CONFETTI OVERLAY ANIMATIONS
  // ==========================================
  final confettiOpacity = TweenSequence<double>([
    TweenSequenceItem(tween: Tween(begin: 0, end: 1), weight: 35),
    TweenSequenceItem(tween: Tween(begin: 1, end: 0), weight: 65),
  ]);
  final confettiTranslationX = Tween<double>(begin: 0, end: 10);
  final confettiTranslationY = Tween<double>(begin: 0, end: -38);
  final confettiScale = Tween<double>(begin: 0.3, end: 1);
  final confettiRotation = Tween<double>(begin: 0, end: math.pi);

  // ==========================================
  // FLOATING TEXT OVERLAY ANIMATIONS
  // ==========================================
  final floatPlusOpacity = TweenSequence<double>([
    TweenSequenceItem(tween: Tween(begin: 0, end: 1), weight: 35),
    TweenSequenceItem(tween: Tween(begin: 1, end: 0), weight: 65),
  ]);
  final floatPlusTranslationY = TweenSequence<double>([
    TweenSequenceItem(tween: Tween(begin: 8, end: -4), weight: 35),
    TweenSequenceItem(tween: Tween(begin: -4, end: -34), weight: 65),
  ]);

  // ==========================================
  // SPARKLES OVERLAY ANIMATIONS
  // ==========================================
  final sparkleScale = TweenSequence<double>([
    TweenSequenceItem(tween: Tween(begin: 0.2, end: 1.25), weight: 35),
    TweenSequenceItem(tween: Tween(begin: 1.25, end: 0.6), weight: 65),
  ]);
  final sparkleOpacity = TweenSequence<double>([
    TweenSequenceItem(tween: Tween(begin: 0, end: 1), weight: 35),
    TweenSequenceItem(tween: Tween(begin: 1, end: 0.15), weight: 65),
  ]);
  final sparkleTranslationY = Tween<double>(begin: 0, end: -14);

  // ==========================================
  // REWARD BADGE OVERLAY ANIMATIONS
  // ==========================================
  final wiggleX = TweenSequence<double>([
    TweenSequenceItem(tween: Tween(begin: 0, end: -1), weight: 14),
    TweenSequenceItem(tween: Tween(begin: -1, end: 1), weight: 14),
    TweenSequenceItem(tween: Tween(begin: 1, end: -1), weight: 14),
    TweenSequenceItem(tween: Tween(begin: -1, end: 1), weight: 14),
    TweenSequenceItem(tween: Tween(begin: 1, end: 0), weight: 16),
    TweenSequenceItem(tween: Tween(begin: 0, end: 0), weight: 28),
  ]);
  final wiggleRotation = TweenSequence<double>([
    TweenSequenceItem(
      tween: Tween(begin: 0, end: -2.0 * (math.pi / 180.0)),
      weight: 14,
    ),
    TweenSequenceItem(
      tween: Tween(
        begin: -2.0 * (math.pi / 180.0),
        end: 2.0 * (math.pi / 180.0),
      ),
      weight: 14,
    ),
    TweenSequenceItem(
      tween: Tween(
        begin: 2.0 * (math.pi / 180.0),
        end: -1.5 * (math.pi / 180.0),
      ),
      weight: 14,
    ),
    TweenSequenceItem(
      tween: Tween(
        begin: -1.5 * (math.pi / 180.0),
        end: 1.5 * (math.pi / 180.0),
      ),
      weight: 14,
    ),
    TweenSequenceItem(
      tween: Tween(begin: 1.5 * (math.pi / 180.0), end: 0),
      weight: 16,
    ),
    TweenSequenceItem(tween: Tween(begin: 0, end: 0), weight: 28),
  ]);
  final wiggleScale = TweenSequence<double>([
    TweenSequenceItem(tween: Tween(begin: 1, end: 1.04), weight: 14),
    TweenSequenceItem(tween: Tween(begin: 1.04, end: 1.02), weight: 14),
    TweenSequenceItem(tween: Tween(begin: 1.02, end: 1.04), weight: 14),
    TweenSequenceItem(tween: Tween(begin: 1.04, end: 1.01), weight: 14),
    TweenSequenceItem(tween: Tween(begin: 1.01, end: 1.03), weight: 16),
    TweenSequenceItem(tween: Tween(begin: 1.03, end: 1), weight: 28),
  ]);
  final glowOpacity = TweenSequence<double>([
    TweenSequenceItem(tween: Tween(begin: 0, end: 0.55), weight: 45),
    TweenSequenceItem(tween: Tween(begin: 0.55, end: 0), weight: 55),
  ]);
  final headerPlusOpacity = TweenSequence<double>([
    TweenSequenceItem(tween: Tween(begin: 0, end: 1), weight: 28),
    TweenSequenceItem(tween: Tween(begin: 1, end: 0), weight: 72),
  ]);
  final headerPlusTranslationY = TweenSequence<double>([
    TweenSequenceItem(tween: Tween(begin: 8, end: -3), weight: 28),
    TweenSequenceItem(tween: Tween(begin: -3, end: -25), weight: 72),
  ]);
  final headerBurstOpacity = TweenSequence<double>([
    TweenSequenceItem(tween: Tween(begin: 0, end: 1), weight: 35),
    TweenSequenceItem(tween: Tween(begin: 1, end: 0), weight: 65),
  ]);
  final headerBurstScale = TweenSequence<double>([
    TweenSequenceItem(tween: Tween(begin: 0.4, end: 1.08), weight: 35),
    TweenSequenceItem(tween: Tween(begin: 1.08, end: 1.3), weight: 65),
  ]);
}
