import 'dart:developer';

import 'package:cellz/Components/line.dart';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flutter/material.dart';

//the dot is able to have collision detection with another dot and create lines

class Player extends PositionComponent with DragCallbacks, CollisionCallbacks {
  final Vector2 fixedPosition;
  Offset? dragStart;
  Offset? dragEnd;

  double radius = 30;

  double dynamicRadius = 0;

  Vector2 center = Vector2(0, 0);

  //in constructor make the player position centered
  Player(
    this.fixedPosition,
  ) {
    dynamicRadius = radius * 1.5;
    anchor = Anchor.center;

    size = Vector2(0, 0) + Vector2.all(radius * 2); // Set the size of the player
    center = size / 2;

    position = fixedPosition;
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
    final line = Line(center.toOffset(), dragEnd!);
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

  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    log('Collision detected! with $other');
    super.onCollision(intersectionPoints, other);
  }
}
