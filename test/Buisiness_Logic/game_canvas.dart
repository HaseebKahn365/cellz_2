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
  int movesLeft;
  GameCanvas({required this.xPoints, required this.yPoints, required this.movesLeft}) {
    createPoints();
    calculateMovesLeft();
  }

  void createPoints() {
    for (int i = 0; i < xPoints; i++) {
      for (int j = 0; j < yPoints; j++) {
        allPoints[i * yPoints + j] = Point(xCord: i, yCord: j, location: i * yPoints + j);
      }
    }
  }

  void calculateMovesLeft() {
    movesLeft = (xPoints - 1) * (yPoints - 1);
  }

  void decrementMovesLeft() {
    movesLeft--;
  }
}
