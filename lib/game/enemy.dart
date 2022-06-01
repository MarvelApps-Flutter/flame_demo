import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame_module/model/enemy_data.dart';

import 'jungle_run.dart';

class Enemy extends SpriteAnimationComponent
    with CollisionCallbacks, HasGameRef<JungleRun> {
  final EnemyData enemyData;

  Enemy(this.enemyData) {
    animation = SpriteAnimation.fromFrameData(
      enemyData.image,
      SpriteAnimationData.sequenced(
        amount: enemyData.nFrames,
        stepTime: enemyData.stepTime,
        textureSize: enemyData.textureSize,
      ),
    );
  }

  @override
  void onMount() {
    size *= 0.6;
    add(
      RectangleHitbox.relative(
        Vector2.all(0.8),
        parentSize: size,
        position: Vector2(size.x * 0.2, size.y * 0.2) / 2,
      ),
    );
    super.onMount();
  }

  @override
  void update(double dt) {
    position.x -= enemyData.speedX * dt;
    if (position.x < -enemyData.textureSize.x) {
      removeFromParent();
      gameRef.playerData.currentScore += 1;
    }

    super.update(dt);
  }
}
