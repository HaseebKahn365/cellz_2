import 'package:cellz/business_logic/point.dart';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';

class GuiLineForAi extends PositionComponent {
  final Point firstPoint;
  final Point secondPoint;
  double glowDoubleValue = 0;
  bool increasingGlow = true;
  double lineWidth = 2.0;

  GuiLineForAi({required this.firstPoint, required this.secondPoint}) {
    priority = 0;
    debugMode = true;
    print('Recieved points: ${firstPoint.location} and ${secondPoint.location}');
    // _calculateLinePositionAndSize();
    // _start = Offset(60, 60); //60 is the appropriate offset
    // _end = Offset(160, 60); //+100 for global threshold.
    //i am trying to draw line from point 1 with x=0, y= to
    //point 2 with x=1, y=0
    //wow it worked! now lets move this logic to the _calculateLinePositionAndSize

    _calculateLinePositionAndSize();
    anchor = Anchor.topLeft;
  }

  void _calculateLinePositionAndSize() {
    // Calculate the start and end positions of the line
    _start = Offset(firstPoint.xCord * 100 + 60, firstPoint.yCord * 100 + 60);
    _end = Offset(secondPoint.xCord * 100 + 60, secondPoint.yCord * 100 + 60);
  }

  Offset _start = Offset.zero;
  Offset _end = Offset.zero;

  // Make the line's cap rounded and animate the line width
  final line = Paint()
    ..color = Colors.white
    ..strokeWidth = 2
    ..strokeCap = StrokeCap.round;

  // Add a flashing glow effect
  final glowShadowLine = Paint()
    ..color = Colors.white.withOpacity(0.8)
    ..strokeWidth = 10
    ..strokeCap = StrokeCap.round
    ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 2);

  var animateLimit = 2;

  @override
  void update(double dt) {
    super.update(dt);
    if (line.strokeWidth < 10) {
      line.strokeWidth = (line.strokeWidth + (10 * dt)).clamp(2.0, 10.0);
    }
    // Animate the line width to become bold

    // Animate the glow effect
    if (increasingGlow) {
      glowDoubleValue += 20 * dt;
      if (glowDoubleValue >= 20) {
        glowDoubleValue = 20;
        increasingGlow = false;
      }
    } else {
      glowDoubleValue -= 20 * dt;
      if (glowDoubleValue <= 0) {
        glowDoubleValue = 0;
        animateLimit--;

        increasingGlow = (animateLimit > 0 ? true : false);
      }
    }
    glowShadowLine.maskFilter = MaskFilter.blur(BlurStyle.normal, glowDoubleValue);
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);

    // Draw the line and the glow effect
    canvas.drawLine(_start, _end, glowShadowLine);
    canvas.drawLine(_start, _end, line);
  }
}
