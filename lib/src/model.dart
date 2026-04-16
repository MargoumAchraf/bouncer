import 'dart:math' as math;

import 'package:flutter/material.dart';

class GameConfig {
  const GameConfig._();

  static const ballRadius = 10.0;
  static const paddleWidth = 96.0;
  static const paddleHeight = 14.0;
  static const paddleBottomMargin = 28.0;
  static const rows = 4;
  static const columns = 6;
  static const blockHeight = 24.0;
  static const blockGap = 10.0;
  static const minSpeed = 240.0;
  static const maxSpeed = 340.0;
  static const blockInset = 16.0;
  static const paddleSpeed = 180.0;
}

class Block {
  const Block({required this.rect, required this.color});

  final Rect rect;
  final Color color;
}

extension NormalizedOffset on Offset {
  Offset get normalized {
    final magnitude = distance;
    return magnitude == 0 ? this : this / magnitude;
  }
}

Color rowColor(int row) {
  return Color.lerp(
    const Color(0xFF6CE5E8),
    const Color(0xFFFFB86B),
    row / math.max(1, GameConfig.rows - 1),
  )!;
}