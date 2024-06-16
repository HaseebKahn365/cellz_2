//Here is representation of a line in the game.

import 'package:cellz/business_logic/game_canvas.dart';

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
    //making sure the first point always has a smaller index than the second point
    if (firstPoint.location > secondPoint.location) {
      Point temp = firstPoint;
      firstPoint = secondPoint;
      secondPoint = temp;
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
      print('Line added successfully!');
    }
    print('Line already exists');
  }

  //getting the sum of the locations of the two points of the line
  int getSumOfPoints() {
    return firstPoint.location + secondPoint.location;
  }

  bool checkSquare() {
    if (direction == LineDirection.horiz) {
      print('The line is horizontal and is under test for above and below squares');
      print('First point: $firstPoint, Second point: $secondPoint');
      Point p1 = firstPoint;
      Point p2 = secondPoint;

      // Check for the square above the line
      if (p1.yCord > 0 && p2.yCord > 0) {
        //making sure that we name the p1 and p2 properly
        print("p1 location: " + p1.location.toString());
        print("p2 location: " + p2.location.toString());

        Point? p3 = allPoints[p1.location - (gameCanvas.xPoints - 1)];
        Point? p4 = allPoints[p2.location - (gameCanvas.xPoints - 1)];

        print(p1.location - (gameCanvas.xPoints - 1));
        print(p2.location - (gameCanvas.xPoints - 1));

        print('Above line - p3: $p3, p4: $p4');
        if (p3 != null && p4 != null) {
          Line topHoriz = Line(firstPoint: p3, secondPoint: p4);
          Line leftVert = Line(firstPoint: p3, secondPoint: p1);
          Line rightVert = Line(firstPoint: p4, secondPoint: p2);
          print('Above line - topHoriz: $topHoriz, leftVert: $leftVert, rightVert: $rightVert');

          if (linesDrawn.containsKey(topHoriz.toString()) && linesDrawn.containsKey(leftVert.toString()) && linesDrawn.containsKey(rightVert.toString())) {
            print('Square found above the line');
            return true;
          } else {
            print('Square not complete above the line');
          }
        } else {
          print('Points above the line are null');
        }
      }

      // Check for the square below the line
      print('Checking for square below the line');
      if (p1.yCord < gameCanvas.yPoints - 1 && p2.yCord < gameCanvas.yPoints - 1) {
        Point? p3 = allPoints[p1.location + (gameCanvas.xPoints - 1)];
        Point? p4 = allPoints[p2.location + (gameCanvas.xPoints - 1)];
        print('Below line - new p3: $p3, new p4: $p4');
        if (p3 != null && p4 != null) {
          Line bottomHoriz = Line(firstPoint: p3, secondPoint: p4);
          Line leftVert = Line(firstPoint: p1, secondPoint: p3);
          Line rightVert = Line(firstPoint: p2, secondPoint: p4);
          print('Below line - bottomHoriz: $bottomHoriz, leftVert: $leftVert, rightVert: $rightVert');

          if (linesDrawn.containsKey(bottomHoriz.toString()) && linesDrawn.containsKey(leftVert.toString()) && linesDrawn.containsKey(rightVert.toString())) {
            print('Square found below the line');
            return true;
          } else {
            print('Square not complete below the line');
          }
        } else {
          print('Points below the line are null');
        }
      }
    } else {
      print('The line is vertical and is under test for left and right squares');
      Point p1 = firstPoint;
      Point p2 = secondPoint;

      // Check for the square to the left of the line
      print('Checking for square to the left of the line');
      if (p1.xCord > 0 && p2.xCord > 0) {
        Point? p3 = allPoints[p1.location - 1];
        Point? p4 = allPoints[p2.location - 1];
        print('Left of line - p3: $p3, p4: $p4');
        if (p3 != null && p4 != null) {
          Line leftVert = Line(firstPoint: p3, secondPoint: p4);
          Line topHoriz = Line(firstPoint: p3, secondPoint: p1);
          Line bottomHoriz = Line(firstPoint: p4, secondPoint: p2);
          print('Left of line - leftVert: $leftVert, topHoriz: $topHoriz, bottomHoriz: $bottomHoriz');

          if (linesDrawn.containsKey(leftVert.toString()) && linesDrawn.containsKey(topHoriz.toString()) && linesDrawn.containsKey(bottomHoriz.toString())) {
            print('Square found to the left of the line');
            // return true;
          } else {
            print('Square not complete to the left of the line');
          }
        } else {
          print('Points to the left of the line are null');
        }
      }

      // Check for the square to the right of the line
      print('Checking for square to the right of the line');
      if (p1.xCord < gameCanvas.xPoints - 1 && p2.xCord < gameCanvas.xPoints - 1) {
        Point? p3 = allPoints[p1.location + 1];
        Point? p4 = allPoints[p2.location + 1];
        print('Right of line - p3: $p3, p4: $p4');
        if (p3 != null && p4 != null) {
          Line rightVert = Line(firstPoint: p3, secondPoint: p4);
          Line topHoriz = Line(firstPoint: p1, secondPoint: p3);
          Line bottomHoriz = Line(firstPoint: p2, secondPoint: p4);
          print('Right of line - rightVert: $rightVert, topHoriz: $topHoriz, bottomHoriz: $bottomHoriz');

          if (linesDrawn.containsKey(rightVert.toString()) && linesDrawn.containsKey(topHoriz.toString()) && linesDrawn.containsKey(bottomHoriz.toString())) {
            print('Square found to the right of the line');
            return true;
          } else {
            print('Square not complete to the right of the line');
          }
        } else {
          print('Points to the right of the line are null');
        }
      }
    }
    return false;
  }
}

