import 'dart:math';
import 'package:flutter/material.dart';

/// Returns a vibrant, deep color with semi-transparent alpha (35-40)
Color randomVibrantColorWithAlpha() {
  final random = Random();

  // Blue hue range in HSV: approx 180°–260° (cyan to indigo)
  final double hue = 180 + random.nextDouble() * 80; // 180-260

  // High saturation for vibrancy
  final double saturation = 0.6 + random.nextDouble() * 0.4; // 60%-100%

  // Random light or dark
  final bool isDark = random.nextBool();
  final double value = isDark
      ? 0.25 +
            random.nextDouble() *
                0.25 // Dark: 0.25–0.5
      : 0.6 + random.nextDouble() * 0.3; // Light: 0.6–0.9

  // Full opacity
  return HSVColor.fromAHSV(1.0, hue, saturation, value).toColor();
}
