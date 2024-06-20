import 'package:cellz/business_logic/game_canvas.dart';
import 'package:cellz/business_logic/game_state.dart';
import 'package:cellz/business_logic/lines.dart';
import 'package:flame/game.dart';
import 'point.dart';

class AIFunction {
  Set<Line> tempLinesDrawn = {};
  Set<Line> tempRemainingLines = {};
  Set<Line> firstMaxSquareChainLines = {};

  void buildReadyLines(FlameGame gameRef) {
    print('The state of game after call to buildReadyLines: Lines : ${GameState.linesDrawn.length} Points: ${GameState.allPoints.length}');

    tempLinesDrawn.clear();
    tempRemainingLines.clear();
    firstMaxSquareChainLines.clear();

    print('The length of tempLinesDrawn is: ${tempLinesDrawn.length}');
    print('The length of tempRemainingLines is: ${tempRemainingLines.length}');
    print('The length of linesDrawn is: ${GameState.linesDrawn.length}');
    print('The length of validLines is: ${GameState.validLines.length}');

    print('Initializing the tempLinesDrawn and tempRemainingLines');
    initTheSets();

    //! Testing that the union of tempLinesDrawn and tempRemainingLines is equal to the validLines
    print('The length of the union of tempLinesDrawn and tempRemainingLines is: ${tempLinesDrawn.union(tempRemainingLines).length}');
    //! Testing that the intersection of tempLinesDrawn and tempRemainingLines is empty
    print('The length of the intersection of tempLinesDrawn and tempRemainingLines is: ${tempLinesDrawn.intersection(tempRemainingLines).length}');

    //creating a demo line and see if it exists in tempLinesDrawn
    Point pointA = GameState.allPoints[0]!;
    Point pointB = GameState.allPoints[1]!;
    Line demoLine = Line(firstPoint: pointA, secondPoint: pointB);
    print('Printing the demoLine: $demoLine');
    print('Does the demoLine exist in tempLinesDrawn: ${tempLinesDrawn.contains(demoLine)}');

    print('The length of firstMaxSquareChainLines is: ${firstMaxSquareChainLines.length}');
    print('Following lines are in the firstMaxSquareChainLines: $firstMaxSquareChainLines');
    print('The length of tempLinesDrawn is: ${tempLinesDrawn.length}');
    print('The length of tempRemainingLines is: ${tempRemainingLines.length}');
    print('The state of game after call to buildReadyLines: Lines : ${GameState.linesDrawn.length} Points: ${GameState.allPoints.length}');
  }

  void initTheSets() {
    tempLinesDrawn.addAll(GameState.linesDrawn.values);

    GameState.validLines.forEach((key, line) {
      if (!GameState.linesDrawn.containsKey(key)) {
        tempRemainingLines.add(line);
      }
    });

    print('After initTheSets:');
    print('tempLinesDrawn: $tempLinesDrawn');
    print('tempRemainingLines: $tempRemainingLines');
  }
}
