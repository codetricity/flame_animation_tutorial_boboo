import 'package:animate/actors/character_component.dart';
import 'package:animate/boboo_game.dart';
import 'package:flutter/material.dart';

class CharacterButton extends StatelessWidget {
  final BobooGame game;
  final String character;

  const CharacterButton({
    super.key,
    required this.game,
    required this.character,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        final characters = game.children.query<CharacterComponent>();

        game.removeAll(characters);
        await Future.delayed(const Duration(milliseconds: 50), () {
          switch (character) {
            case 'boboo':
              game.add(game.boboo);
              break;
            case 'plant':
              game.add(game.plant);
              break;
            case 'person':
              game.add(game.person);
              break;
            case 'dog':
              game.add(game.dog);
              break;
            case 'cat':
              game.add(game.cat);
              break;
            case 'icecream':
              game.add(game.icecream);
              break;
            case 'cactus':
              game.add(game.cactus);
              break;
            default:
              break;
          }
        });
      },
      child: Image.asset(
        'assets/images/${character}_solo.png',
        height: 50,
        width: 50,
        fit: BoxFit.fill,
      ),
    );
  }
}
