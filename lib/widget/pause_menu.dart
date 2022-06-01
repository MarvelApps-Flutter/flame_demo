import 'dart:ui';

import 'package:flame_module/model/player_data.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../game/jungle_run.dart';
import 'head_up_display.dart';
import 'main_menu.dart';

class PauseMenu extends StatelessWidget {
  static const id = 'PauseMenu';
  final JungleRun gameRef;

  const PauseMenu(this.gameRef, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: gameRef.playerData,
      child: Center(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
          child: Card(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            color: Colors.black.withAlpha(100),
            child: FittedBox(
              fit: BoxFit.scaleDown,
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 20, horizontal: 100),
                child: Wrap(
                  direction: Axis.vertical,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  spacing: 10,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(10),
                      child: Selector<PlayerData, int>(
                        selector: (_, playerData) => playerData.currentScore,
                        builder: (_, score, __) {
                          return Text(
                            'Score: $score',
                            style: const TextStyle(
                                fontSize: 40, color: Colors.white),
                          );
                        },
                      ),
                    ),
                    Row(
                      children: [
                        GestureDetector(
                            onTap: () {
                              gameRef.overlays.remove(PauseMenu.id);
                              gameRef.overlays.add(HeadUpDisplay.id);
                              gameRef.resumeEngine();
                              gameRef.reset();
                              gameRef.startGamePlay();
                            },
                            child: const Icon(
                              Icons.restart_alt,
                              size: 70,
                              color: Colors.white,
                            )),
                        const SizedBox(
                          width: 10,
                        ),
                        GestureDetector(
                            onTap: () {
                              gameRef.overlays.remove(PauseMenu.id);
                              gameRef.overlays.add(HeadUpDisplay.id);
                              gameRef.resumeEngine();
                            },
                            child: const Icon(
                              Icons.play_circle_outlined,
                              size: 70,
                              color: Colors.white,
                            )),
                        const SizedBox(
                          width: 10,
                        ),
                        GestureDetector(
                            onTap: () {
                              gameRef.overlays.remove(PauseMenu.id);
                              gameRef.overlays.add(MainMenu.id);
                              gameRef.resumeEngine();
                              gameRef.reset();
                            },
                            child: const Icon(
                              Icons.exit_to_app_rounded,
                              size: 70,
                              color: Colors.white,
                            )),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
