import 'dart:async';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';

import 'main.dart';

class Door extends SpriteComponent
    with HasGameRef<BobooGame>, CollisionCallbacks {
  @override
  FutureOr<void> onLoad() async {
    debugMode = true;
    add(RectangleHitbox());
    sprite = await gameRef.loadSprite('door.webp');
    return super.onLoad();
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    print('collision');
    super.onCollision(intersectionPoints, other);
  }

  @override
  void onGameResize(Vector2 size) {
    this.size = Vector2.all(size.y * .2);
    position = Vector2(size.x * .8, size.y * .7);
    print(size);
    super.onGameResize(size);
  }
}
