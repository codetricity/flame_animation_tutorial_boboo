import 'package:animate/boboo_game.dart';
import 'package:animate/flutter_layer/character_button.dart';
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
            CharacterButton(game: game, character: 'boboo'),
            CharacterButton(game: game, character: 'plant'),
            CharacterButton(game: game, character: 'dog'),
            CharacterButton(game: game, character: 'cat'),
            CharacterButton(game: game, character: 'person'),
            CharacterButton(game: game, character: 'icecream'),
            CharacterButton(game: game, character: 'cactus'),
            CharacterButton(game: game, character: 'cupcake'),
            CharacterButton(game: game, character: 'candy'),
            const SizedBox(
              width: 80,
            ),
          ],
        ),
      ],
    );
  }
}
