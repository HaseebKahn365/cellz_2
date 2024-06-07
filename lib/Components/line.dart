//now we are gonna implement line as a component

import 'package:flame/components.dart';
import 'package:flutter/material.dart';

class Line extends PositionComponent {
  final Offset start;
  final Offset end;

  Line(this.start, this.end) {
    priority = 0;
    size = Vector2(end.dx - start.dx, end.dy - start.dy);
    anchor = Anchor.topLeft;
  }

  //animate the line to become bold

  //make its cap rounded
  final line = Paint()
    ..color = Colors.red
    ..strokeWidth = 1
    ..strokeCap = StrokeCap.round;

  @override
  void update(double dt) {
    while (line.strokeWidth < 10) {
      // Increase the line width to 10
      line.strokeWidth += 0.1;
      break;
    }
    super.update(dt);
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);

    canvas.drawLine(start, end, line);
  }
}
