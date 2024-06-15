//this is a class that contains all the state of the game in the form of static members and methods

import 'package:cellz/business_logic/lines.dart';
import 'package:cellz/business_logic/point.dart';

class GameState {
  static Map<String, Line> linesDrawn = {};

// and Here is how we store the all points in the game
  static Map<int, Point> allPoints = {}; //key is the location aka the index of the point in the grid
}
