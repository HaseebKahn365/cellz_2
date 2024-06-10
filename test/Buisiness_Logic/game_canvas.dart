/*
This is an important class that represents a level in the game.
it contains the number of x points and y points.
it contains the number of movesLeft 
it also contains the following methods

createPoints() : creates the points for the level and fills the allPoints map
calculateMovesLeft() : calculates the number of moves left in the game
decrementMovesLeft() : decrements the number of moves left

 */

import 'lines.dart';
import 'point.dart';

class GameCanvas {
  int xPoints;
  int yPoints;
  late int movesLeft;
  GameCanvas({required this.xPoints, required this.yPoints}) {
    createPoints();
    calculateMovesLeft();
  }

  void createPoints() {
    // Make sure to empty the allPoints map before adding new points
    // Also make sure to empty the linesDrawn map
    allPoints = {};
    linesDrawn = {};

    for (int j = 0; j < yPoints; j++) {
      for (int i = 0; i < xPoints; i++) {
        allPoints[j * xPoints + i] = Point(xCord: i, yCord: j, location: j * xPoints + i);
      }
    }
  }

  void calculateMovesLeft() {
    movesLeft = ((xPoints - 1) * yPoints) + ((yPoints - 1) * xPoints);
  }

  void decrementMovesLeft() {
    movesLeft--;
  }

  //creating a method that will be used to draw every possible line and returns a map of Lines

  Map<String, Line> drawAllPossibleLines() {
    Map<String, Line> allPossibleLines = {};

    //drawing horizontal lines

    return allPossibleLines;
  }
}
