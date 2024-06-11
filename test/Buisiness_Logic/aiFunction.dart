//Here we are gonna define a class named as AIFunctions which will contain all the members and methods that are used for AI purposes.

import 'game_canvas.dart';
import 'lines.dart';
import 'point.dart';
import 'square.dart';

class AIFunction {
  Map<String, Line> tempAllLinesDrawn = {};
  List<Line> firstMaxSquareChain = []; //this contains a list of lines that can be drawn successively to create a chain of square and get big scores
  Map<String, Line> tempRemainingLines = {}; //this contains the remaining lines. this map can be altered by the aifunction internally without affecting the actual remaining lines
  Map<String, Line> tempAllPossibleLines = {}; //this contains all the possible lines that can be drawn.
  List<Square> tempFirstChainSquaresOwned = []; //this contains all the squares that are owned by the ai. this list can be altered by the aifunction internally without affecting the actual squares in the game.
  //tempFirstChainSquaresOwned is just used to check if the length of the firstMaxSquareChain will match the length of the tempFirstChainSquaresOwned list

  void newGameState({required Map<String, Line> allLinesDrawn, required Map<String, Line> allPossibleLines}) {
    tempAllLinesDrawn = allLinesDrawn; //called with every ai turn after human makes a move
  }

  //fill the tempRemainingLines map with the lines that are not drawn yet
  void fillTempRemainingLines(Map<String, Line> allPossibleLines) {
    tempRemainingLines = {};
    allPossibleLines.forEach((key, value) {
      if (!tempAllLinesDrawn.containsKey(key)) {
        tempRemainingLines[key] = value;
      }
    });
  }

  //algorithm for finding the first max square chain
  /*
  -> go through every Line in the tempRemainingLines map
  -> for each Line, check if it can be used to create a square
  -> if it does, create a square object and add it to the tempAllSquaresOwned list also add the line to the firstMaxSquareChain list
  -> also add the line to the tempAllLinesDrawn map
  -> if the square is created, then call the function recursively with the updated tempRemainingLines map

  we will use simple Function call to 'CheckSquare(Line line)' to check if the line can be used to create a square.
  Here is a pseudo code:
      void firstMaxChainFinder(Map<String, Line> tempRemainingLines) {
      tempRemainingLines.forEach((key, remainingLine) {
        if(checkSquare2(remainingLine)) {
          tempAllLinesDrawn[key] = remainingLine;
          tempRemainingLines.remove(key);
          firstMaxSquareChain.add(remainingLine);
          firstMaxChainFinder(tempRemainingLines); // Recursion
        }
      });
    }
   */

  void firstMaxChainFinder() {
    tempRemainingLines.forEach((key, remainingLine) {
      if (checkSquare2(remainingLine)) {
        tempAllLinesDrawn[key] = remainingLine;
        tempRemainingLines.remove(key);
        firstMaxSquareChain.add(remainingLine);
        firstMaxChainFinder(); // Recursion
      }
    });
  }

/*defining checkSquare2(Line line) method that will check if the currently passed line
as an argument, will create a square or not. If it does, then it will return true, else false.

Here is how we are gonna check for the square:
first we are gonna check if the line is horizontal or vertical
In case if the line is horizontal:
  we will check for the square above and also below:
  
  
  Checking for square above the horizontal line:
  the first and second point of the line will be stored in the variables as P1 and P2.
  then we will find the P3 and P4 from allPoints map using the following rule:
  P3 is just above the P1 and P4 is just above the P2.
  therefore Point p3 = allPoints[P1.location - noOfXPoints] and Point p4 = allPoints[P2.location - noOfXPoints]
  then we will create lines from these points
  Line bottomHoriz = line;
  Line topHoriz = Line(firstPoint: p3, secondPoint: p4);
  Line leftVert = Line(firstPoint: p3, secondPoint: p1);
  Line rightVert = Line(firstPoint: p4, secondPoint: p2);
  then we will check if these lines are already drawn or not in the tempAllLinesDrawn map
  if three of the new lines
  ie. topHoriz, leftVert, rightVert are already drawn, then we will return true, else check next conditions.
  
  Checking for square below the horizontal line:
  the first and second point of the line will be stored in the variables as P1 and P2.
  then we will find the P3 and P4 from allPoints map using the following rule:
  P3 is just below the P1 and P4 is just below the P2.
  therefore Point p3 = allPoints[P1.location + noOfXPoints] and Point p4 = allPoints[P2.location + noOfXPoints]
  then we will create lines from these points
  Line topHoriz = line;
  Line bottomHoriz = Line(firstPoint: p3, secondPoint: p4);
  Line leftVert = Line(firstPoint: p1, secondPoint: p3);
  Line rightVert = Line(firstPoint: p2, secondPoint: p4);
  then we will check if these lines are already drawn or not in the tempAllLinesDrawn map
  if three of the new lines
  ie. bottomHoriz, leftVert, rightVert are already drawn, then we will return true, else next conditions.

In case if the line is vertical:
  we will check for the square on the left and also right:
  
  Checking for square on the left of the vertical line:
  the first and second point of the line will be stored in the variables as P1 and P2.
  then we will find the P3 and P4 from allPoints map using the following rule:
  P3 is just left of the P1 and P4 is just left of the P2.
  therefore Point p3 = allPoints[P1.location - 1] and Point p4 = allPoints[P2.location - 1]
  then we will create lines from these points
  Line rightVert = line;
  Line leftVert = Line(firstPoint: p3, secondPoint: p4);
  Line topHoriz = Line(firstPoint: p3, secondPoint: p1);
  Line bottomHoriz = Line(firstPoint: p4, secondPoint: p2);
  then we will check if these lines are already drawn or not in the tempAllLinesDrawn map
  if three of the new lines
  ie. leftVert, topHoriz, bottomHoriz are already drawn, then we will return true, else false.
  
  Checking for square on the right of the vertical line:
  the first and second point of the line will be stored in the variables as P1 and P2.
  then we will find the P3 and P4 from allPoints map using the following rule:
  P3 is just right of the P1 and P4 is just right of the P2.
  therefore Point p3 = allPoints[P1.location + 1] and Point p4 = allPoints[P2.location + 1]
  then we will create lines from these points
  Line leftVert = line;
  Line rightVert = Line(firstPoint: p3, secondPoint: p4);
  Line topHoriz = Line(firstPoint: p1, secondPoint: p3);
  Line bottomHoriz = Line(firstPoint: p2, secondPoint: p4);
  then we will check if these lines are already drawn or not in the tempAllLinesDrawn map
  if three of the new lines
  ie. rightVert, topHoriz, bottomHoriz are already drawn, then we will return true, else return false if none of the above were true.
  
  */

