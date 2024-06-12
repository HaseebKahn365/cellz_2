//Here we are gonna define a class named as AIFunctions which will contain all the members and methods that are used for AI purposes.

import 'game_canvas.dart';
import 'lines.dart';
import 'point.dart';
import 'square.dart';

class AIFunction {
  Map<String, Line> tempAllLinesDrawn = {}; //internally drawn lines by the AI Function
  List<Line> firstMaxSquareChain = []; //this contains a list of lines that can be drawn successively to create a chain of square and get big scores
  Map<String, Line> tempRemainingLines = {}; //this contains the remaining lines. this map can be altered by the aifunction internally without affecting the actual remaining lines
  Map<String, Line> tempAllPossibleLines = {}; //this contains all the possible lines that can be drawn.
  List<Square> tempFirstChainSquaresOwned = []; //this contains all the squares that are owned by the ai. this list can be altered by the aifunction internally without affecting the actual squares in the game.
  Map<String, Line> safeLines = {}; //this contains all the safe lines that can be drawn by the ai. this list can be altered by the aifunction internally without affecting the actual safe lines in the game.
  //tempFirstChainSquaresOwned is just used to check if the length of the firstMaxSquareChain will match the length of the tempFirstChainSquaresOwned list

  void newGameState({required Map<String, Line> linesDrawnInGame, required Map<String, Line> allPossibleLines}) {
    tempAllLinesDrawn = Map<String, Line>.from(linesDrawnInGame); // create a deep copy of the linesDrawn map
    fillTempRemainingLines(allPossibleLines);
  }

  //fill the tempRemainingLines map with the lines that are not drawn yet
  void fillTempRemainingLines(Map<String, Line> allPossibleLines) {
    print('actual lines drawn before call to FMC finder: ${linesDrawn.length}');
    tempRemainingLines = {};
    allPossibleLines.forEach((key, value) {
      if (!tempAllLinesDrawn.containsKey(key)) {
        tempRemainingLines[key] = value;
      }
    });
    print('actual lines drawn after modifying tempAllLinesDrawn but before call to FMC finder: ${linesDrawn.length}');
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
    List<String> keysToRemove = [];
    print('actual lines drawn before FMC starts action : ${tempAllLinesDrawn.length}');
    tempRemainingLines.forEach((key, remainingLine) {
      if (checkSquare2(remainingLine)) {
        tempAllLinesDrawn[key] = remainingLine;
        keysToRemove.add(key);
        firstMaxSquareChain.add(remainingLine);
      }
    });

    for (String key in keysToRemove) {
      tempRemainingLines.remove(key);
    }

    // Call the method recursively after the map has been modified
    if (keysToRemove.isNotEmpty) {
      firstMaxChainFinder();
    }

    print('Length of tempAllLinesDrawn after call to FMC finder: ${tempAllLinesDrawn.length}');
    print('Length of linesDrawn after call to FMC finder: ${linesDrawn.length}');
  }

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

