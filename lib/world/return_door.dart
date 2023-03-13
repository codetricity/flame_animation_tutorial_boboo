import 'dart:async';

import 'package:animate/boboo_game.dart';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';

class ReturnDoor extends SpriteComponent
    with HasGameRef<BobooGame>, CollisionCallbacks {
  @override
  FutureOr<void> onLoad() async {
    // debugMode = true;
    add(RectangleHitbox());
    sprite = await gameRef.loadSprite('world/return_door.png');
    return super.onLoad();
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    switch (gameRef.sceneNumber) {
      case 2:
        removeFromParent();
        gameRef.sceneNumber = 1;
        break;
      case 3:
        gameRef.sceneNumber = 2;
        gameRef.add(gameRef.door);
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
    position = Vector2(10, size.y * .4);
    super.onGameResize(size);
  }
}
