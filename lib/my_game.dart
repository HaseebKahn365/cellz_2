import 'dart:async';
import 'package:cellz/business_logic/game_state.dart';
import 'package:cellz/game_components/gui_dot.dart';
import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';

class MyGame extends FlameGame {
  final int xP, yP;
  Vector2 appropriateOffset = Vector2(0, 0);
  late final TextComponent textComponent;

  MyGame({required this.xP, required this.yP, required this.appropriateOffset})
      : super(
          camera: CameraComponent.withFixedResolution(width: 700, height: 1000),
        ) {
    debugMode = false;
    GameState.initGameCanvas(xPoints: xP, yPoints: yP);
  }

  @override
  Color backgroundColor() => Colors.black;

  @override
  FutureOr<void> onLoad() async {
    camera.viewfinder.anchor = Anchor.topLeft;

    textComponent = TextComponent(
      text: GameState.myTurn ? 'Your Turn' : 'AI Turn',
      anchor: Anchor.topCenter,
      position: Vector2(350, 10), // Centered horizontally
    );
    world.add(textComponent);

    for (var entry in GameState.allPoints.entries) {
      world.add(Dot(entry.value));
    }
  }

  @override
  void update(double dt) {
    textComponent.text = GameState.myTurn ? 'My Turn' : 'Ai Turn';
    super.update(dt);
  }

  // Smooth zoom implementation

  void zoomIn() {
    camera.viewfinder.zoom = (camera.viewfinder.zoom * 1.01).clamp(1.0, 3.0);
  }

  void zoomOut() {
    camera.viewfinder.zoom = (camera.viewfinder.zoom / 1.01).clamp(1.0, 3.0);
  }

  // Camera movement methods
  void moveUp() {
    camera.viewfinder.transform.position.add(Vector2(0, -30));
  }

  void moveDown() {
    camera.viewfinder.transform.position.add(Vector2(0, 30));
  }

  void moveLeft() {
    camera.viewfinder.transform.position.add(Vector2(-30, 0));
  }

  void moveRight() {
    camera.viewfinder.transform.position.add(Vector2(30, 0));
  }
}
