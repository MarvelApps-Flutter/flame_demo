import 'dart:ui';

import 'package:flutter/material.dart';

import '../game/jungle_run.dart';
import 'head_up_display.dart';

class MainMenu extends StatelessWidget {
  static const id = 'MainMenu';

  final JungleRun gameRef;

  const MainMenu(this.gameRef, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
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
                  const Text(
                    'Jungle Run',
                    style: TextStyle(
                      fontSize: 50,
                      color: Colors.white,
                    ),
                  ),
                  GestureDetector(
                      onTap: () {
                        gameRef.startGamePlay();
                        gameRef.overlays.remove(MainMenu.id);
                        gameRef.overlays.add(HeadUpDisplay.id);
                      },
                      child: const Icon(
                        Icons.play_circle_outlined,
                        size: 70,
                        color: Colors.white,
                      )),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
