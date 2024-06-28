import 'package:cellz/business_logic/game_state.dart';
import 'package:cellz/business_logic/point.dart';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';

class GuiLine extends PositionComponent {
  final Point firstPoint;
  final Point secondPoint;
  double glowDoubleValue = 0;
  bool increasingGlow = true;
  double lineWidth = 2.0;
  double animationProgress = GameState.myTurn ? 0.4 : 0;

  static bool controlBool = false;

  //we are gonna add a different color to the most recently drawn line
  /*
  Here is how we are gonna do this:
  we have a two local booleans and a static bool for the line class

  the two local bools are:
  imNew and expired

  here is the logic:
  in the constructor we set the static controlBool to the myTurn in the game state and assign control bool to imNew
  bool expired = false;
  then we check if (controlBool && imNew) or (!controlBool && !imNew) then draw new color
  else draw the old color and set expired to true and draw the old color
   */

  late bool imNew;
  bool expired = false;

  GuiLine({required this.firstPoint, required this.secondPoint}) {
    priority = 0;
    debugMode = true;
    print('Received points: ${firstPoint.location} and ${secondPoint.location}');
    _calculateLinePositionAndSize();
    controlBool = GameState.myTurn;
    imNew = controlBool;
    anchor = Anchor.topLeft;
  }

  final Color newColor = GameState.colorSet[6];
  final Color oldColor = GameState.colorSet[7];

  void _calculateLinePositionAndSize() {
    _start = Offset(firstPoint.xCord * GameState.globalOffset + 60, firstPoint.yCord * GameState.globalOffset + 60);
    _end = Offset(secondPoint.xCord * GameState.globalOffset + 60, secondPoint.yCord * GameState.globalOffset + 60);
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

    //change the color of line
    if (!expired) {
      if ((controlBool && imNew) || (!controlBool && !imNew)) {
        line.color = newColor;
      } else {
        line.color = oldColor;
        expired = true;
      }
    }

    // Animate the line drawing
    if (animationProgress < 1.0) {
      animationProgress += dt * 2.7; // Adjust this value to control animation speed
      animationProgress = animationProgress.clamp(0.0, 1.0);
    }

    // Animate the line width
    if (line.strokeWidth < 10) {
      line.strokeWidth = (line.strokeWidth + (10 * dt)).clamp(2.0, 10.0);
    }

    // Animate the glow effect
    if (increasingGlow) {
      glowDoubleValue += 60 * dt; //the glow speed is adjusted here
      if (glowDoubleValue >= 20) {
        glowDoubleValue = 20;
        increasingGlow = false;
      }
    } else {
      glowDoubleValue -= 60 * dt;
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
