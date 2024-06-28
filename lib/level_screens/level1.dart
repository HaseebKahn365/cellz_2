import 'package:cellz/my_game.dart';
import 'package:cellz/screens.dart/game_play_overlay.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';

class Level1 extends StatelessWidget {
  Level1({super.key});

  @override
  Widget build(BuildContext context) {
    final game = MyGame(
      xP: 5,
      yP: 10,
    );

    return Scaffold(
      body: Stack(
        children: [
          //Here should be the overlay for game showing the players and the ui
          GamePlayScreen(), //this is just the overlay

          Container(padding: const EdgeInsets.only(top: 200), child: GameWidget(game: game)),
          Positioned(
            bottom: 40,
            right: 10,
            child: Column(
              children: [
                FloatingActionButton(
                  heroTag: null,
                  onPressed: () async {
                    await game.zoomIn();
                  },
                  child: Icon(Icons.zoom_in),
                ),
                const SizedBox(height: 10),
                GestureDetector(
                  onLongPress: () async {
                    print("Long press detected");
                    await game.resetZoom();
                  },
                  child: FloatingActionButton(
                    heroTag: null,
                    onPressed: game.zoomOut,
                    child: Icon(Icons.zoom_out),
                  ),
                ),
              ],
            ),
          ),
          Positioned(
              bottom: 40,
              left: 10,
              child: Row(
                children: [
                  FloatingActionButton(
                    heroTag: null,
                    onPressed: () async {
                      await game.moveRight();
                    },
                    child: Icon(Icons.arrow_back),
                  ),
                  const SizedBox(width: 10),
                  Column(
                    children: [
                      FloatingActionButton(
                        heroTag: null,
                        onPressed: () async {
                          await game.moveDown();
                        }, // Keep this to avoid errors, but the action is handled by long press
                        child: Icon(Icons.arrow_upward),
                      ),
                      const SizedBox(height: 20),
                      FloatingActionButton(
                        heroTag: null,
                        onPressed: () async {
                          await game.moveUp();
                        },
                        child: Icon(Icons.arrow_downward),
                      ),
                    ],
                  ),
                  const SizedBox(width: 10),
                  FloatingActionButton(
                    heroTag: null,
                    onPressed: () async {
                      await game.moveLeft();
                    },
                    child: Icon(Icons.arrow_forward),
                  ),
                ],
              )),
        ],
      ),
    );
  }
}
