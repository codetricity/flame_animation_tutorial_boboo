import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flame/palette.dart';
import 'package:flutter/material.dart';

import 'boboo.dart';
import 'door.dart';

void main() {
  runApp(const GameWidget.controlled(gameFactory: BobooGame.new));
}

class BobooGame extends FlameGame
    with HasTappables, HasDraggables, HasCollisionDetection {
  late final JoystickComponent joystick;
  late final TextComponent joystickDirectionText;
  final SpriteComponent background = SpriteComponent();
  int sceneNumber = 1;
  bool resetScene = false;
  late final Boboo boboo;

  late final Sprite houseSprite;
  late final Sprite officeSprite;
  late final Sprite livingroomSprite;

  @override
  Color backgroundColor() => const Color.fromARGB(255, 41, 98, 139);
  @override
  FutureOr<void> onLoad() async {
    houseSprite = await loadSprite('house_background.png');
    officeSprite = await loadSprite('office_background.png');
    livingroomSprite = await loadSprite('livingroom_background.png');
    add(background
      ..sprite = houseSprite
      ..size = size);

    final knobPaint = BasicPalette.red.withAlpha(170).paint();
    final backgroundPaint = BasicPalette.black.withAlpha(100).paint();
    joystick = JoystickComponent(
      knob: CircleComponent(radius: 30, paint: knobPaint),
      background: CircleComponent(radius: 100, paint: backgroundPaint),
      margin: const EdgeInsets.only(left: 20, bottom: 20),
    );

    add(Door());
    boboo = Boboo(speed: 1.5, joystick: joystick);
    add(boboo);

    add(joystick);
    joystickDirectionText = TextComponent(
        text: 'joystick direction: ${joystick.direction}',
        position: Vector2(10, 10));
    add(joystickDirectionText);

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
      boboo.position = canvasSize / 2;
      resetScene = false;
    }
    super.update(dt);
  }

  @override
  void onGameResize(Vector2 canvasSize) {
    background.size = canvasSize;
    super.onGameResize(canvasSize);
  }
}
