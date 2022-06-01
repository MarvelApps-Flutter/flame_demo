import 'package:flame_module/model/player_data.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../game/jungle_run.dart';
import 'pause_menu.dart';

class HeadUpDisplay extends StatelessWidget {
  static const id = 'HeadUpDisplay';

  // Reference to parent game.
  final JungleRun gameRef;

  const HeadUpDisplay(this.gameRef, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: gameRef.playerData,
      child: Padding(
        padding: EdgeInsets.only(
            top: 10.0,
            left: MediaQuery.of(context).padding.top + kToolbarHeight,
            right: MediaQuery.of(context).padding.bottom + kToolbarHeight),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              children: [
                Selector<PlayerData, int>(
                  selector: (_, playerData) => playerData.currentScore,
                  builder: (_, score, __) {
                    return Text(
                      'Score: $score',
                      style: const TextStyle(fontSize: 20, color: Colors.white),
                    );
                  },
                ),
              ],
            ),
            TextButton(
              onPressed: () {
                gameRef.overlays.remove(HeadUpDisplay.id);
                gameRef.overlays.add(PauseMenu.id);
                gameRef.pauseEngine();
              },
              child: const Icon(Icons.pause, color: Colors.white),
            ),
            Selector<PlayerData, int>(
              selector: (_, playerData) => playerData.lives,
              builder: (_, lives, __) {
                return Row(
                  children: List.generate(3, (index) {
                    if (index < lives) {
                      return const Icon(
                        Icons.favorite,
                        color: Colors.red,
                      );
                    } else {
                      return const Icon(
                        Icons.favorite_border,
                        color: Colors.red,
                      );
                    }
                  }),
                );
              },
            )
          ],
        ),
      ),
    );
  }
}
