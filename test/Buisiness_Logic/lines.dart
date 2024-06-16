//Here is representation of a line in the game.

import 'dart:developer';

import 'point.dart';

//enum to show if the line is horizontal or vertical
enum LineDirection { horiz, vert }

//Here is the Map data structure in which we will store all the lines
Map<String, Line> linesDrawn = {};

// and Here is how we store the all points in the game
Map<int, Point> allPoints = {}; //key is the location aka the index of the point in the grid

/*example 
{
  {0-1 : Line(firstPoint: Point(xCord: 0, yCord: 0), secondPoint: Point(xCord: 1, yCord: 0), direction: LineDirection.horiz)},
  {1-2 : Line(firstPoint: Point(xCord: 1, yCord: 0), secondPoint: Point(xCord: 2, yCord: 0), direction: LineDirection.horiz)},
  {2-3 : Line(firstPoint: Point(xCord: 2, yCord: 0), secondPoint: Point(xCord: 3, yCord: 0), direction: LineDirection.horiz)},
}

*/

class Line {
  Point firstPoint;
  Point secondPoint;
  bool isMine; //to show if the line is created by the player or the AI
  late LineDirection direction;

  Line({required this.firstPoint, required this.secondPoint, this.isMine = false}) {
    if (firstPoint.xCord == secondPoint.xCord) {
      direction = LineDirection.vert;
    } else {
      direction = LineDirection.horiz;
    }
  }

  @override
  bool operator ==(Object other) {
    if (other is Line) {
      return (firstPoint == other.firstPoint && secondPoint == other.secondPoint) || (firstPoint == other.secondPoint && secondPoint == other.firstPoint);
    }
    return false;
  }

  //coverting the line to string for proper storage in the Map
  @override
  String toString() {
    int firstLocation = firstPoint.location;
    int secondLocation = secondPoint.location;
    if (firstLocation < secondLocation) {
      return '$firstLocation-$secondLocation';
    } else {
      return '$secondLocation-$firstLocation';
    }
  }

  //before adding a line we covert it to string and check if it already exists in the Map
  bool isAlreadyLineDrawn() {
    //check for both cases ie. reverse the points and check again
    return linesDrawn.containsKey(toString()) || linesDrawn.containsKey('${secondPoint.location}-${firstPoint.location}');
  }

  //adding the line to the Map
  void addLineToMap() {
    if (!isAlreadyLineDrawn()) {
      linesDrawn[toString()] = this;
      log('Line added successfully!');
    }
    log('Line already exists');
  }

  //getting the sum of the locations of the two points of the line
  int getSumOfPoints() {
    return firstPoint.location + secondPoint.location;
  }


