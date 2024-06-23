import 'dart:async';

import 'package:cellz/my_game.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';

class Level1 extends StatelessWidget {
  Level1({super.key});

  var _timer;

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
                  GestureDetector(
                    onLongPressStart: (details) {
                      _timer = Timer.periodic(const Duration(milliseconds: 70), (timer) {
                        game.moveLeft();
                      });
                    },
                    onLongPressEnd: (details) {
                      _timer?.cancel();
                    },
                    child: FloatingActionButton(
                      onPressed: () {},
                      child: Icon(Icons.arrow_back),
                    ),
                  ),
                  SizedBox(width: 10),
                  Column(
                    children: [
                      GestureDetector(
                        child: FloatingActionButton(
                          onPressed: () {}, // Keep this to avoid errors, but the action is handled by long press
                          child: Icon(Icons.arrow_upward),
                        ),
                        onLongPressStart: (details) {
                          _timer = Timer.periodic(const Duration(milliseconds: 70), (timer) {
                            game.moveUp();
                          });
                        },
                        onLongPressEnd: (details) {
                          _timer?.cancel();
                        },
                      ),
                      SizedBox(height: 20),
                      GestureDetector(
                        onLongPressStart: (details) {
                          _timer = Timer.periodic(const Duration(milliseconds: 70), (timer) {
                            game.moveDown();
                          });
                        },
                        onLongPressEnd: (details) {
                          _timer?.cancel();
                        },
                        child: FloatingActionButton(
                          onPressed: () {},
                          child: Icon(Icons.arrow_downward),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(width: 10),
                  GestureDetector(
                    onLongPressStart: (details) {
                      _timer = Timer.periodic(const Duration(milliseconds: 70), (timer) {
                        game.moveRight();
                      });
                    },
                    onLongPressEnd: (details) {
                      _timer?.cancel();
                    },
                    child: FloatingActionButton(
                      onPressed: () {},
                      child: Icon(Icons.arrow_forward),
                    ),
                  ),
                ],
              )),
        ],
      ),
    );
  }
}
