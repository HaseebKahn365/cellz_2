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
    canvas.drawLine(start, end, glowShadowLine);
    canvas.drawLine(start, end, line);
  }
}
