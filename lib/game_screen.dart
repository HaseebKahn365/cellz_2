import 'package:flame/game.dart';
import 'package:flutter/material.dart';

class GameScreen extends StatelessWidget {
  const GameScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GameWidget(
      game: MyGame(),
    );
  }
}

class MyGame extends FlameGame {
  @override
  Color backgroundColor() {
    return Colors.white30;
  }

  @override
  Future<void> onLoad() async {
    // Load your game assets here
  }

  @override
  void update(double dt) {
    // Update your game state here
  }

  @override
  void render(Canvas canvas) {
    // Render your game here
  }
}
