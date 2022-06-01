import 'dart:math';

import 'package:flame/components.dart';
import 'package:flame_module/model/enemy_data.dart';

import '/game/enemy.dart';
import 'jungle_run.dart';

class EnemyManager extends Component with HasGameRef<JungleRun> {
  final List<EnemyData> _data = [];

  final Random _random = Random();

  final Timer _timer = Timer(2, repeat: true);

  EnemyManager() {
    _timer.onTick = spawnRandomEnemy;
  }

  void spawnRandomEnemy() {
    final randomIndex = _random.nextInt(_data.length);
    final enemyData = _data.elementAt(randomIndex);
    final enemy = Enemy(enemyData);

    enemy.anchor = Anchor.bottomLeft;
    enemy.position = Vector2(
      gameRef.size.x + 32,
      gameRef.size.y - 24,
    );

    if (enemyData.canFly) {
      final newHeight = _random.nextDouble() * 2 * enemyData.textureSize.y;
      enemy.position.y -= newHeight;
    }
    enemy.size = enemyData.textureSize;
    gameRef.add(enemy);
  }

  @override
  void onMount() {
    if (isMounted) {
      shouldRemove = false;
    }

    if (_data.isEmpty) {
      _data.addAll([
        EnemyData(
          image: gameRef.images.fromCache('AngryPig/Walk (36x30).png'),
          nFrames: 16,
          stepTime: 0.1,
          textureSize: Vector2(36, 30),
          speedX: 80,
          canFly: false,
        ),
        EnemyData(
          image: gameRef.images.fromCache('Bat/Flying (46x30).png'),
          nFrames: 7,
          stepTime: 0.1,
          textureSize: Vector2(46, 30),
          speedX: 100,
          canFly: true,
        ),
        EnemyData(
          image: gameRef.images.fromCache('Bee/Attack (36x34).png'),
          nFrames: 8,
          stepTime: 0.1,
          textureSize: Vector2(36, 34),
          speedX: 100,
          canFly: true,
        ),
        EnemyData(
          image: gameRef.images.fromCache('BlueBird/Flying (32x32).png'),
          nFrames: 9,
          stepTime: 0.1,
          textureSize: Vector2(32, 32),
          speedX: 110,
          canFly: true,
        ),
        EnemyData(
          image: gameRef.images.fromCache('Bunny/Run (34x44).png'),
          nFrames: 12,
          stepTime: 0.1,
          textureSize: Vector2(34, 44),
          speedX: 90,
          canFly: false,
        ),
        EnemyData(
          image: gameRef.images.fromCache('Chicken/Run (32x34).png'),
          nFrames: 14,
          stepTime: 0.1,
          textureSize: Vector2(32, 34),
          speedX: 90,
          canFly: false,
        ),
        EnemyData(
          image: gameRef.images.fromCache('Trunk/Run (64x32).png'),
          nFrames: 14,
          stepTime: 0.1,
          textureSize: Vector2(64, 32),
          speedX: 90,
          canFly: false,
        ),
        EnemyData(
          image: gameRef.images.fromCache('Rino/Run (52x34).png'),
          nFrames: 6,
          stepTime: 0.09,
          textureSize: Vector2(52, 34),
          speedX: 150,
          canFly: false,
        ),
      ]);
    }
    _timer.start();
    super.onMount();
  }

  @override
  void update(double dt) {
    _timer.update(dt);
    super.update(dt);
  }

  void removeAllEnemies() {
    final enemies = gameRef.children.whereType<Enemy>();
    for (var enemy in enemies) {
      enemy.removeFromParent();
    }
  }
}
