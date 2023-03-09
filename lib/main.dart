import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flame/palette.dart';
import 'package:flutter/material.dart';

enum BobooState {
  idleNorth,
  idleSouth,
  idleWest,
  idleEast,
  moveNorth,
  moveSouth,
  moveWest,
  moveEast
}

enum BobooDirection { right, left, up, down }

void main() {
  runApp(const GameWidget.controlled(gameFactory: BobooGame.new));
}

class BobooGame extends FlameGame with HasTappables, HasDraggables {
  SpriteAnimationGroupComponent<BobooState> boboo =
      SpriteAnimationGroupComponent<BobooState>();
  late final JoystickComponent joystick;
  BobooDirection bobooDirection = BobooDirection.down;
  final speed = 1.5;
  late TextComponent joystickDirectionText;

  @override
  Color backgroundColor() => const Color.fromARGB(255, 41, 98, 139);
  @override
  FutureOr<void> onLoad() async {
    boboo
      ..animations = {
        BobooState.idleSouth: await createAnimation(row: 1),
        BobooState.idleNorth: await createAnimation(row: 2),
        BobooState.idleEast: await createAnimation(row: 3),
        BobooState.idleWest: await createAnimation(row: 4),
        BobooState.moveSouth: await createAnimation(row: 5),
        BobooState.moveNorth: await createAnimation(row: 6),
        BobooState.moveEast: await createAnimation(row: 7),
        BobooState.moveWest: await createAnimation(row: 8),
      }
      ..anchor = Anchor.center
      ..current = BobooState.idleSouth;

    add(boboo);

    final knobPaint = BasicPalette.blue.withAlpha(200).paint();
    final backgroundPaint = BasicPalette.blue.withAlpha(100).paint();
    joystick = JoystickComponent(
      knob: CircleComponent(radius: 30, paint: knobPaint),
      background: CircleComponent(radius: 100, paint: backgroundPaint),
      margin: const EdgeInsets.only(left: 40, bottom: 40),
    );
    add(joystick);
    joystickDirectionText = TextComponent(
        text: 'joystick direction: ${joystick.direction}',
        position: Vector2(10, 10));
    add(joystickDirectionText);
    return super.onLoad();
  }

  Future<SpriteAnimation> createAnimation({required int row}) async {
    final animationData = SpriteAnimationData.sequenced(
      amount: 4,
      stepTime: 0.2,
      textureSize: Vector2.all(32),
      texturePosition: Vector2(0, 32.0 * (row - 1)),
    );

    final spriteAnimation = SpriteAnimation.fromFrameData(
        await images.load('boboo.png'), animationData);
    return spriteAnimation;
  }

  @override
  void update(double dt) {
    if (joystick.direction == JoystickDirection.idle) {
      switch (bobooDirection) {
        case BobooDirection.right:
          boboo.current = BobooState.idleEast;
          break;
        case BobooDirection.left:
          boboo.current = BobooState.idleWest;
          break;
        case BobooDirection.up:
          boboo.current = BobooState.idleNorth;
          break;
        case BobooDirection.down:
          boboo.current = BobooState.idleSouth;
          break;
      }
    }

    switch (joystick.direction) {
      case JoystickDirection.down:
        bobooDirection = BobooDirection.down;
        boboo.current = BobooState.moveSouth;
        if (boboo.y < size.y) {
          boboo.y += joystick.delta.y * speed * dt;
        }
        break;
      case JoystickDirection.up:
        bobooDirection = BobooDirection.up;
        boboo.current = BobooState.moveNorth;
        if (boboo.y > 0) {
          boboo.y += joystick.delta.y * speed * dt;
        }
        break;
      case JoystickDirection.left:
        bobooDirection = BobooDirection.left;
        boboo.current = BobooState.moveWest;
        if (boboo.x > 0) {
          boboo.x += joystick.delta.x * speed * dt;
        }
        break;
      case JoystickDirection.right:
        bobooDirection = BobooDirection.right;
        boboo.current = BobooState.moveEast;
        if (boboo.x < size.x) {
          boboo.x += joystick.delta.x * speed * dt;
        }
        break;
      default:
        break;
    }

    joystickDirectionText.text = joystick.direction.toString();

    super.update(dt);
  }

  @override
  void onGameResize(Vector2 canvasSize) {
    boboo
      ..size = canvasSize.x > canvasSize.y
          ? Vector2.all(canvasSize.y)
          : Vector2.all(canvasSize.x)
      ..position = canvasSize / 2;
    super.onGameResize(canvasSize);
  }
}
