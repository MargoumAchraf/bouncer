import 'package:flutter/material.dart';

import 'dart:async';

import 'package:sensors_plus/sensors_plus.dart';

import 'src/bouncer_game.dart';


void main() {
  runApp(const MyApp());
}



class MyApp extends StatelessWidget {
  const MyApp({super.key, this.accelerometerStream});

  final Stream<AccelerometerEvent>? accelerometerStream;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Bouncer',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF6CE5E8),
          brightness: Brightness.dark,
        ),
        scaffoldBackgroundColor: const Color(0xFF07111F),
        useMaterial3: true,
      ),
      home: BouncerGame(accelerometerStream: accelerometerStream),
    );
  }
}