  /*
  The following is the logic for finding the square formation through the lines drawn in the game. i have taken it from the ai function so we need to modify it for the GameState.

    bool checkSquare2(Line line) {
    if (line.direction == LineDirection.horiz) {
      Point p1 = line.firstPoint;
      Point p2 = line.secondPoint;

      Point? p3, p4;
      p3 = allPoints[p1.location - gameCanvas.xPoints];
      p4 = allPoints[p2.location - gameCanvas.xPoints];

      Line topHoriz, bottomHoriz, leftVert, rightVert;
      if (p3 != null && p4 != null) {
        topHoriz = Line(firstPoint: p3, secondPoint: p4);
        leftVert = Line(firstPoint: p3, secondPoint: p1);
        rightVert = Line(firstPoint: p4, secondPoint: p2);

        if (tempAllLinesDrawn.containsKey(topHoriz.toString()) && tempAllLinesDrawn.containsKey(leftVert.toString()) && tempAllLinesDrawn.containsKey(rightVert.toString())) {
          // also add the square to the tempFirstChainSquaresOwned list
          tempFirstChainSquaresOwned.add(Square(topHoriz: topHoriz, bottomHoriz: line, leftVert: leftVert, rightVert: rightVert, isMine: false));
          return true;
        }
      }

      p3 = allPoints[p1.location + gameCanvas.xPoints];
      p4 = allPoints[p2.location + gameCanvas.xPoints];

      if (p3 != null && p4 != null) {
        bottomHoriz = Line(firstPoint: p3, secondPoint: p4);
        leftVert = Line(firstPoint: p1, secondPoint: p3);
        rightVert = Line(firstPoint: p2, secondPoint: p4);

        if (tempAllLinesDrawn.containsKey(bottomHoriz.toString()) && tempAllLinesDrawn.containsKey(leftVert.toString()) && tempAllLinesDrawn.containsKey(rightVert.toString())) {
          // also add the square to the tempFirstChainSquaresOwned list
          tempFirstChainSquaresOwned.add(Square(topHoriz: line, bottomHoriz: bottomHoriz, leftVert: leftVert, rightVert: rightVert, isMine: false));
          return true;
        }
      }
    } else {
      Point p1 = line.firstPoint;
      Point p2 = line.secondPoint;

      Point? p3, p4;
      p3 = allPoints[p1.location - 1];
      p4 = allPoints[p2.location - 1];

      Line rightVert, leftVert, topHoriz, bottomHoriz;
      if (p3 != null && p4 != null) {
        rightVert = Line(firstPoint: p3, secondPoint: p4);
        leftVert = Line(firstPoint: p3, secondPoint: p1);
        topHoriz = Line(firstPoint: p3, secondPoint: p1);
        bottomHoriz = Line(firstPoint: p4, secondPoint: p2);

        if (tempAllLinesDrawn.containsKey(leftVert.toString()) && tempAllLinesDrawn.containsKey(topHoriz.toString()) && tempAllLinesDrawn.containsKey(bottomHoriz.toString())) {
          // also add the square to the tempFirstChainSquaresOwned list
          tempFirstChainSquaresOwned.add(Square(topHoriz: topHoriz, bottomHoriz: bottomHoriz, leftVert: leftVert, rightVert: line, isMine: false));
          return true;
        }
      }

      p3 = allPoints[p1.location + 1];
      p4 = allPoints[p2.location + 1];

      if (p3 != null && p4 != null) {
        leftVert = Line(firstPoint: p1, secondPoint: p3);
        rightVert = Line(firstPoint: p3, secondPoint: p4);
        topHoriz = Line(firstPoint: p1, secondPoint: p3);
        bottomHoriz = Line(firstPoint: p2, secondPoint: p4);

        if (tempAllLinesDrawn.containsKey(rightVert.toString()) && tempAllLinesDrawn.containsKey(topHoriz.toString()) && tempAllLinesDrawn.containsKey(bottomHoriz.toString())) {
          // also add the square to the tempFirstChainSquaresOwned list
          tempFirstChainSquaresOwned.add(Square(topHoriz: topHoriz, bottomHoriz: bottomHoriz, leftVert: line, rightVert: rightVert, isMine: false));
          return true;
        }
      }
    }
    return false;
  }

  Instead of reading the points and lines from the Maps of the AIFunction it needs to read these from the GameState.allPoints and GameState.linesDrawn
   */

  //checking if the square is formed by the line

  bool checkSquare() {
    if (direction == LineDirection.horiz) {
      Point p1 = firstPoint;
      Point p2 = secondPoint;

      Point? p3, p4;
      p3 = allPoints[p1.location - 1];
      p4 = allPoints[p2.location - 1];

      Line rightVert, leftVert, topHoriz, bottomHoriz;
      if (p3 != null && p4 != null) {
        rightVert = Line(firstPoint: p3, secondPoint: p4);
        leftVert = Line(firstPoint: p3, secondPoint: p1);
        topHoriz = Line(firstPoint: p3, secondPoint: p1);
        bottomHoriz = Line(firstPoint: p4, secondPoint: p2);

        if (linesDrawn.containsKey(leftVert.toString()) && linesDrawn.containsKey(topHoriz.toString()) && linesDrawn.containsKey(bottomHoriz.toString())) {
          // also add the square to the tempFirstChainSquaresOwned list
          return true;
        }
      }

      p3 = allPoints[p1.location + 1];
      p4 = allPoints[p2.location + 1];

      if (p3 != null && p4 != null) {
        leftVert = Line(firstPoint: p1, secondPoint: p3);
        rightVert = Line(firstPoint: p3, secondPoint: p4);
        topHoriz = Line(firstPoint: p1, secondPoint: p3);
        bottomHoriz = Line(firstPoint: p2, secondPoint: p4);

        if (linesDrawn.containsKey(rightVert.toString()) && linesDrawn.containsKey(topHoriz.toString()) && linesDrawn.containsKey(bottomHoriz.toString())) {
          // also add the square to the tempFirstChainSquaresOwned list
          return true;
        }
      }
    } else {
      Point p1 = firstPoint;
      Point p2 = secondPoint;

      Point? p3, p4;
      p3 = allPoints[p1.location - 10];
      p4 = allPoints[p2.location - 10];

      Line topHoriz, bottomHoriz, leftVert, rightVert;
      if (p3 != null && p4 != null) {
        topHoriz = Line(firstPoint: p3, secondPoint: p4);
        leftVert = Line(firstPoint: p3, secondPoint: p1);

        rightVert = Line(firstPoint: p4, secondPoint: p2);
        
        if (linesDrawn.containsKey(topHoriz.toString()) && linesDrawn.containsKey(leftVert.toString()) && linesDrawn.containsKey(rightVert.toString())) {
          // also add the square to the tempFirstChainSquaresOwned list
          return true;
        }

      }
      


}
