import 'package:cellz/my_game.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';

class Level1 extends StatelessWidget {
  const Level1({super.key});

  @override
  Widget build(BuildContext context) {
    final game = MyGame(
      xP: 6,
      yP: 6,
      appropriateOffset: Vector2(200, 200),
    );

    return Scaffold(
      body: Stack(
        children: [
          GameWidget(game: game),
          Positioned(
            bottom: 50,
            right: 10,
            child: Column(
              children: [
                FloatingActionButton(
                  onPressed: game.zoomIn,
                  child: Icon(Icons.zoom_in),
                ),
                SizedBox(height: 10),
                FloatingActionButton(
                  onPressed: game.zoomOut,
                  child: Icon(Icons.zoom_out),
                ),
              ],
            ),
          ),
          Positioned(
              bottom: 50,
              left: 10,
              child: Row(
                children: [
                  FloatingActionButton(
                    onPressed: game.moveLeft,
                    child: Icon(Icons.arrow_back),
                  ),
                  SizedBox(width: 10),
                  Column(
                    children: [
                      FloatingActionButton(
                        onPressed: game.moveUp,
                        child: Icon(Icons.arrow_upward),
                      ),
                      SizedBox(height: 10),
                      FloatingActionButton(
                        onPressed: game.moveDown,
                        child: Icon(Icons.arrow_downward),
                      ),
                    ],
                  ),
                  SizedBox(width: 10),
                  FloatingActionButton(
                    onPressed: game.moveRight,
                    child: Icon(Icons.arrow_forward),
                  ),
                ],
              )),
        ],
      ),
    );
  }
}
