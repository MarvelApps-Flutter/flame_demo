import 'package:flame/game.dart';
import 'package:flutter/material.dart';

import 'game/jungle_run.dart';
import 'widget/game_over_menu.dart';
import 'widget/head_up_display.dart';
import 'widget/main_menu.dart';
import 'widget/pause_menu.dart';

class MainGamePage extends StatefulWidget {
  const MainGamePage({Key? key}) : super(key: key);

  @override
  State<MainGamePage> createState() => _MainGamePageState();
}

class _MainGamePageState extends State<MainGamePage> {
  final JungleRun _jungleRun = JungleRun();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GameWidget(
        loadingBuilder: (conetxt) => const Center(
          child: SizedBox(
            width: 200,
            child: LinearProgressIndicator(),
          ),
        ),
        overlayBuilderMap: {
          MainMenu.id: (_, JungleRun gameRef) => MainMenu(gameRef),
          PauseMenu.id: (_, JungleRun gameRef) => PauseMenu(gameRef),
          HeadUpDisplay.id: (_, JungleRun gameRef) => HeadUpDisplay(gameRef),
          GameOverMenu.id: (_, JungleRun gameRef) => GameOverMenu(gameRef),
        },
        initialActiveOverlays: const [MainMenu.id],
        game: _jungleRun,
      ),
    );
  }
}
