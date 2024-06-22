import 'package:cellz/business_logic/point.dart';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';

class GuiLineForAi extends PositionComponent {
  final Point firstPoint;
  final Point secondPoint;
  double glowDoubleValue = 0;
  bool increasingGlow = true;
  double lineWidth = 2.0;
  double animationProgress = 0.0;

  GuiLineForAi({required this.firstPoint, required this.secondPoint}) {
    priority = 0;
    debugMode = true;
    print('Received points: ${firstPoint.location} and ${secondPoint.location}');
    _calculateLinePositionAndSize();
    anchor = Anchor.topLeft;
  }

  void _calculateLinePositionAndSize() {
    _start = Offset(firstPoint.xCord * 100 + 60, firstPoint.yCord * 100 + 60);
    _end = Offset(secondPoint.xCord * 100 + 60, secondPoint.yCord * 100 + 60);
  }

  Offset _start = Offset.zero;
  Offset _end = Offset.zero;

  final line = Paint()
    ..color = Colors.white
    ..strokeWidth = 2
    ..strokeCap = StrokeCap.round;

  final glowShadowLine = Paint()
    ..color = Colors.white.withOpacity(0.8)
    ..strokeWidth = 10
    ..strokeCap = StrokeCap.round
    ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 2);

  var animateLimit = 2;

  @override
  void update(double dt) {
    super.update(dt);

    // Animate the line drawing
    if (animationProgress < 1.0) {
      animationProgress += dt * 50; // Adjust this value to control animation speed
      animationProgress = animationProgress.clamp(0.0, 1.0);
    }

    // Animate the line width
    if (line.strokeWidth < 10) {
      line.strokeWidth = (line.strokeWidth + (10 * dt)).clamp(2.0, 10.0);
    }

    // Animate the glow effect
    if (increasingGlow) {
      glowDoubleValue += 50 * dt;
      if (glowDoubleValue >= 20) {
        glowDoubleValue = 20;
        increasingGlow = false;
      }
    } else {
      glowDoubleValue -= 50 * dt;
      if (glowDoubleValue <= 0) {
        glowDoubleValue = 0;
        animateLimit--;
        increasingGlow = (animateLimit > 0);
      }
    }
    glowShadowLine.maskFilter = MaskFilter.blur(BlurStyle.normal, glowDoubleValue);
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);

    // Calculate the current end point of the animated line
    Offset currentEnd = Offset.lerp(_start, _end, animationProgress)!;

    // Draw the glow effect
    canvas.drawLine(_start, currentEnd, glowShadowLine);

    // Draw the line
    canvas.drawLine(_start, currentEnd, line);
  }
}
