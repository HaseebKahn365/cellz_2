//this is a class that contains all the state of the game in the form of static members and methods

import 'package:cellz/business_logic/game_canvas.dart';
import 'package:cellz/business_logic/lines.dart';
import 'package:cellz/business_logic/point.dart';
import 'package:cellz/business_logic/square.dart';

class GameState {
  static Map<String, Line> linesDrawn = {};

// and Here is how we store the all points in the game
  static Map<int, Point> allPoints = {}; //key is the location aka the index of the point in the grid

  //a static member for all squares
  static List<Square> allSquares = [];

  //a static member to control the turns oof the player.
  static bool myTurn = true; //if false then it is AI's turn

  //To add some spice to the game, we record the chain of square formation which is identified if the turn doesn't change and player keeps making squares

  static int chainCount = 0;

  static void switchTurn() {
    myTurn = !myTurn;
    chainCount = 0; //reset chain square count as turn changes
  }

  //the gameState will also have a GameCanvas instance that will be used for maintaining the info about the current level
  static late GameCanvas gameCanvas;

  static initGameCanvas({required int xPoints, required int yPoints}) {
    gameCanvas = GameCanvas(xPoints: xPoints, yPoints: yPoints);
  }
}
