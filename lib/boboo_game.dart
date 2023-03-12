import 'dart:async';

import 'package:animate/actors/character_component.dart';
import 'package:animate/world/door.dart';
import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flame/palette.dart';
import 'package:flutter/material.dart';

class BobooGame extends FlameGame
    with HasTappables, HasDraggables, HasCollisionDetection {
  late final JoystickComponent joystick;
  late final TextComponent joystickDirectionText;
  final SpriteComponent background = SpriteComponent();
  int sceneNumber = 1;
  bool resetScene = false;
  late final CharacterComponent boboo;
  late final CharacterComponent plant;
  late final CharacterComponent dog;
  late final CharacterComponent cat;
  late final CharacterComponent person;
  late final CharacterComponent icecream;
  late final CharacterComponent cactus;
  late final CharacterComponent cupcake;
  late final CharacterComponent candy;

  late final Sprite houseSprite;
  late final Sprite officeSprite;
  late final Sprite livingroomSprite;

  final door = Door();

  @override
  Color backgroundColor() => const Color.fromARGB(255, 41, 98, 139);
  @override
  FutureOr<void> onLoad() async {
    houseSprite = await loadSprite('house_background.png');
    officeSprite = await loadSprite('office_background.png');
    livingroomSprite = await loadSprite('livingroom_background.png');
    add(
      background
        ..sprite = houseSprite
        ..size = size,
    );

    final knobPaint = BasicPalette.red.withAlpha(170).paint();
    final backgroundPaint = BasicPalette.black.withAlpha(100).paint();
    joystick = JoystickComponent(
      knob: CircleComponent(radius: 30, paint: knobPaint),
      background: CircleComponent(radius: 100, paint: backgroundPaint),
      margin: const EdgeInsets.only(left: 20, bottom: 20),
    );

    add(door);
    boboo = CharacterComponent(
      speed: 2.1,
      joystick: joystick,
      image: await images.load('boboo.png'),
    );
    add(boboo);

    plant = CharacterComponent(
      speed: 1.2,
      joystick: joystick,
      image: await images.load('plant.png'),
    );
    dog = CharacterComponent(
      speed: 1.3,
      joystick: joystick,
      image: await images.load('dog.png'),
    );
    cat = CharacterComponent(
      speed: 1.4,
      joystick: joystick,
      image: await images.load('cat.png'),
    );
    person = CharacterComponent(
      speed: 2,
      joystick: joystick,
      image: await images.load('person.png'),
    );
    icecream = CharacterComponent(
      speed: 1.1,
      joystick: joystick,
      image: await images.load('icecream.png'),
    );
    cactus = CharacterComponent(
      speed: 2.0,
      joystick: joystick,
      image: await images.load('cactus.png'),
    );
    cupcake = CharacterComponent(
      speed: 2.0,
      joystick: joystick,
      image: await images.load('cupcake.png'),
    );
    candy = CharacterComponent(
      speed: 2.0,
      joystick: joystick,
      image: await images.load('candy.png'),
    );
    add(joystick);
    joystickDirectionText = TextComponent(
      text: 'joystick direction: ${joystick.direction}',
      position: Vector2(10, 10),
    );
    // add(joystickDirectionText);

    return super.onLoad();
  }

  @override
  void update(double dt) {
    joystickDirectionText.text = joystick.direction.toString();
    if (resetScene) {
      switch (sceneNumber) {
        case 1:
          background.sprite = houseSprite;
          break;
        case 2:
          background.sprite = officeSprite;
          break;
        case 3:
          background.sprite = livingroomSprite;
          break;
        default:
          break;
      }
    }
    super.update(dt);
  }

  @override
  void onGameResize(Vector2 canvasSize) {
    background.size = canvasSize;
    super.onGameResize(canvasSize);
  }
}
