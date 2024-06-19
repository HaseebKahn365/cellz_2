import 'dart:developer' as dev;
import 'dart:math';

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

  Dot(
    this.myPoint,
  ) {
    dynamicRadius = radius * 1.5;
    anchor = Anchor.center;

    size = Vector2(0, 0) + Vector2.all(radius * 2);
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

  bool isAIActive = false;

  @override
  void onDragUpdate(DragUpdateEvent event) {
    isDragging = true;
    dragEnd = event.localStartPosition.toOffset();

    //check if the distance between the dragStart and dragEnd is greater than the threshold then draw a line
    if ((dragEnd! - dragStart!).distance > globalThreshold * 1.5) {
      LineDirection direction = getDirection(dragStart!, dragEnd!);

      dev.log('Direction of line is : $direction');

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
            dev.log('Up line created');
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

              if (squares.length > 0) {
                squares.forEach((key, value) {
                  print('Square formed: $value');
                  final guiSquare = GuiSquare(isMine: GameState.myTurn, myXcord: value.xCord, myYcord: value.yCord);
                  gameRef.world.add(guiSquare);
                });
              }
            }

            dev.log('Down line created');
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

              if (squares.isNotEmpty) {
                squares.forEach((key, value) {
                  print('Square formed: $value');
                  final guiSquare = GuiSquare(isMine: GameState.myTurn, myXcord: value.xCord, myYcord: value.yCord);
                  gameRef.world.add(guiSquare);
                });
              }
            }

            dev.log('Left line created');
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

              if (squares.isNotEmpty) {
                squares.forEach((key, value) {
                  print('Square formed: $value');
                  final guiSquare = GuiSquare(isMine: GameState.myTurn, myXcord: value.xCord, myYcord: value.yCord);
                  gameRef.world.add(guiSquare);
                });
              }

              dev.log('Right line created');
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
    dev.log('Finger has been lifted');

    // Here we check if its ai's turn. If yes then call the ai function's buildReadyMoves method
    if (GameState.myTurn == false && isAIActive == false) {
      Future.delayed(Duration(milliseconds: aiDelay()), () {
        aiTurnFunction();
      });
    }
    isDragging = false;

    dragEnd = null;

    super.onDragEnd(event);
  }

  int aiDelay() {
    return 200 + Random().nextInt(600);
  }

  Future<void> aiTurnFunction() async {
    isAIActive = true;
    List<Line> readyMoves = aiFunction.buildReadyMoves();
    print('AI is active now with ready moves: ${readyMoves.length}');

    //for every move we will wait randomly between 400 and 1200ms
    //for every move we will create a GuiLine from the element of the list
    //we will add the guiLine to the world using gameRef but also add the lines to the linesDrawn map of the game state.

    /*
    Here is the process of properly constructing a GuiLine and adding it to the world
    we go through every line in the readyMoves and for each line we:
    find the first point and the second point of the line
    then we find the direction of the line with repect to the first point.
    then we find the center using the following formula:

    position = Vector2(myPoint.xCord.toDouble() * 100 + 60, myPoint.yCord.toDouble() * 100 + 60);
    size = Vector2(0, 0) + Vector2.all(radius * 2); 
    center = size / 2;

    after finding the center, we use the constructor of the GuiLine to create proper gui line
            final upLine = GuiLine(center.toOffset(), center.toOffset() - Offset(0, globalThreshold));

    looking at the above procedure of the line creation we need to first find the center of the first point
    then identify the direction of the line and then create the line using the center and the direction of the line
    after properly finding the direction for the line, we will add the line to the world using gameRef.world.add(upLine);
    we will also add this line to the game state's linesDrawn map.
     */

    for (Line line in readyMoves) {
      Point firstPoint = line.firstPoint;
      Point secondPoint = line.secondPoint;

      LineDirection direction = getDirection(Offset(firstPoint.xCord.toDouble() * 100 + 60, firstPoint.yCord.toDouble() * 100 + 60), Offset(secondPoint.xCord.toDouble() * 100 + 60, secondPoint.yCord.toDouble() * 100 + 60));

      dev.log('Direction of line is : $direction');

      Map<String, Square> squares = {};
      switch (direction) {
        case LineDirection.up:
          final upLine = GuiLine(center.toOffset(), center.toOffset() - Offset(0, globalThreshold));

          add(upLine);
          print('p2 from the gui_dot: $secondPoint');
          Line verticleLine = Line(firstPoint: firstPoint, secondPoint: secondPoint);
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
          dev.log('Up line created');

          break;
        case LineDirection.down:
          final downLine = GuiLine(center.toOffset(), center.toOffset() + Offset(0, globalThreshold));

          add(downLine);
          print('p2 from the gui_dot: $secondPoint');
          Line verticleLine = Line(firstPoint: firstPoint, secondPoint: secondPoint);
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
          dev.log('Down line created');

          break;
        case LineDirection.left:
          final leftLine = GuiLine(center.toOffset(), center.toOffset() - Offset(globalThreshold, 0));

          add(leftLine);
          print('p2 from the gui_dot: $secondPoint');
          Line horizontalLine = Line(firstPoint: firstPoint, secondPoint: secondPoint);
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
          dev.log('Left line created');

          break;
        case LineDirection.right:
          final rightLine = GuiLine(center.toOffset(), center.toOffset() + Offset(globalThreshold, 0));

          add(rightLine);
          print('p2 from the gui_dot: $secondPoint');
          Line horizontalLine = Line(firstPoint: firstPoint, secondPoint: secondPoint);
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
          dev.log('Right line created');

          break;

        default:
          dev.log('This is wierd');
          break;
      }
      print('after dragging Lines by the ai in the squares list are: ${squares.length}');

      await Future.delayed(Duration(milliseconds: aiDelay()));
    }

    isAIActive = false;
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
