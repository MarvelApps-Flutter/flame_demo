import 'dart:ui';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame_module/model/player_data.dart';

import '/game/enemy.dart';
import 'jungle_run.dart';

enum PlayerCharcterAnimationStates {
  idle,
  run,
  kick,
  hit,
  sprint,
}

class PlayerCharcter
    extends SpriteAnimationGroupComponent<PlayerCharcterAnimationStates>
    with CollisionCallbacks, HasGameRef<JungleRun> {
  static final _animationMap = {
    PlayerCharcterAnimationStates.idle: SpriteAnimationData.sequenced(
      amount: 4,
      stepTime: 0.1,
      textureSize: Vector2.all(24),
    ),
    PlayerCharcterAnimationStates.run: SpriteAnimationData.sequenced(
      amount: 6,
      stepTime: 0.1,
      textureSize: Vector2.all(24),
      texturePosition: Vector2((4) * 24, 0),
    ),
    PlayerCharcterAnimationStates.kick: SpriteAnimationData.sequenced(
      amount: 4,
      stepTime: 0.1,
      textureSize: Vector2.all(24),
      texturePosition: Vector2((4 + 6) * 24, 0),
    ),
    PlayerCharcterAnimationStates.hit: SpriteAnimationData.sequenced(
      amount: 3,
      stepTime: 0.1,
      textureSize: Vector2.all(24),
      texturePosition: Vector2((4 + 6 + 4) * 24, 0),
    ),
    PlayerCharcterAnimationStates.sprint: SpriteAnimationData.sequenced(
      amount: 7,
      stepTime: 0.1,
      textureSize: Vector2.all(24),
      texturePosition: Vector2((4 + 6 + 4 + 3) * 24, 0),
    ),
  };

  double yMax = 0.0;
  double speedY = 0.0;
  final Timer _hitTimer = Timer(1);

  static const double gravity = 800;

  final PlayerData playerData;

  bool isHit = false;

  PlayerCharcter(Image image, this.playerData)
      : super.fromFrameData(image, _animationMap);

  @override
  void onMount() {
    _reset();
    add(
      RectangleHitbox.relative(
        Vector2(0.5, 0.7),
        parentSize: size,
        position: Vector2(size.x * 0.5, size.y * 0.3) / 2,
      ),
    );
    yMax = y;
    _hitTimer.onTick = () {
      current = PlayerCharcterAnimationStates.run;
      isHit = false;
    };

    super.onMount();
  }

  @override
  void update(double dt) {
    speedY += gravity * dt;
    y += speedY * dt;
    if (isOnGround) {
      y = yMax;
      speedY = 0.0;
      if ((current != PlayerCharcterAnimationStates.hit) &&
          (current != PlayerCharcterAnimationStates.run)) {
        current = PlayerCharcterAnimationStates.run;
      }
    }

    _hitTimer.update(dt);
    super.update(dt);
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    if ((other is Enemy) && (!isHit)) {
      hit();
    }
    super.onCollision(intersectionPoints, other);
  }

  bool get isOnGround => (y >= yMax);

  void jump() {
    if (isOnGround) {
      speedY = -300;
      current = PlayerCharcterAnimationStates.idle;
    }
  }

  void hit() {
    isHit = true;
    current = PlayerCharcterAnimationStates.hit;
    _hitTimer.start();
    playerData.lives -= 1;
  }

  void _reset() {
    // if (isMounted) {
    //   shouldRemove = false;
    // }
    anchor = Anchor.bottomLeft;
    position = Vector2(32, gameRef.size.y - 22);
    size = Vector2.all(24);
    current = PlayerCharcterAnimationStates.run;
    isHit = false;
    speedY = 0.0;
  }
}
