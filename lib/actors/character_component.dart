import 'dart:async';

import 'package:animate/boboo_game.dart';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/image_composition.dart';

enum CharacterState {
  idleNorth,
  idleSouth,
  idleWest,
  idleEast,
  moveNorth,
  moveSouth,
  moveWest,
  moveEast
}

enum CharacterDirection { right, left, up, down }

class CharacterComponent extends SpriteAnimationGroupComponent<CharacterState>
    with HasGameRef<BobooGame> {
  final double speed;
  final JoystickComponent joystick;
  final Image image;
  CharacterComponent({
    required this.speed,
    required this.joystick,
    required this.image,
  });
  CharacterDirection characterDirection = CharacterDirection.down;

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
      CharacterState.idleSouth: await createAnimation(row: 1),
      CharacterState.idleNorth: await createAnimation(row: 2),
      CharacterState.idleEast: await createAnimation(row: 3),
      CharacterState.idleWest: await createAnimation(row: 4),
      CharacterState.moveSouth: await createAnimation(row: 5),
      CharacterState.moveNorth: await createAnimation(row: 6),
      CharacterState.moveEast: await createAnimation(row: 7),
      CharacterState.moveWest: await createAnimation(row: 8),
    };
    current = CharacterState.idleSouth;
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
      // await gameRef.images.load('dog.png'),
      image,
      animationData,
    );
    return spriteAnimation;
  }

  @override
  void update(double dt) {
    if (joystick.direction == JoystickDirection.idle) {
      switch (characterDirection) {
        case CharacterDirection.right:
          current = CharacterState.idleEast;
          break;
        case CharacterDirection.left:
          current = CharacterState.idleWest;
          break;
        case CharacterDirection.up:
          current = CharacterState.idleNorth;
          break;
        case CharacterDirection.down:
          current = CharacterState.idleSouth;
          break;
      }
    }

    switch (joystick.direction) {
      case JoystickDirection.down:
        characterDirection = CharacterDirection.down;
        current = CharacterState.moveSouth;
        if (y < gameRef.size.y) {
          y += joystick.delta.y * speed * dt;
        }
        break;
      case JoystickDirection.up:
        characterDirection = CharacterDirection.up;
        current = CharacterState.moveNorth;
        if (y > 0) {
          y += joystick.delta.y * speed * dt;
        }
        break;
      case JoystickDirection.left:
        characterDirection = CharacterDirection.left;
        current = CharacterState.moveWest;
        if (x > 0) {
          x += joystick.delta.x * speed * dt;
        }
        break;
      case JoystickDirection.right:
        characterDirection = CharacterDirection.right;
        current = CharacterState.moveEast;
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
