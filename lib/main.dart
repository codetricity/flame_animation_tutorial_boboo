import 'package:animate/boboo_game.dart';
import 'package:animate/flutter_layer/flutter_controls.dart';
import 'package:flame/flame.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  Flame.device.setLandscape();
  Flame.device.fullScreen();
  final game = BobooGame();
  runApp(
    MaterialApp(
      home: Scaffold(
        body: BobooApp(
          game: game,
        ),
      ),
    ),
  );
}

class BobooApp extends StatelessWidget {
  final BobooGame game;
  const BobooApp({super.key, required this.game});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        GameWidget(game: game),
        FlutterControls(game: game),
      ],
    );
  }
}
