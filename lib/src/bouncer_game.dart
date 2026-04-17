import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:sensors_plus/sensors_plus.dart';

import 'package:bouncer/src/model.dart';

class BouncerGame extends StatefulWidget {
  const BouncerGame({super.key, this.accelerometerStream});

  final Stream<AccelerometerEvent>? accelerometerStream;

  @override
  State<BouncerGame> createState() => _BouncerGameState();
}

class _BouncerGameState extends State<BouncerGame>
    with SingleTickerProviderStateMixin {
  List<Block> _blocks = [];

  Offset _ballPosition = const Offset(200, 400);
  Offset _ballVelocity = const Offset(170, -200);

  final double _ballRadius = 10;
  double _paddleX = 0;
  double get _paddleTop => MediaQuery.of(context).size.height - 80;
  late Ticker _ticker;

  @override
  void initState() {
    super.initState();

    _ticker = createTicker((elapsed) {
      _updateBall(1 / 60);
    });

    _ticker.start();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _generateBlocks();
  }

  void _updateBall(double dt) {
    final screenSize = MediaQuery.of(context).size;

    double x = _ballPosition.dx + _ballVelocity.dx * dt;
    double y = _ballPosition.dy + _ballVelocity.dy * dt;

    // 🧱 collision مع الحواف
    if (x <= 0 || x >= screenSize.width - _ballRadius * 2) {
      _ballVelocity = Offset(-_ballVelocity.dx, _ballVelocity.dy);
    }

    if (y <= 0) {
      _ballVelocity = Offset(_ballVelocity.dx, -_ballVelocity.dy);
    }

    setState(() {
      _ballPosition = Offset(x, y);
    });
  }

  void _generateBlocks() {
    final screenWidth = MediaQuery.of(context).size.width;

    final blockWidth =
        (screenWidth - GameConfig.blockInset * 2) / GameConfig.columns;

    final blocks = <Block>[];

    for (int row = 0; row < GameConfig.rows; row++) {
      for (int col = 0; col < GameConfig.columns; col++) {
        final left = GameConfig.blockInset + col * blockWidth;
        final top = 60 + row * (GameConfig.blockHeight + GameConfig.blockGap);

        blocks.add(
          Block(
            rect: Rect.fromLTWH(
              left,
              top,
              blockWidth - GameConfig.blockGap,
              GameConfig.blockHeight,
            ),
            color: rowColor(row),
          ),
        );
      }
    }

    _blocks = blocks;
  }

  @override
  void dispose() {
    _ticker.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // blocks
          ..._blocks.map((block) {
            return Positioned(
              left: block.rect.left,
              top: block.rect.top,
              width: block.rect.width,
              height: block.rect.height,
              child: Container(
                decoration: BoxDecoration(
                  color: block.color,
                  borderRadius: BorderRadius.circular(6),
                ),
              ),
            );
          }),

          Positioned(
            left: _paddleX,
            top: _paddleTop,
            child: Container(
              width: GameConfig.paddleWidth,
              height: GameConfig.paddleHeight,
              decoration: BoxDecoration(
                color: const Color(0xFF4DD0E1),
                borderRadius: BorderRadius.circular(
                  GameConfig.paddleHeight / 2,
                ),
              ),
            ),
          ),

          // الكرة ⚽
          Positioned(
            left: _ballPosition.dx,
            top: _ballPosition.dy,
            child: Container(
              width: _ballRadius * 2,
              height: _ballRadius * 2,
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
