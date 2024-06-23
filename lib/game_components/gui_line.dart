import 'package:flame/components.dart';
import 'package:flutter/material.dart';

class GuiLine extends PositionComponent {
  final Offset start;
  final Offset end;
  double glowDoubleValue = 0;
  bool increasingGlow = true;
  double lineWidth = 2.0;

  GuiLine(this.start, this.end) {
    priority = 1;
    size = Vector2((end.dx - start.dx).abs(), (end.dy - start.dy).abs());
    anchor = Anchor.topLeft;
  }

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
    ..maskFilter = MaskFilter.blur(BlurStyle.normal, 2);

  var animateLimit = 2;
  double animationProgress = 0.5;

  @override
  void update(double dt) {
    super.update(dt);
    if (line.strokeWidth < 10) {
      line.strokeWidth = (line.strokeWidth + (10 * dt)).clamp(2.0, 10.0);
    }
    // Animate the line and draw it in the proper direction slowly
    if (animationProgress < 1.0) {
      animationProgress += dt * 2.7; // Adjust this value to control animation speed
      animationProgress = animationProgress.clamp(0.0, 1.0);
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

        increasingGlow = (animateLimit > 0 ? true : false);
      }
    }
    glowShadowLine.maskFilter = MaskFilter.blur(BlurStyle.normal, glowDoubleValue);
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);
    Offset currentEnd = Offset.lerp(start, end, animationProgress)!;

    // Draw the line and the glow effect
    // Draw the glow effect
    canvas.drawLine(start, currentEnd, glowShadowLine);

    // Draw the line
    canvas.drawLine(start, currentEnd, line);
  }
}
