//Here we are gonna define a class named as AIFunctions which will contain all the members and methods that are used for AI purposes.

import 'package:cellz/business_logic/game_state.dart';

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
    //Making sure that we start off with a blank slate:
    firstMaxSquareChain = [];
    tempRemainingLines = {};
    tempFirstChainSquaresOwned = [];
    safeLines = {};
    tempAllLinesDrawn = Map<String, Line>.from(linesDrawnInGame); // create a deep copy of the linesDrawn map
    fillTempRemainingLines(allPossibleLines);
  }

  //fill the tempRemainingLines map with the lines that are not drawn yet
  void fillTempRemainingLines(Map<String, Line> allPossibleLines) {
    print('actual lines drawn before call to FMC finder: ${GameState.linesDrawn.length}');
    tempRemainingLines = {};
    allPossibleLines.forEach((key, value) {
      if (!tempAllLinesDrawn.containsKey(key)) {
        tempRemainingLines[key] = value;
      }
    });
    print('actual lines drawn after modifying tempAllLinesDrawn but before call to FMC finder: ${GameState.linesDrawn.length}');
  }

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
    print('Length of linesDrawn after call to FMC finder: ${GameState.linesDrawn.length}');
  }

  bool checkSquare2(Line line) {
    if (line.direction == LineDirection.horiz) {
      Point p1 = line.firstPoint;
      Point p2 = line.secondPoint;

      Point? p3, p4;
      p3 = GameState.allPoints[p1.location - gameCanvas.xPoints];
      p4 = GameState.allPoints[p2.location - gameCanvas.xPoints];

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

      p3 = GameState.allPoints[p1.location + gameCanvas.xPoints];
      p4 = GameState.allPoints[p2.location + gameCanvas.xPoints];

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
      p3 = GameState.allPoints[p1.location - 1];
      p4 = GameState.allPoints[p2.location - 1];

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

      p3 = GameState.allPoints[p1.location + 1];
      p4 = GameState.allPoints[p2.location + 1];

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
      if (GameState.allPoints[p1.location - 1] != null && GameState.allPoints[p2.location - 1] != null) {
        p3 = GameState.allPoints[p1.location - 1]!;
        p4 = GameState.allPoints[p2.location - 1]!;

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

      if (GameState.allPoints[p1.location + 1] != null && GameState.allPoints[p2.location + 1] != null) {
        p3 = GameState.allPoints[p1.location + 1]!;
        p4 = GameState.allPoints[p2.location + 1]!;

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

      if (GameState.allPoints[p1.location - gameCanvas.xPoints] != null && GameState.allPoints[p2.location - gameCanvas.xPoints] != null) {
        p3 = GameState.allPoints[p1.location - gameCanvas.xPoints]!;
        p4 = GameState.allPoints[p2.location - gameCanvas.xPoints]!;

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

      if (GameState.allPoints[p1.location + gameCanvas.xPoints] != null && GameState.allPoints[p2.location + gameCanvas.xPoints] != null) {
        p3 = GameState.allPoints[p1.location + gameCanvas.xPoints]!;
        p4 = GameState.allPoints[p2.location + gameCanvas.xPoints]!;

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

  /*
  
  Using the AIFunction:
  create a list of lines called readyMoves
  at first we all the newGameState method to initialize the AIFunction with the current state of the game.
  then all the responsibility is handled by buildReadyMoves method.
  in the buildReadyMoves method we call the firstMaxChainFinder method to find the first max chain of squares that can be drawn by the AI.
  then we check if the length of the firstMaxSquareChain is greater that 2, add these to the readyMoves, then we have to check for all the safelines.
  then we check if the safelines isNotEmpty. if its not empty, then append a safeline the to the readyMoves list.
  in case if the safelines is empty, then we need to remove the second last line from the readyMoves.
  if the firstMaxSquareChain is less than 2, then add the firstMaxSquareChain to the readyMoves list, then append a line for which the checkSafeLine is true.
  
   */

  List<Line> buildReadyMoves() {
    List<Line> readyMoves = [];
    newGameState(linesDrawnInGame: GameState.linesDrawn, allPossibleLines: GameState.validLines);
    firstMaxChainFinder();
    if (firstMaxSquareChain.length >= 2) {
      readyMoves.addAll(firstMaxSquareChain);
      findSafeLines();
      if (safeLines.isNotEmpty) {
        readyMoves.add(safeLines.values.first);
      } else {
        readyMoves.removeAt(readyMoves.length - 2);
      }
    } else {
      readyMoves.addAll(firstMaxSquareChain);
      for (Line line in tempRemainingLines.values) {
        if (checkSafeLine(line)) {
          readyMoves.add(line);
          break;
        }
      }
    }

    print('The AIFunction has prepared the following moves {${readyMoves.length}}: $readyMoves');
    return readyMoves;
  }
}
