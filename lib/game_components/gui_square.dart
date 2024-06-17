import 'package:flame/components.dart';
import 'package:flutter/material.dart';

class GuiSquare extends PositionComponent {
  final bool isMine;
  final Offset offsetFromTopLeftCorner;
  final double animationDuration = 0.5;
  final double animationEndSize = 50.0;
  final double animationStartSize = 12.0;
  double currentSize = 0.0;
  double velocity = 12.0;
  IconData aiIcon = Icons.ac_unit;
  Color color = Colors.red;
  IconData humanIcon = Icons.accessibility_new;
  Color humanColor = Colors.green;
  double iconScale = 0.0;

  GuiSquare({
    required this.isMine,
    this.offsetFromTopLeftCorner = const Offset(0, 0),
    debugMode = true,
  }) : super(anchor: Anchor.center) {
    currentSize = animationStartSize;
    size = Vector2(animationEndSize, animationEndSize);
  }

  @override
  void update(double dt) {
    super.update(dt);

    // Apply a spring-like force to create a bounce effect
    final acceleration = (animationEndSize - currentSize) * 10.0;
    velocity += acceleration * dt;
    currentSize += velocity * dt;

    // Dampen the velocity to simulate friction
    velocity *= 0.9;

    // Clamp the size to prevent overshooting
    currentSize = currentSize.clamp(animationStartSize, animationEndSize);

    // Update the icon scale
    iconScale = (currentSize - animationStartSize) / (animationEndSize - animationStartSize);
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);

    // Draw the square
    final squarePaint = Paint()
      ..color = const Color(0xFFF0F0F0)
      ..style = PaintingStyle.fill;

    final squareWithBorder = Path()
      ..addRRect(
        RRect.fromRectAndRadius(
          Rect.fromCenter(center: Offset.zero, width: currentSize, height: currentSize),
          const Radius.circular(10.0),
        ),
      );

    canvas.drawPath(squareWithBorder, squarePaint);

    // Render the icon
    final textSpan = TextSpan(
      text: String.fromCharCode(
        isMine ? aiIcon.codePoint : humanIcon.codePoint,
      ),
      style: TextStyle(
        fontSize: 30.0 * iconScale, // Scale the font size based on the icon scale
        fontFamily: (isMine ? aiIcon.fontFamily : humanIcon.fontFamily),
        package: isMine ? aiIcon.fontPackage : humanIcon.fontPackage,
        color: isMine ? color : humanColor,
      ),
    );
    final textPainter = TextPainter(
      text: textSpan,
      textDirection: TextDirection.rtl,
    );
    textPainter.layout();
    final relativePosition = Vector2(-textPainter.width / 2, -textPainter.height / 2); // Center the icon

    textPainter.paint(canvas, relativePosition.toOffset());
  }
}