  bool checkSafeLine(Line line) {
    if (line.direction == LineDirection.vert) {
      Point p1 = line.firstPoint;
      Point p2 = line.secondPoint;
      // adding null safety
      Point p3, p4;
      Line topHoriz, bottomHoriz;
      if (allPoints[p1.location - 1] != null && allPoints[p2.location - 1] != null) {
        p3 = allPoints[p1.location - 1]!;
        p4 = allPoints[p2.location - 1]!;

        topHoriz = Line(firstPoint: p3, secondPoint: p1);
        bottomHoriz = Line(firstPoint: p4, secondPoint: p2);

        if (tempAllLinesDrawn.containsKey(topHoriz.toString()) && tempAllLinesDrawn.containsKey(bottomHoriz.toString())) {
          return false;
        }

        //creating leftVert and checking if leftVert and topHoriz are already drawn
        Line leftVert = Line(firstPoint: p3, secondPoint: p4);
        if (tempAllLinesDrawn.containsKey(leftVert.toString()) && tempAllLinesDrawn.containsKey(topHoriz.toString())) {
          return false;
        }

        //checking if leftVert and bottomHoriz are already drawn
        if (tempAllLinesDrawn.containsKey(leftVert.toString()) && tempAllLinesDrawn.containsKey(bottomHoriz.toString())) {
          return false;
        }
      }

      if (allPoints[p1.location + 1] != null && allPoints[p2.location + 1] != null) {
        p3 = allPoints[p1.location + 1]!;
        p4 = allPoints[p2.location + 1]!;

        topHoriz = Line(firstPoint: p1, secondPoint: p3);
        bottomHoriz = Line(firstPoint: p2, secondPoint: p4);

        if (tempAllLinesDrawn.containsKey(topHoriz.toString()) && tempAllLinesDrawn.containsKey(bottomHoriz.toString())) {
          return false;
        }

        //creating rightVert and checking if rightVert and topHoriz are already drawn
        Line rightVert = Line(firstPoint: p3, secondPoint: p4);
        if (tempAllLinesDrawn.containsKey(rightVert.toString()) && tempAllLinesDrawn.containsKey(topHoriz.toString())) {
          return false;
        }

        //checking if rightVert and bottomHoriz are already drawn
        if (tempAllLinesDrawn.containsKey(rightVert.toString()) && tempAllLinesDrawn.containsKey(bottomHoriz.toString())) {
          return false;
        }
      }
    } else {
      //Line is horizontal
      Point p1 = line.firstPoint;
      Point p2 = line.secondPoint;
      Point p3, p4;
      Line leftVert, rightVert;

      if (allPoints[p1.location - gameCanvas.xPoints] != null && allPoints[p2.location - gameCanvas.xPoints] != null) {
        p3 = allPoints[p1.location - gameCanvas.xPoints]!;
        p4 = allPoints[p2.location - gameCanvas.xPoints]!;

        leftVert = Line(firstPoint: p3, secondPoint: p1);
        rightVert = Line(firstPoint: p4, secondPoint: p2);

        if (tempAllLinesDrawn.containsKey(leftVert.toString()) && tempAllLinesDrawn.containsKey(rightVert.toString())) {
          return false;
        }

        //creating topHoriz and checking if topHoriz and leftVert are already drawn
        Line topHoriz = Line(firstPoint: p3, secondPoint: p4);
        if (tempAllLinesDrawn.containsKey(topHoriz.toString()) && tempAllLinesDrawn.containsKey(leftVert.toString())) {
          return false;
        }

        //checking if topHoriz and rightVert are already drawn
        if (tempAllLinesDrawn.containsKey(topHoriz.toString()) && tempAllLinesDrawn.containsKey(rightVert.toString())) {
          return false;
        }
      }

      if (allPoints[p1.location + gameCanvas.xPoints] != null && allPoints[p2.location + gameCanvas.xPoints] != null) {
        p3 = allPoints[p1.location + gameCanvas.xPoints]!;
        p4 = allPoints[p2.location + gameCanvas.xPoints]!;

        leftVert = Line(firstPoint: p1, secondPoint: p3);
        rightVert = Line(firstPoint: p2, secondPoint: p4);

        if (tempAllLinesDrawn.containsKey(leftVert.toString()) && tempAllLinesDrawn.containsKey(rightVert.toString())) {
          return false;
        }

        //creating bottomHoriz and checking if bottomHoriz and leftVert are already drawn
        Line bottomHoriz = Line(firstPoint: p3, secondPoint: p4);
        if (tempAllLinesDrawn.containsKey(bottomHoriz.toString()) && tempAllLinesDrawn.containsKey(leftVert.toString())) {
          return false;
        }

        //checking if bottomHoriz and rightVert are already drawn
        if (tempAllLinesDrawn.containsKey(bottomHoriz.toString()) && tempAllLinesDrawn.containsKey(rightVert.toString())) {
          return false;
        }
      }
    }
    return true;
  }

//creating a methhod to check if a line in tempRemainingLines is safe or not if it is then add it to the list of safelines
  void findSafeLines() {
    tempRemainingLines.forEach((key, line) {
      if (checkSafeLine(line)) {
        safeLines[key] = line;
      }
    });
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
