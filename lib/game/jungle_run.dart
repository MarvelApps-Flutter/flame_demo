import 'package:flame/game.dart';
import 'package:flame/input.dart';
import 'package:flame/parallax.dart';
import 'package:flame_module/model/player_data.dart';
import 'package:flame_module/widget/game_over_menu.dart';
import 'package:flame_module/widget/head_up_display.dart';
import 'package:flame_module/widget/pause_menu.dart';
import 'package:flutter/material.dart';
import 'package:flame/components.dart';

import '/game/dino.dart';
import '/game/enemy_manager.dart';

class JungleRun extends FlameGame with TapDetector, HasCollisionDetection {
  static const _imageAssets = [
    'DinoSprites - tard.png',
    'AngryPig/Walk (36x30).png',
    'Bat/Flying (46x30).png',
    'Rino/Run (52x34).png',
    'Bee/Attack (36x34).png',
    'BlueBird/Flying (32x32).png',
    'Bunny/Run (34x44).png',
    'Chicken/Run (32x34).png',
    'Trunk/Run (64x32).png',
    'parallax/plx-1.png',
    'parallax/plx-2.png',
    'parallax/plx-3.png',
    'parallax/plx-4.png',
    'parallax/plx-6.png',
  ];

  late PlayerCharcter _playerCharcter;
  late PlayerData playerData;
  late EnemyManager _enemyManager;

  @override
  Future<void> onLoad() async {
    playerData = PlayerData();
    await images.loadAll(_imageAssets);

    camera.viewport = FixedResolutionViewport(Vector2(360, 180));

    final parallaxBackground = await loadParallaxComponent(
      [
        ParallaxImageData('parallax/plx-1.png'),
        ParallaxImageData('parallax/plx-2.png'),
        ParallaxImageData('parallax/plx-3.png'),
        ParallaxImageData('parallax/plx-4.png'),
        ParallaxImageData('parallax/plx-6.png'),
      ],
      baseVelocity: Vector2(10, 0),
      velocityMultiplierDelta: Vector2(1.4, 0),
    );
    add(parallaxBackground);

    return super.onLoad();
  }

  void startGamePlay() {
    _playerCharcter =
        PlayerCharcter(images.fromCache('DinoSprites - tard.png'), playerData);

    _enemyManager = EnemyManager();

    add(_playerCharcter);
    add(_enemyManager);
  }

  void _disconnectActors() {
    _playerCharcter.removeFromParent();
    _enemyManager.removeAllEnemies();
    _enemyManager.removeFromParent();
  }

  void reset() {
    _disconnectActors();
    playerData.currentScore = 0;
    playerData.lives = 3;
  }

  @override
  void update(double dt) {
    if (playerData.lives <= 0) {
      overlays.add(GameOverMenu.id);
      overlays.remove(HeadUpDisplay.id);
      pauseEngine();
    }
    super.update(dt);
  }

  @override
  void onTapDown(TapDownInfo info) {
    if (overlays.isActive(HeadUpDisplay.id)) {
      _playerCharcter.jump();
    }
    super.onTapDown(info);
  }

  @override
  void lifecycleStateChange(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.resumed:
        if (!(overlays.isActive(PauseMenu.id)) &&
            !(overlays.isActive(GameOverMenu.id))) {
          resumeEngine();
        }
        break;
      case AppLifecycleState.paused:
      case AppLifecycleState.detached:
      case AppLifecycleState.inactive:
        if (overlays.isActive(HeadUpDisplay.id)) {
          overlays.remove(HeadUpDisplay.id);
          overlays.add(PauseMenu.id);
        }
        pauseEngine();
        break;
    }
    super.lifecycleStateChange(state);
  }
}
