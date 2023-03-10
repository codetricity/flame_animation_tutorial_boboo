import 'dart:async';

import 'package:animate/boboo_game.dart';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flutter/widgets.dart' show debugPrint;

class Door extends SpriteComponent
    with HasGameRef<BobooGame>, CollisionCallbacks {
  @override
  FutureOr<void> onLoad() async {
    // debugMode = true;
    add(RectangleHitbox());
    sprite = await gameRef.loadSprite('door.webp');
    return super.onLoad();
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    switch (gameRef.sceneNumber) {
      case 1:
        gameRef.sceneNumber = 2;
        debugPrint('add return door');
        gameRef.add(gameRef.returnDoor);
        break;
      case 2:
        gameRef.sceneNumber = 3;
        removeFromParent();
        break;
      default:
        break;
    }
    gameRef.resetScene = true;
    super.onCollision(intersectionPoints, other);
  }

  @override
  void onGameResize(Vector2 size) {
    this.size = Vector2.all(size.y * .2);
    position = Vector2(size.x * .8, size.y * .7);
    super.onGameResize(size);
  }
}
