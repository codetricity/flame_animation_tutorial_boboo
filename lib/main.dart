import 'package:animate/boboo_game.dart';
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
      )),
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
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            InkWell(
              onTap: () {},
              child: Image.asset(
                'assets/images/plant_solo.png',
                height: 50,
                width: 50,
                fit: BoxFit.fill,
              ),
            )
          ],
        ),
      ],
    );
  }
}
