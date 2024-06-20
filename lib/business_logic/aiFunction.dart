import 'package:cellz/business_logic/game_state.dart';
import 'package:cellz/business_logic/lines.dart';
import 'package:flame/game.dart';
import 'point.dart';

class AIFunction {
  Set<Line> tempLinesDrawn = {};
  Set<Line> tempRemainingLines = {};
  Set<Line> firstMaxSquareChainLines = {};
  Set<Line> safeLines = {};

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
    // Point pointA = GameState.allPoints[0]!;
    // Point pointB = GameState.allPoints[1]!;
    // Line demoLine = Line(firstPoint: pointA, secondPoint: pointB);
    // print('Printing the demoLine: $demoLine');
    // print('Does the demoLine exist in tempLinesDrawn: ${tempLinesDrawn.contains(demoLine)}');
    //the above test now passes

    print('The length of firstMaxSquareChainLines is: ${firstMaxSquareChainLines.length}');
    print('Following lines are in the firstMaxSquareChainLines: $firstMaxSquareChainLines');
    print('The length of tempLinesDrawn is: ${tempLinesDrawn.length}');
    print('The length of tempRemainingLines is: ${tempRemainingLines.length}');
    print('The state of game after call to buildReadyLines: Lines : ${GameState.linesDrawn.length} Points: ${GameState.allPoints.length}');

    //Now lets call the checkSquare method and see if it works for every line in the tempLinesDrawn
    fillFirstMaxSquareChain(tempLinesDrawn, tempRemainingLines);

    print('The length of firstMaxSquareChainLines is: ${firstMaxSquareChainLines.length}');
    print('Following lines are in the firstMaxSquareChainLines: $firstMaxSquareChainLines');
    print('The length of tempLinesDrawn is: ${tempLinesDrawn.length}');
    print('The length of tempRemainingLines is: ${tempRemainingLines.length}');
    print('The state of game after call to buildReadyLines: Lines : ${GameState.linesDrawn.length} Points: ${GameState.allPoints.length}');

    //now lets find the safeLines
    print('Before findSafeLines: tempLinesDrawn: ${tempLinesDrawn.length} tempRemainingLines: ${tempRemainingLines.length} and safeLines: ${safeLines.length}');
    findSafeLines();
    print('After findSafeLines: tempLinesDrawn: ${tempLinesDrawn.length} tempRemainingLines: ${tempRemainingLines.length} and safeLines: ${safeLines.length}');
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

  //creating a recursive function for to find the lines for the firstSquareChain.
  /*
  The firstMaxSquareChainLines are a series of lines that when drawn in order will form a series of squares in sucession 
   */

  void fillFirstMaxSquareChain(Set<Line> tmpLnsDrwn, Set<Line> tmpRemLns) {
    int num = tmpRemLns.length;
    for (int i = 0; i < num; i++) {
      //go through every line in tmpRemLns and if the checkSquare returns true for it then add this line to the tmpLnsDrwn and remove it from the tmpRemLns and recursively call the fillFirstMaxSquareChain again
      Line line = tmpRemLns.elementAt(i);
      if (checkSquare(line)) {
        //also add the line to the firstMaxSquareChainLines
        firstMaxSquareChainLines.add(line);
        tmpLnsDrwn.add(line);
        tmpRemLns.remove(line);
        fillFirstMaxSquareChain(tmpLnsDrwn, tmpRemLns); //Set was a better option than List or Map because it allowed us for indexing and unique values
        break;
      }
    }
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

//now we need to find the safeLines
/*
we will need safelines to be able to draw a line that will not allow the opponent to complete a square
 */

//! method to find all the safelines:
  void findSafeLines() {
    safeLines.clear();
    for (Line line in tempRemainingLines) {
      if (checkSafeLine(line)) {
        safeLines.add(line);
      }
    }
  }

//! method to check if a line is safe
  bool checkSafeLine(Line line) {
    if (line.direction == LineDirection.vert) {
      Point p1 = line.firstPoint;
      Point p2 = line.secondPoint;
      Point? p3, p4;
      Line? topHoriz, bottomHoriz;

      // Check left side
      p3 = GameState.allPoints[p1.location - 1];
      p4 = GameState.allPoints[p2.location - 1];
      if (p3 != null && p4 != null) {
        topHoriz = Line(firstPoint: p3, secondPoint: p1);
        bottomHoriz = Line(firstPoint: p4, secondPoint: p2);

        if (tempLinesDrawn.contains(topHoriz) && tempLinesDrawn.contains(bottomHoriz)) {
          return false;
        }

        Line leftVert = Line(firstPoint: p3, secondPoint: p4);
        if (tempLinesDrawn.contains(leftVert) && tempLinesDrawn.contains(topHoriz)) {
          return false;
        }
        if (tempLinesDrawn.contains(leftVert) && tempLinesDrawn.contains(bottomHoriz)) {
          return false;
        }
      }

      // Check right side
      p3 = GameState.allPoints[p1.location + 1];
      p4 = GameState.allPoints[p2.location + 1];
      if (p3 != null && p4 != null) {
        topHoriz = Line(firstPoint: p1, secondPoint: p3);
        bottomHoriz = Line(firstPoint: p2, secondPoint: p4);

        if (tempLinesDrawn.contains(topHoriz) && tempLinesDrawn.contains(bottomHoriz)) {
          return false;
        }

        Line rightVert = Line(firstPoint: p3, secondPoint: p4);
        if (tempLinesDrawn.contains(rightVert) && tempLinesDrawn.contains(topHoriz)) {
          return false;
        }
        if (tempLinesDrawn.contains(rightVert) && tempLinesDrawn.contains(bottomHoriz)) {
          return false;
        }
      }
    } else {
      // Line is horizontal
      Point p1 = line.firstPoint;
      Point p2 = line.secondPoint;
      Point? p3, p4;
      Line? leftVert, rightVert;

      // Check top side
      p3 = GameState.allPoints[p1.location - GameState.gameCanvas.xPoints];
      p4 = GameState.allPoints[p2.location - GameState.gameCanvas.xPoints];
      if (p3 != null && p4 != null) {
        leftVert = Line(firstPoint: p3, secondPoint: p1);
        rightVert = Line(firstPoint: p4, secondPoint: p2);

        if (tempLinesDrawn.contains(leftVert) && tempLinesDrawn.contains(rightVert)) {
          return false;
        }

        Line topHoriz = Line(firstPoint: p3, secondPoint: p4);
        if (tempLinesDrawn.contains(topHoriz) && tempLinesDrawn.contains(leftVert)) {
          return false;
        }
        if (tempLinesDrawn.contains(topHoriz) && tempLinesDrawn.contains(rightVert)) {
          return false;
        }
      }

      // Check bottom side
      p3 = GameState.allPoints[p1.location + GameState.gameCanvas.xPoints];
      p4 = GameState.allPoints[p2.location + GameState.gameCanvas.xPoints];
      if (p3 != null && p4 != null) {
        leftVert = Line(firstPoint: p1, secondPoint: p3);
        rightVert = Line(firstPoint: p2, secondPoint: p4);

        if (tempLinesDrawn.contains(leftVert) && tempLinesDrawn.contains(rightVert)) {
          return false;
        }

        Line bottomHoriz = Line(firstPoint: p3, secondPoint: p4);
        if (tempLinesDrawn.contains(bottomHoriz) && tempLinesDrawn.contains(leftVert)) {
          return false;
        }
        if (tempLinesDrawn.contains(bottomHoriz) && tempLinesDrawn.contains(rightVert)) {
          return false;
        }
      }
    }
    return true;
  }
}
