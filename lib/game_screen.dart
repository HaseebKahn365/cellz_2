import 'package:cellz/Components/dot.dart';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class GameScreen extends StatelessWidget {
  const GameScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GameWidget(
      game: MyGame(),
    );
  }
}

class MyGame extends FlameGame with DragCallbacks {
  @override
  Color backgroundColor() {
    return Colors.blueAccent.withOpacity(0.3);
  }

  MyGame() : super() {
    debugMode = true; // Turn on debug mode for drawing bounding boxes
    camera = CameraComponent.withFixedResolution(
      width: 600,
      height: 1000,
    );
  }

  @override
  Future<void> onLoad() async {
    super.onLoad();
    world.add(Player(
      Vector2(0, 0),
    ));
    world.add(Player(
      Vector2(200, 0),
    ));
  }
}
