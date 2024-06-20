import 'package:cellz/business_logic/game_state.dart';
import 'package:cellz/business_logic/lines.dart';
import 'package:flame/game.dart';
import 'point.dart';

class AIFunction {
  Set<Line> tempLinesDrawn = {};
  Set<Line> tempRemainingLines = {};
  Set<Line> firstMaxSquareChainLines = {};

  void buildReadyLines(FlameGame gameRef) {
    print('The state of game after call to buildReadyLines: Lines : ${GameState.linesDrawn.length} Points: ${GameState.allPoints.length}');

    tempLinesDrawn.clear();
    tempRemainingLines.clear();
    firstMaxSquareChainLines.clear();

    print('The length of tempLinesDrawn is: ${tempLinesDrawn.length}');
    print('The length of tempRemainingLines is: ${tempRemainingLines.length}');
    print('The length of linesDrawn is: ${GameState.linesDrawn.length}');
    print('The length of validLines is: ${GameState.validLines.length}');

    print('Initializing the tempLinesDrawn and tempRemainingLines');
    initTheSets();

    //! Testing that the union of tempLinesDrawn and tempRemainingLines is equal to the validLines
    print('The length of the union of tempLinesDrawn and tempRemainingLines is: ${tempLinesDrawn.union(tempRemainingLines).length}');
    //! Testing that the intersection of tempLinesDrawn and tempRemainingLines is empty
    print('The length of the intersection of tempLinesDrawn and tempRemainingLines is: ${tempLinesDrawn.intersection(tempRemainingLines).length}');

    //creating a demo line and see if it exists in tempLinesDrawn
    Point pointA = GameState.allPoints[0]!;
    Point pointB = GameState.allPoints[1]!;
    Line demoLine = Line(firstPoint: pointA, secondPoint: pointB);
    print('Printing the demoLine: $demoLine');
    print('Does the demoLine exist in tempLinesDrawn: ${tempLinesDrawn.contains(demoLine)}');
    //the above test now passes

    print('The length of firstMaxSquareChainLines is: ${firstMaxSquareChainLines.length}');
    print('Following lines are in the firstMaxSquareChainLines: $firstMaxSquareChainLines');
    print('The length of tempLinesDrawn is: ${tempLinesDrawn.length}');
    print('The length of tempRemainingLines is: ${tempRemainingLines.length}');
    print('The state of game after call to buildReadyLines: Lines : ${GameState.linesDrawn.length} Points: ${GameState.allPoints.length}');

    //Now lets call the checkSquare method and see if it works for every line in the tempLinesDrawn
    tempRemainingLines.forEach((line) {
      print('Checking for square for line: $line');
      if (checkSquare(line)) {
        firstMaxSquareChainLines.add(line);
        print('Square found for line: $line');
      }
    });

    print('The length of firstMaxSquareChainLines is: ${firstMaxSquareChainLines.length}');
    print('Following lines are in the firstMaxSquareChainLines: $firstMaxSquareChainLines');
    print('The length of tempLinesDrawn is: ${tempLinesDrawn.length}');
    print('The length of tempRemainingLines is: ${tempRemainingLines.length}');
    print('The state of game after call to buildReadyLines: Lines : ${GameState.linesDrawn.length} Points: ${GameState.allPoints.length}');
  }

  void initTheSets() {
    tempLinesDrawn.addAll(GameState.linesDrawn.values);

    GameState.validLines.forEach((key, line) {
      if (!GameState.linesDrawn.containsKey(key)) {
        tempRemainingLines.add(line);
      }
    });

    print('After initTheSets:');
    print('tempLinesDrawn: $tempLinesDrawn');
    print('tempRemainingLines: $tempRemainingLines');
  }

  // Adapted checkSquare method for AI
  bool checkSquare(Line line) {
    // Map<String, Square> squares = {};
    bool squareFound = false;

    Point p1 = line.firstPoint;
    Point p2 = line.secondPoint;

    // Determine if the line is horizontal or vertical
    bool isHorizontal = p1.yCord == p2.yCord;

    if (isHorizontal) {
      // Check for the square above the line
      Point? p3 = GameState.allPoints[p1.location - GameState.gameCanvas.xPoints];
      Point? p4 = GameState.allPoints[p2.location - GameState.gameCanvas.xPoints];

      if (p3 != null && p4 != null) {
        Line topHoriz = Line(firstPoint: p3, secondPoint: p4);
        Line leftVert = Line(firstPoint: p3, secondPoint: p1);
        Line rightVert = Line(firstPoint: p4, secondPoint: p2);

        if (tempLinesDrawn.contains(topHoriz) && tempLinesDrawn.contains(leftVert) && tempLinesDrawn.contains(rightVert)) {
          squareFound = true;
          // Add square to local collection
        }
      }

      // Check for the square below the line
      p3 = GameState.allPoints[p1.location + GameState.gameCanvas.xPoints];
      p4 = GameState.allPoints[p2.location + GameState.gameCanvas.xPoints];

      if (p3 != null && p4 != null) {
        Line bottomHoriz = Line(firstPoint: p3, secondPoint: p4);
        Line leftVert = Line(firstPoint: p1, secondPoint: p3);
        Line rightVert = Line(firstPoint: p2, secondPoint: p4);

        if (tempLinesDrawn.contains(bottomHoriz) && tempLinesDrawn.contains(leftVert) && tempLinesDrawn.contains(rightVert)) {
          squareFound = true;
          // Add square to local collection
        }
      }
    } else {
      // Vertical line: Check left and right squares
      Point? p3 = GameState.allPoints[p1.location - 1];
      Point? p4 = GameState.allPoints[p2.location - 1];

      if (p3 != null && p4 != null) {
        Line leftVert = Line(firstPoint: p3, secondPoint: p4);
        Line topHoriz = Line(firstPoint: p3, secondPoint: p1);
        Line bottomHoriz = Line(firstPoint: p4, secondPoint: p2);

        if (tempLinesDrawn.contains(leftVert) && tempLinesDrawn.contains(topHoriz) && tempLinesDrawn.contains(bottomHoriz)) {
          squareFound = true;
          // Add square to local collection
        }
      }

      p3 = GameState.allPoints[p1.location + 1];
      p4 = GameState.allPoints[p2.location + 1];

      if (p3 != null && p4 != null) {
        Line rightVert = Line(firstPoint: p3, secondPoint: p4);
        Line topHoriz = Line(firstPoint: p1, secondPoint: p3);
        Line bottomHoriz = Line(firstPoint: p2, secondPoint: p4);

        if (tempLinesDrawn.contains(rightVert) && tempLinesDrawn.contains(topHoriz) && tempLinesDrawn.contains(bottomHoriz)) {
          squareFound = true;
          // Add square to local collection
        }
      }
    }

    return squareFound;
  }
}
