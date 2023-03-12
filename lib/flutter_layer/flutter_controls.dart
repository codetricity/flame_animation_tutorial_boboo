import 'package:animate/actors/character_component.dart';
import 'package:animate/boboo_game.dart';
import 'package:animate/flutter_layer/boboo_button.dart';
import 'package:animate/flutter_layer/plant_button.dart';
import 'package:flutter/material.dart';

class FlutterControls extends StatelessWidget {
  const FlutterControls({
    super.key,
    required this.game,
  });

  final BobooGame game;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(
          height: 10,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            PlantButton(game: game),
            BobooButton(game: game),
            const SizedBox(
              width: 80,
            ),
          ],
        ),
      ],
    );
  }
}
