import 'dart:developer';

import 'package:cellz/business_logic/game_canvas.dart';
import 'package:cellz/business_logic/game_state.dart';
import 'package:cellz/business_logic/lines.dart';
import 'package:cellz/business_logic/point.dart';
import 'package:cellz/business_logic/square.dart';
import 'package:cellz/game_components/gui_line.dart';
import 'package:cellz/game_components/gui_square.dart';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flutter/material.dart';

//the dot is able to have collision detection with another dot and create lines

enum LineDirection {
  up,
  down,
  left,
  right,
}

class Dot extends PositionComponent with DragCallbacks, CollisionCallbacks {
  Point myPoint; //using the concept of composition for the fixed position of the dot
  Offset? dragStart;
  Offset? dragEnd;

  final globalThreshold = GameCanvas.globalThreshold;

  double radius = 15;

  double dynamicRadius = 0;

  @override
  Vector2 center = Vector2(0, 0);

  //in constructor make the player position centered
  Dot(
    this.myPoint,
  ) {
    dynamicRadius = radius * 1.5;
    anchor = Anchor.center;

    size = Vector2(0, 0) + Vector2.all(radius * 2); // Set the size of the player
    center = size / 2;

    position = Vector2(myPoint.xCord.toDouble() * 100 + 60, myPoint.yCord.toDouble() * 100 + 60);
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

  //one dot can only have 4 lines originating from it also same direction lines are not allowed
  int linesLimit = 4;
  //Array of used LineDirections
  List<LineDirection> usedDirections = [];

  @override
  void onDragUpdate(DragUpdateEvent event) {
    isDragging = true;
    dragEnd = event.localStartPosition.toOffset();

    //check if the distance between the dragStart and dragEnd is greater than the threshold then draw a line
    if ((dragEnd! - dragStart!).distance > globalThreshold * 1.5) {
      LineDirection direction = getDirection(dragStart!, dragEnd!);

      log('Direction of line is : $direction');

      List<Square> squares = [];
      switch (direction) {
        case LineDirection.up:
          if (lineApprover(
            direction,
          )) {
            final upLine = GuiLine(center.toOffset(), center.toOffset() - Offset(0, globalThreshold));

            //making sure that line is created and added to the GameState's map of lines
            Point? p2 = GameState.allPoints[myPoint.location - (GameState.gameCanvas.xPoints)];
            if (p2 != null) {
              bool invalid = !GameState.validLines.containsKey(Line(firstPoint: myPoint, secondPoint: p2).toString()) || (GameState.linesDrawn.containsKey(Line(firstPoint: myPoint, secondPoint: p2).toString()));
              if (invalid) {
                print('Up Line is not valid because it either already exists or is not in the valid lines');
                return;
              }

              add(upLine);
              print('p2 from the gui_dot: $p2');
              Line verticleLine = Line(firstPoint: myPoint, secondPoint: p2);
              verticleLine.addLineToMap();
              print('Line added to the map: $verticleLine');
              squares = verticleLine.checkSquare();

              if (squares.isNotEmpty) {
                squares.forEach((element) {
                  //we first check for the square and record its xCord and yCord.
                  //then to create the square object at the right place, we have to find the right offset for the square
                  //the offset is calculated by:  * 100 + 60

                  //we then create the square object and add it to the world

                  final guiSquare = GuiSquare(
                    isMine: false,
                    offsetFromTopLeftCorner: Offset(element.xCord.toDouble() * 100 + 60, element.yCord.toDouble() * 100 + 60),
                  );

                  add(guiSquare);
                });
              }
            }
            log('Up line created'); //great job!
          }

          break;
        case LineDirection.down:
          if (lineApprover(direction)) {
            final downLine = GuiLine(center.toOffset(), center.toOffset() + Offset(0, globalThreshold));

            //adding a vertical down line

            //creating second point
            Point? p2 = GameState.allPoints[myPoint.location + (GameState.gameCanvas.xPoints)];
            if (p2 != null) {
              bool invalid = !GameState.validLines.containsKey(Line(firstPoint: myPoint, secondPoint: p2).toString()) || (GameState.linesDrawn.containsKey(Line(firstPoint: myPoint, secondPoint: p2).toString()));
              if (invalid) {
                print('Down Line is not valid because it either already exists or is not in the valid lines');
                return;
              }

              add(downLine);
              print('p2 from the gui_dot: $p2');
              Line verticleLine = Line(firstPoint: myPoint, secondPoint: p2);
              verticleLine.addLineToMap();
              print('Line added to the map: $verticleLine');
              squares = verticleLine.checkSquare();

              print('Total Lines drawn: ${GameState.linesDrawn.length}');
            }

            log('Down line created');
          }

          break;
        case LineDirection.left:
          if (lineApprover(direction)) {
            final leftLine = GuiLine(center.toOffset(), center.toOffset() - Offset(globalThreshold, 0));

            //adding a horizontal left line

            //creating second point
            Point? p2 = GameState.allPoints[myPoint.location - 1];

            if (p2 != null) {
              bool invalid = !GameState.validLines.containsKey(Line(firstPoint: myPoint, secondPoint: p2).toString()) || (GameState.linesDrawn.containsKey(Line(firstPoint: myPoint, secondPoint: p2).toString()));
              if (invalid) {
                print('this left Line is not valid because it either already exists or is not in the valid lines');
                return;
              }

              add(leftLine);
              print('p2 from the gui_dot: $p2');
              Line horizontalLine = Line(firstPoint: myPoint, secondPoint: p2);
              horizontalLine.addLineToMap();
              print('Line added to the map: $horizontalLine');
              squares = horizontalLine.checkSquare();

              print('Total Lines drawn: ${GameState.linesDrawn.length}');
            }

            log('Left line created');
          }

          break;
        case LineDirection.right:
          if (lineApprover(direction)) {
            //adding a horizontal right line

            //creating second point
            Point? p2 = GameState.allPoints[myPoint.location + 1];
            final rightLine = GuiLine(center.toOffset(), center.toOffset() + Offset(globalThreshold, 0));
            if (p2 != null) {
              bool invalid = !GameState.validLines.containsKey(Line(firstPoint: myPoint, secondPoint: p2).toString()) || (GameState.linesDrawn.containsKey(Line(firstPoint: myPoint, secondPoint: p2).toString()));
              if (invalid) {
                print('this right Line is not valid because it either already exists or is not in the valid lines');
                return;
              }

              add(rightLine);
              print('p2 from the gui_dot: $p2');
              Line horizontalLine = Line(firstPoint: myPoint, secondPoint: p2);
              horizontalLine.addLineToMap();
              print('Line added to the map: $horizontalLine');
              squares = horizontalLine.checkSquare();

              print('Total Lines drawn: ${GameState.linesDrawn.length}');
              log('Right line created');
            }
          }

          break;
      }
      print('after dragging Lines in the squares list are: ${squares.length}');
      dragEnd = null; //to make sure we don't visualize the drag line after the line is created
      isDragging = false;
    }

    super.onDragUpdate(event);
  }

  @override
  void onDragEnd(DragEndEvent event) {
    //temporarily creating a new line
    isDragging = false;

    dragEnd = null;

    super.onDragEnd(event);
  }

  double maxRadius = 20.0; // Maximum dynamic radius
  double scaleSpeed = 40.0; // Speed of scaling
  bool isDragging = false; // Flag to track if the dot is being dragged

  void update(double dt) {
    if (isDragging) {
      // Scale up the radius until it reaches maxRadius
      radius += scaleSpeed * dt;
      if (radius > maxRadius) {
        radius = maxRadius;
      }
    } else {
      // Scale down the radius until it reaches the initial size
      if (radius > 10.0) {
        radius -= scaleSpeed * dt;
        if (radius < 10.0) {
          radius = 10.0;
        }
      }
    }
  }

  void startDragging() {
    isDragging = true;
  }

  void stopDragging() {
    isDragging = false;
  }

  final dragCoefficient = 0.4; //this is for adding a delay gap to the drag offset

  @override
  void render(Canvas canvas) {
    super.render(canvas);

    // Draw the player as a circle
    canvas.drawCircle(const Offset(0, 0) + (size / 2).toOffset(), radius, Paint()..color = const Color.fromARGB(255, 193, 201, 236));

    // Draw the line if dragStart and dragEnd are set
    if (dragStart != null && dragEnd != null) {
      const start = Offset.zero;
      final end = dragEnd! - dragStart!;
      canvas.drawLine(
          start + (size / 2).toOffset(),
          Offset(end.dx * dragCoefficient, end.dy * dragCoefficient) + (size / 2).toOffset(),
          Paint()
            ..color = Colors.white
            ..strokeWidth = 2.0);
    }
  }

  @override
  bool containsLocalPoint(Vector2 point) {
    // Increase the touch detection radius to 20
    return (point - (size / 2)).length < radius * 4;
  }

  //Line approver
  bool lineApprover(LineDirection direction) {
    linesLimit--;
    //check if the direction is already used
    if (usedDirections.contains(direction)) {
      // log('Direction already used');
      return false;
    }
    if (linesLimit == 0) {
      // log('Lines limit reached');
      return false;
    }
    usedDirections.add(direction);
    // log('Direction added to used directions $direction');
    return true;
  }
}

LineDirection getDirection(Offset start, Offset end) {
  final dx = end.dx - start.dx;
  final dy = end.dy - start.dy;

  if (dx.abs() > dy.abs()) {
    if (dx > 0) {
      return LineDirection.right;
    } else {
      return LineDirection.left;
    }
  } else {
    if (dy > 0) {
      return LineDirection.down;
    } else {
      return LineDirection.up;
    }
  }
}
