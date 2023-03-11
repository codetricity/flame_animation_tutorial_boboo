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
  final boboo = Boboo();
  late final JoystickComponent joystick;
  final speed = 1.5;
  late TextComponent joystickDirectionText;
  SpriteComponent background = SpriteComponent();

  @override
  Color backgroundColor() => const Color.fromARGB(255, 41, 98, 139);
  @override
  FutureOr<void> onLoad() async {
    add(background
      ..sprite = await loadSprite('background.png')
      ..size = size);

    add(boboo);

    final knobPaint = BasicPalette.red.withAlpha(170).paint();
    final backgroundPaint = BasicPalette.black.withAlpha(100).paint();
    joystick = JoystickComponent(
      knob: CircleComponent(radius: 30, paint: knobPaint),
      background: CircleComponent(radius: 100, paint: backgroundPaint),
      margin: const EdgeInsets.only(left: 20, bottom: 20),
    );

    add(Door());
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
    super.update(dt);
  }

  @override
  void onGameResize(Vector2 canvasSize) {
    background.size = canvasSize;
    super.onGameResize(canvasSize);
  }
}
