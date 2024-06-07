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
    world.add(Player());
  }
}

class Player extends PositionComponent with DragCallbacks {
  Offset? dragStart;
  Offset? dragEnd;

  double radius = 30;

  //in constructor make the player position centered
  Player() {
    anchor = Anchor.center;
  }

  @override
  Future<void> onLoad() async {
    size = Vector2(40, 40); // Set the size of the player
    anchor = Anchor.center; // Center the anchor for proper positioning
    return super.onLoad();
  }

  @override
  void onDragStart(DragStartEvent event) {
    dragStart = event.localPosition.toOffset();
    dragEnd = event.localPosition.toOffset();

    super.onDragStart(event);
  }

  @override
  void onDragUpdate(DragUpdateEvent event) {
    dragEnd = event.localPosition.toOffset();
    radius = 30;
    super.onDragUpdate(event);
  }

  @override
  void onDragEnd(DragEndEvent event) {
    dragEnd = null;

    super.onDragEnd(event);
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);
    final rect = Rect.fromCenter(center: Offset.zero, width: radius * 2.5, height: radius * 2.5);
    canvas.drawRect(rect, Paint()..color = Colors.green);

    // Draw the player as a circle
    canvas.drawCircle(position.toOffset(), radius, Paint()..color = const Color.fromARGB(255, 193, 201, 236));

    // Draw the line if dragStart and dragEnd are set
    if (dragStart != null && dragEnd != null) {
      final start = Offset.zero;
      final end = dragEnd! - dragStart!;
      canvas.drawLine(
          start,
          end,
          Paint()
            ..color = Colors.red
            ..strokeWidth = 2.0);
    }
  }

  @override
  bool containsLocalPoint(Vector2 point) {
    // Increase the touch detection radius to 20
    return (point - (size / 2)).length < radius * 2.5;
  }
}
