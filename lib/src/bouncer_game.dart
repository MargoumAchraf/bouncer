import 'package:flutter/material.dart';
import 'package:sensors_plus/sensors_plus.dart';
import 'dart:async';

class BouncerGame extends StatefulWidget {
  const BouncerGame({super.key, this.accelerometerStream});

  final Stream<AccelerometerEvent>? accelerometerStream;

  @override
  State<BouncerGame> createState() => _BouncerGameState();
}

class _BouncerGameState extends State<BouncerGame>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  double _ballX = 0.0;
  double _ballY = 0.0;
  double _ballVelocityX = 0.0;
  double _ballVelocityY = 0.0;

  final double _ballRadius = 20.0;
  final double _gravity = 0.5;
  final double _damping = 0.8;

  double _screenWidth = 0.0;
  double _screenHeight = 0.0;

  late StreamSubscription<AccelerometerEvent> _accelerometerSubscription;

  @override
  void initState() {
    super.initState();

    // 🎮 Animation loop
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 16),
    )..addListener(_updatePhysics);

    _controller.repeat();

    // 📱 Accelerometer
    _accelerometerSubscription =
        (widget.accelerometerStream ?? accelerometerEvents)
            .listen((AccelerometerEvent event) {
      _ballVelocityX += event.x * 0.2;
      _ballVelocityY += event.y * 0.2;
    });
  }

  void _updatePhysics() {
    setState(() {
      _ballVelocityY += _gravity;

      _ballX += _ballVelocityX;
      _ballY += _ballVelocityY;

      // 🧱 collision مع الحواف

      // left & right
      if (_ballX <= 0) {
        _ballX = 0;
        _ballVelocityX = -_ballVelocityX * _damping;
      } else if (_ballX >= _screenWidth - _ballRadius * 2) {
        _ballX = _screenWidth - _ballRadius * 2;
        _ballVelocityX = -_ballVelocityX * _damping;
      }

      // top & bottom
      if (_ballY <= 0) {
        _ballY = 0;
        _ballVelocityY = -_ballVelocityY * _damping;
      } else if (_ballY >= _screenHeight - _ballRadius * 2) {
        _ballY = _screenHeight - _ballRadius * 2;
        _ballVelocityY = -_ballVelocityY * _damping;
      }

      // friction
      _ballVelocityX *= 0.99;
      _ballVelocityY *= 0.99;
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _accelerometerSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _screenWidth = MediaQuery.of(context).size.width;
    _screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Stack(
        children: [
          Positioned(
            left: _ballX,
            top: _ballY,
            child: Container(
              width: _ballRadius * 2,
              height: _ballRadius * 2,
              decoration: const BoxDecoration(
                color: Colors.cyan,
                shape: BoxShape.circle,
              ),
            ),
          ),
        ],
      ),
    );
  }
}