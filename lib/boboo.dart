import 'dart:async';

import 'package:animate/main.dart';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';

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

class Boboo extends SpriteAnimationGroupComponent<BobooState>
    with HasGameRef<BobooGame> {
  final double speed;
  final JoystickComponent joystick;
  Boboo({required this.speed, required this.joystick});
  BobooDirection bobooDirection = BobooDirection.down;

  @override
  FutureOr<void> onLoad() async {
    // debugMode = true;
    anchor = Anchor.center;
    add(
      RectangleHitbox.relative(
        Vector2.all(.5),
        parentSize: size,
        anchor: Anchor.center,
      ),
    );

    animations = {
      BobooState.idleSouth: await createAnimation(row: 1),
      BobooState.idleNorth: await createAnimation(row: 2),
      BobooState.idleEast: await createAnimation(row: 3),
      BobooState.idleWest: await createAnimation(row: 4),
      BobooState.moveSouth: await createAnimation(row: 5),
      BobooState.moveNorth: await createAnimation(row: 6),
      BobooState.moveEast: await createAnimation(row: 7),
      BobooState.moveWest: await createAnimation(row: 8),
    };
    current = BobooState.idleSouth;
    return super.onLoad();
  }

  @override
  void onGameResize(Vector2 size) {
    this.size =
        size.x > size.y ? Vector2.all(size.y) * .5 : Vector2.all(size.x) * .5;
    position = size / 2;
    super.onGameResize(size);
  }

  Future<SpriteAnimation> createAnimation({required int row}) async {
    final animationData = SpriteAnimationData.sequenced(
      amount: 4,
      stepTime: 0.2,
      textureSize: Vector2.all(32),
      texturePosition: Vector2(0, 32.0 * (row - 1)),
    );

    final spriteAnimation = SpriteAnimation.fromFrameData(
      await gameRef.images.load('boboo.png'),
      animationData,
    );
    return spriteAnimation;
  }

  @override
  void update(double dt) {
    if (joystick.direction == JoystickDirection.idle) {
      switch (bobooDirection) {
        case BobooDirection.right:
          current = BobooState.idleEast;
          break;
        case BobooDirection.left:
          current = BobooState.idleWest;
          break;
        case BobooDirection.up:
          current = BobooState.idleNorth;
          break;
        case BobooDirection.down:
          current = BobooState.idleSouth;
          break;
      }
    }

    switch (joystick.direction) {
      case JoystickDirection.down:
        bobooDirection = BobooDirection.down;
        current = BobooState.moveSouth;
        if (y < gameRef.size.y) {
          y += joystick.delta.y * speed * dt;
        }
        break;
      case JoystickDirection.up:
        bobooDirection = BobooDirection.up;
        current = BobooState.moveNorth;
        if (y > 0) {
          y += joystick.delta.y * speed * dt;
        }
        break;
      case JoystickDirection.left:
        bobooDirection = BobooDirection.left;
        current = BobooState.moveWest;
        if (x > 0) {
          x += joystick.delta.x * speed * dt;
        }
        break;
      case JoystickDirection.right:
        bobooDirection = BobooDirection.right;
        current = BobooState.moveEast;
        if (x < gameRef.size.x) {
          x += joystick.delta.x * speed * dt;
        }
        break;
      default:
        break;
    }

    super.update(dt);
  }
}
