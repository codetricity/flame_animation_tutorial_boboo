import 'package:animate/actors/character_component.dart';
import 'package:animate/boboo_game.dart';
import 'package:flutter/material.dart';

class PlantButton extends StatelessWidget {
  const PlantButton({
    super.key,
    required this.game,
  });

  final BobooGame game;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        final characters = game.children.query<CharacterComponent>();
        game.removeAll(characters);
        game.add(game.plant);
      },
      child: Image.asset(
        'assets/images/plant_solo.png',
        height: 50,
        width: 50,
        fit: BoxFit.fill,
      ),
    );
  }
}
