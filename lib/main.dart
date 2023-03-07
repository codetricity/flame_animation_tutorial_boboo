import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flame/input.dart';
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

void main() {
  runApp(const GameWidget.controlled(gameFactory: BobooGame.new));
}

class BobooGame extends FlameGame with HasTappables {
  SpriteAnimationGroupComponent<BobooState> boboo =
      SpriteAnimationGroupComponent<BobooState>();

  @override
  Color backgroundColor() => const Color.fromARGB(255, 41, 98, 139);
  @override
  FutureOr<void> onLoad() async {
    boboo
      ..animations = {
        BobooState.idleSouth: await createAnimation(row: 1),
        BobooState.idleNorth: await createAnimation(row: 2),
        BobooState.idleEast: await createAnimation(row: 3),
      }
      ..anchor = Anchor.center
      ..current = BobooState.idleSouth;

    add(boboo);

    add(ButtonComponent(
      button: TextComponent(text: 'up'),
      position: Vector2(10, 10),
      onPressed: () => boboo.current = BobooState.idleNorth,
    ));
    add(ButtonComponent(
      button: TextComponent(text: 'down'),
      position: Vector2(60, 10),
      onPressed: () => boboo.current = BobooState.idleSouth,
    ));

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
  void onGameResize(Vector2 canvasSize) {
    boboo
      ..size = canvasSize.x > canvasSize.y
          ? Vector2.all(canvasSize.y)
          : Vector2.all(canvasSize.x)
      ..position = canvasSize / 2;
    super.onGameResize(canvasSize);
  }
}
