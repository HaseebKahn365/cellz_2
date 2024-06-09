//Here is representation of a line in the game.

import 'dart:developer';

import 'point.dart';

//enum to show if the line is horizontal or vertical
enum LineDirection { horiz, vert }

//Here is the Map data structure in which we will store all the lines
Map<String, Line> linesDrawn = {};
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
  bool isLineDrawn() {
    return linesDrawn.containsKey(toString());
  }

  //adding the line to the Map
  void addLine() {
    if (!isLineDrawn()) {
      linesDrawn[toString()] = this;
      log('Line added successfully!');
    }
    log('Line already exists');
  }

  //getting the sum of the locations of the two points of the line
  int getSumOfPoints() {
    return firstPoint.location + secondPoint.location;
  }

  //TODO : CheckHorizLineSquare(gameState) When the line is horizontal and if it forms a square above or below . it will be implemented later

  //TODO: CheckVertLineSquare(gameState) When the line is vertical and if it forms a square on the left or right . it will be implemented later
}
