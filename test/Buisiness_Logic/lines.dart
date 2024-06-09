//Here is representation of a line in the game.

import 'point.dart';

//enum to show if the line is horizontal or vertical
enum LineDirection { horiz, vert }

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

  //TODO : CheckHorizLineSquare(gameState) When the line is horizontal and if it forms a square above or below . it will be implemented later

  //TODO: CheckVertLineSquare(gameState) When the line is vertical and if it forms a square on the left or right . it will be implemented later
}