  bool checkSquare2(Line line) {
    if (line.direction == LineDirection.horiz) {
      Point p1 = line.firstPoint;
      Point p2 = line.secondPoint;
      Point p3 = allPoints[p1.location - gameCanvas.xPoints]!;
      Point p4 = allPoints[p2.location - gameCanvas.xPoints]!;

      Line topHoriz = Line(firstPoint: p3, secondPoint: p4);
      Line leftVert = Line(firstPoint: p3, secondPoint: p1);
      Line rightVert = Line(firstPoint: p4, secondPoint: p2);

      if (tempAllLinesDrawn.containsKey(topHoriz.toString()) && tempAllLinesDrawn.containsKey(leftVert.toString()) && tempAllLinesDrawn.containsKey(rightVert.toString())) {
        return true;
      }

      p3 = allPoints[p1.location + gameCanvas.xPoints]!;
      p4 = allPoints[p2.location + gameCanvas.xPoints]!;

      Line bottomHoriz = Line(firstPoint: p3, secondPoint: p4);
      leftVert = Line(firstPoint: p1, secondPoint: p3);
      rightVert = Line(firstPoint: p2, secondPoint: p4);

      if (tempAllLinesDrawn.containsKey(bottomHoriz.toString()) && tempAllLinesDrawn.containsKey(leftVert.toString()) && tempAllLinesDrawn.containsKey(rightVert.toString())) {
        return true;
      }
    } else {
      Point p1 = line.firstPoint;
      Point p2 = line.secondPoint;
      Point p3 = allPoints[p1.location - 1]!;
      Point p4 = allPoints[p2.location - 1]!;

      Line rightVert = Line(firstPoint: p3, secondPoint: p4);
      Line leftVert = Line(firstPoint: p3, secondPoint: p1);
      Line topHoriz = Line(firstPoint: p3, secondPoint: p1);
      Line bottomHoriz = Line(firstPoint: p4, secondPoint: p2);

      if (tempAllLinesDrawn.containsKey(leftVert.toString()) && tempAllLinesDrawn.containsKey(topHoriz.toString()) && tempAllLinesDrawn.containsKey(bottomHoriz.toString())) {
        return true;
      }

      p3 = allPoints[p1.location + 1]!;
      p4 = allPoints[p2.location + 1]!;
      leftVert = Line(firstPoint: p1, secondPoint: p3);
      rightVert = Line(firstPoint: p3, secondPoint: p4);
      topHoriz = Line(firstPoint: p1, secondPoint: p3);
      bottomHoriz = Line(firstPoint: p2, secondPoint: p4);

      if (tempAllLinesDrawn.containsKey(rightVert.toString()) && tempAllLinesDrawn.containsKey(topHoriz.toString()) && tempAllLinesDrawn.containsKey(bottomHoriz.toString())) {
        return true;
      }
    }
    return false;
  }
}


/*

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
    return '${firstPoint.location}-${secondPoint.location}'; //example 0-1
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

  //TODO : CheckHorizLineSquare() When the line is horizontal and if it forms a square above or below . it will be implemented later

  //TODO: CheckVertLineSquare() When the line is vertical and if it forms a square on the left or right . it will be implemented later
}

 */
