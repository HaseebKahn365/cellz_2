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

  double dynamicRadius = 0;

  //in constructor make the player position centered
  Player() {
    dynamicRadius = radius * 1.5;
    anchor = Anchor.center;

    size = Vector2(0, 0) + Vector2.all(radius * 2); // Set the size of the player
  }

  @override
  Future<void> onLoad() async {
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
    dragEnd = event.localStartPosition.toOffset();
    radius = 30;
    super.onDragUpdate(event);
  }

  @override
  void onDragEnd(DragEndEvent event) {
    //temporarily creating a new line
    final line = Line(dragStart!, dragEnd!);
    add(line);

    dragEnd = null;

    super.onDragEnd(event);
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);

    // Draw the player as a circle
    canvas.drawCircle(const Offset(0, 0) + (size / 2).toOffset(), radius, Paint()..color = const Color.fromARGB(255, 193, 201, 236));

    // Draw the line if dragStart and dragEnd are set
    if (dragStart != null && dragEnd != null) {
      final start = Offset.zero;
      final end = dragEnd! - dragStart!;
      canvas.drawLine(
          start + (size / 2).toOffset(),
          end + (size / 2).toOffset(),
          Paint()
            ..color = Colors.red
            ..strokeWidth = 2.0);
    }
  }

  @override
  bool containsLocalPoint(Vector2 point) {
    // Increase the touch detection radius to 20
    return (point - (size / 2)).length < radius;
  }
}

//now we are gonna implement line as a component

class Line extends PositionComponent {
  final Offset start;
  final Offset end;

  Line(this.start, this.end) {
    size = Vector2(end.dx - start.dx, end.dy - start.dy);
    anchor = Anchor.topLeft;
  }

  //animate the line to become bold

  @override
  void update(double dt) {
    size = Vector2(end.dx - start.dx, end.dy - start.dy);
    super.update(dt);
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);

    canvas.drawLine(start, end, Paint()..color = Colors.red);
  }
}
