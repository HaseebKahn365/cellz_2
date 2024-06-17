import 'package:cellz/my_game.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';

class Level1 extends StatelessWidget {
  const Level1({super.key});

  @override
  Widget build(BuildContext context) {
    return GameWidget(
        game: MyGame(
      appropriateOffset: Vector2(200, 200),
      xP: 5,
      yP: 5,
    ));
  }
}
