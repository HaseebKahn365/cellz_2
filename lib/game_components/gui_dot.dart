import 'dart:async';
import 'dart:developer';

import 'package:cellz/business_logic/aiFunction.dart';
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

enum LineDirection {
  up,
  down,
  left,
  right,
}

class Dot extends PositionComponent with DragCallbacks, CollisionCallbacks, HasGameRef {
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

  //!static aIFunction instance
  static AIFunction aiFunction = AIFunction();

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

  //boolean controller to make sure that the logic inside the onDragUpdate is executed once.
  //when the finger is lifted we reset the controller.
  //we need to make it static so that it is shared among all the instances of the class

  static bool dragIsAllowed = true;

  @override
  void onDragUpdate(DragUpdateEvent event) {
    if (GameState.myTurn && dragIsAllowed) {
      isDragging = true;
      dragEnd = event.localStartPosition.toOffset();

      //check if the distance between the dragStart and dragEnd is greater than the threshold then draw a line
      if ((dragEnd! - dragStart!).distance > globalThreshold * 1.5) {
        LineDirection direction = getDirection(dragStart!, dragEnd!);

        log('Direction of line is : $direction');

        Map<String, Square> squares = {};
        switch (direction) {
          case LineDirection.up:
            if (lineApprover(direction)) {
              final upLine = GuiLine(center.toOffset(), center.toOffset() - Offset(0, globalThreshold));

              Point? p2 = GameState.allPoints[myPoint.location - (GameState.gameCanvas.xPoints)];
              if (p2 != null) {
                bool invalid = !GameState.validLines.containsKey(Line(firstPoint: myPoint, secondPoint: p2).toString()) || (GameState.linesDrawn.containsKey(Line(firstPoint: myPoint, secondPoint: p2).toString()));
                if (invalid) {
                  print('Up Line is not valid because it either already exists or is not in the valid lines');
                  return;
                }

                dragIsAllowed = false;

                add(upLine);
                print('p2 from the gui_dot: $p2');
                Line verticleLine = Line(firstPoint: myPoint, secondPoint: p2);
                verticleLine.addLineToMap();
                print('Line added to the map: $verticleLine');
                squares = verticleLine.checkSquare();
                print('Total sqaures in the game are now : ${GameState.allSquares.length}');

                if (squares.length > 0) {
                  squares.forEach((key, value) {
                    print('Square formed: $value');
                    final guiSquare = GuiSquare(isMine: GameState.myTurn, myXcord: value.xCord, myYcord: value.yCord);
                    gameRef.world.add(guiSquare);
                  });
                }
              }
              log('Up line created');
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

                dragIsAllowed = false;

                add(downLine);
                print('p2 from the gui_dot: $p2');
                Line verticleLine = Line(firstPoint: myPoint, secondPoint: p2);
                verticleLine.addLineToMap();
                print('Line added to the map: $verticleLine');
                squares = verticleLine.checkSquare();

                if (squares.length > 0) {
                  squares.forEach((key, value) {
                    print('Square formed: $value');
                    final guiSquare = GuiSquare(isMine: GameState.myTurn, myXcord: value.xCord, myYcord: value.yCord);
                    gameRef.world.add(guiSquare);
                  });
                }
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

                dragIsAllowed = false;

                add(leftLine);
                print('p2 from the gui_dot: $p2');
                Line horizontalLine = Line(firstPoint: myPoint, secondPoint: p2);
                horizontalLine.addLineToMap();
                print('Line added to the map: $horizontalLine');
                squares = horizontalLine.checkSquare();

                if (squares.isNotEmpty) {
                  squares.forEach((key, value) {
                    print('Square formed: $value');
                    final guiSquare = GuiSquare(isMine: GameState.myTurn, myXcord: value.xCord, myYcord: value.yCord);
                    gameRef.world.add(guiSquare);
                  });
                }
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

                dragIsAllowed = false;

                add(rightLine);
                print('p2 from the gui_dot: $p2');
                Line horizontalLine = Line(firstPoint: myPoint, secondPoint: p2);
                horizontalLine.addLineToMap();
                print('Line added to the map: $horizontalLine');
                squares = horizontalLine.checkSquare();

                if (squares.isNotEmpty) {
                  squares.forEach((key, value) {
                    print('Square formed: $value');
                    final guiSquare = GuiSquare(isMine: GameState.myTurn, myXcord: value.xCord, myYcord: value.yCord);
                    gameRef.world.add(guiSquare);
                  });
                }

                log('Right line created');
              }
            }

            break;
        }
        if (squares.isNotEmpty) {
          dragIsAllowed = true;
        }

        dragEnd = null; //to make sure we don't visualize the drag line after the line is created
        isDragging = false;
      }

      super.onDragUpdate(event);
    }
  }

  static bool isAIResponseRunning = false; //! Static flag to track if the AI response is running

  @override
  void onDragEnd(DragEndEvent event) async {
    log('Finger has been lifted');
    // Here we check if it's AI's turn. If yes, then call the AI function.
    isDragging = false;
    dragEnd = null;

    // Check if the AI response is not already running
    if (!isAIResponseRunning) {
      isAIResponseRunning = true; // Set the flag to indicate that the AI response is running more than one dot should not run aiResponses.
      await aiResponse(); // Call the AI response function
      isAIResponseRunning = false; // Reset the flag after the AI response is completed
    }

    super.onDragEnd(event);
  }

  //!This is an AI Response function.

  //for now we are just gonna use the futures to demo the feature:

  Future<void> aiResponse() async {
    print('Ai Function is initiated');

    await Future.delayed(const Duration(milliseconds: 300)).then((value) async {
      // aiFunction.testComponentCreation(gameRef);
      if (!GameState.myTurn) {
        try {
          await aiFunction.buildReadyLines(gameRef);
          dragIsAllowed = true;
        } catch (e) {
          log('Error in the AI function: $e');
        }
      }
      print('Ai function is done');
      //resetting the controller for the drag event
    });
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