// void main() {
//   GameCanvas gameCanvas = GameCanvas(
//     xPoints: 3,
//     yPoints: 3,
//   );

//   // // Let's create the points
//   // Point point1 = Point(xCord: 0, yCord: 0, location: 0);
//   // Point point2 = Point(xCord: 1, yCord: 0, location: 1);
//   // Point point3 = Point(xCord: 2, yCord: 0, location: 2);
//   // Point point4 = Point(xCord: 0, yCord: 1, location: 3);
//   // Point point5 = Point(xCord: 1, yCord: 1, location: 4);
//   // Point point6 = Point(xCord: 2, yCord: 1, location: 5);
//   // Point point7 = Point(xCord: 0, yCord: 2, location: 6);
//   // Point point8 = Point(xCord: 1, yCord: 2, location: 7);
//   // Point point9 = Point(xCord: 2, yCord: 2, location: 8);

//   // // Adding the points to allPoints map
//   // allPoints = {
//   //   0: point1,
//   //   1: point2,
//   //   2: point3,
//   //   3: point4,
//   //   4: point5,
//   //   5: point6,
//   //   6: point7,
//   //   7: point8,
//   //   8: point9,
//   // };

//   // // Adding lines to linesDrawn
//   // linesDrawn = gameCanvas.drawAllPossibleLines().cast<String, Line>();
//   // // Check for square

//   // Line line1 = Line(firstPoint: Point(xCord: 0, yCord: 1, location: 3), secondPoint: Point(xCord: 1, yCord: 1, location: 4));
//   // bool squareFound = line1.checkSquare();

//   // print('Square found: $squareFound'); //test passes

//   //!checking for square in case of vertical line

//   Point point1 = Point(xCord: 0, yCord: 0, location: 0);
//   Point point2 = Point(xCord: 1, yCord: 0, location: 1);
//   Point point3 = Point(xCord: 2, yCord: 0, location: 2);
//   Point point4 = Point(xCord: 0, yCord: 1, location: 3);
//   Point point5 = Point(xCord: 1, yCord: 1, location: 4);
//   Point point6 = Point(xCord: 2, yCord: 1, location: 5);
//   Point point7 = Point(xCord: 0, yCord: 2, location: 6);
//   Point point8 = Point(xCord: 1, yCord: 2, location: 7);
//   Point point9 = Point(xCord: 2, yCord: 2, location: 8);

//   // Adding the points to allPoints map
//   allPoints = {
//     0: point1,
//     1: point2,
//     2: point3,
//     3: point4,
//     4: point5,
//     5: point6,
//     6: point7,
//     7: point8,
//     8: point9,
//   };

//   Line line1 = Line(firstPoint: point1, secondPoint: point4, isMine: true);
//   Line line2 = Line(firstPoint: point2, secondPoint: point5, isMine: true);
//   Line line3 = Line(firstPoint: point4, secondPoint: point5, isMine: true);
//   Line line4 = Line(firstPoint: point5, secondPoint: point6, isMine: true);
//   Line line5 = Line(firstPoint: point1, secondPoint: point2, isMine: true);
//   Line line6 = Line(firstPoint: point2, secondPoint: point3, isMine: true);

//   Line line7 = Line(firstPoint: point3, secondPoint: point6, isMine: true);

//   line1.addLineToMap();
//   line2.addLineToMap();
//   line3.addLineToMap();
//   line4.addLineToMap();
//   line5.addLineToMap();
//   line6.addLineToMap();
//   line7.addLineToMap();

//   // line7.addLineToMap();

//   print("total Lines: " + linesDrawn.length.toString());

//   print(line2.checkSquare()); //test passes
// }
