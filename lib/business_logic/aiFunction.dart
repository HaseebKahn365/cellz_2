//Here we are gonna define a class named as AIFunctions which will contain all the members and methods that are used for AI purposes.

import 'package:cellz/business_logic/game_canvas.dart';
import 'package:cellz/business_logic/game_state.dart';
import 'package:cellz/business_logic/lines.dart';
import 'package:cellz/game_components/gui_line_for_ai.dart';
import 'package:cellz/game_components/gui_square.dart';
import 'package:flame/components.dart';
import 'package:flame/game.dart';

import 'point.dart';

class AIFunction {
  //I need to redesign this ai function in order to test it in small pieces our first strategy is to make the buildReadyMoves incredibly simple to use
  /*

  All the logic of creating the gui components and future awaits will be build here. we would only need to pass the gameRef as a parameter to it.
  
   */

  //testing the gui line and gui square formation from this class:

  void testComponentCreation(FlameGame<World> gameRef) {
    // Creating a sample GuiLine for demo
    // Point firstPoint = Point(xCord: 2, yCord: 0, location: 0);
    // Point secondPoint = Point(xCord: 3, yCord: 0, location: 1);
    // GuiLineForAi guiLine = GuiLineForAi(
    //   firstPoint: firstPoint,
    //   secondPoint: secondPoint,
    // );
    // gameRef.world.add(guiLine);

    // // Creating a sample GuiSquare for demo

    // GuiSquare guiSquare = GuiSquare(
    //   isMine: true, // Set to true for demo purposes
    //   myXcord: firstPoint.xCord,
    //   myYcord: firstPoint.yCord,
    // );
    // gameRef.world.add(guiSquare);

    //The above test was passed sucessfully
  }

  //testing the proper intialization of necessary data structures; the following is the actual function that is called
  Map<String, Line> tempLinesDrawn = {}; //it contains the modified lines drawn by the AI
  Map<String, Line> tempRemainingLines = {}; //it contains the remaining lines that can be drawn by the AI
  List<Line> firstMaxSquareChainLines = []; //it contains the first max square chain that can be drawn by the AI

  void buildReadyLines(FlameGame<World> gameRef) {
    print('The state of game after call to buildReadyLines: Lines : ${GameState.linesDrawn.length} Points: ${GameState.allPoints.length}');

    //!clearing the previous data
    tempLinesDrawn = {};
    tempRemainingLines = {};
    firstMaxSquareChainLines = [];

    //!initializing the tempLinesDrawn and tempRemainingLines
    // tempLinesDrawn = map.dromGameState.linesDrawn;
    tempLinesDrawn = Map.from(GameState.linesDrawn); //this approach is not good so lets manually create each line object and put it in the map
    tempRemainingLines.addEntries(GameState.validLines.entries.where((element) => !tempLinesDrawn.containsKey(element.key))); //Here we use ==

    print('The length of tempLinesDrawn is: ${tempLinesDrawn.length}');
    print('The length of tempRemainingLines is: ${tempRemainingLines.length}');
    print('The length of linesDrawn is: ${GameState.linesDrawn.length}');
    print('The length of validLines is: ${GameState.validLines.length}');

    //!Filling the firstMaxChainLines

    print('The length of firstMaxSquareChainLines is: ${firstMaxSquareChainLines.length}');
    print('Following lines are in the firstMaxSquareChainLines: $firstMaxSquareChainLines');
    print('The state of game after call to buildReadyLines: Lines : ${GameState.linesDrawn.length} Points: ${GameState.allPoints.length}');
  }
}
