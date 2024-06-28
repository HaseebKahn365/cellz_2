//this is a class that contains all the state of the game in the form of static members and methods

import 'package:cellz/business_logic/game_canvas.dart';
import 'package:cellz/business_logic/lines.dart';
import 'package:cellz/business_logic/point.dart';
import 'package:cellz/business_logic/square.dart';
import 'package:flutter/material.dart';

class GameState {
  static Map<String, Line> linesDrawn = {};

  static double globalOffset = 150; //this is the offset that is used to properly adjust the dots in the game.

// and Here is how we store the all points in the game
  static Map<int, Point> allPoints = {}; //key is the location aka the index of the point in the grid

  static List<Color> colorSet = [
    Colors.purple, //color for bg
    Colors.white, //color for drag line
    Colors.blue, //dot color

    Colors.green, //human color
    Colors.red, //AI color

    Colors.white, //square icon box color //5th index

    Colors.red, //most recent line color //6th index
    Colors.teal, //old line color //7th index
  ];

  static List<IconData> iconSet = [
    Icons.check, //human
    Icons.close_rounded, //ai icon
  ];

  //a static member for all squares
  static Map<String, Square> allSquares = {};

  //a static member to control the turns oof the player.
  static bool myTurn = true; //if false then it is AI's turn

  //To add some spice to the game, we record the chain of square formation which is identified if the turn doesn't change and player keeps making squares

  static int chainCount = 0;

  static void switchTurn() {
    print('Switching turn since No square was formed & chain count is $chainCount');

    myTurn = !myTurn;
    chainCount = 0; //reset chain square count as turn changes
  }

  //the gameState will also have a GameCanvas instance that will be used for maintaining the info about the current level
  static late GameCanvas gameCanvas;

  //we should have a map of all the valid lines in the game so that invalid lines may not be allowed to draw

  static Map<String, Line> validLines = {};

  static initGameCanvas({required int xPoints, required int yPoints}) {
    gameCanvas = GameCanvas(xPoints: xPoints, yPoints: yPoints);
    validLines = gameCanvas.drawAllPossibleLines();
  }
}
