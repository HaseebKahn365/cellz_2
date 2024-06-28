//here we should be able to override the behaviours of the gui dot by extending the gui dot class.

/*
Here are the customziation that we are gonna be able to do
adjustable radius to glaal offset factor
ovrridable aiRespone method so that in future we can use streambuilder with firestore to allow players from around the world to compete.
overridable dot color and line paint color.
 */

import 'package:cellz/business_logic/point.dart';
import 'package:cellz/game_components/gui_dot.dart';

class CustomGuiDot extends Dot {
  CustomGuiDot({required Point myPoint, double radFactor = 0.13}) : super(myPoint, radFactor: radFactor);

  // @override
  // Future<void> aiResponse() async {
  //   // for now lets test it with creating a guiLine and adding it to the world

  //   await Future.delayed(Duration(seconds: 1)).then((value) {
  //     log('AI Response is called with custom features');
  //     Point firstPoint = Point(xCord: 0, yCord: 0, location: 0);
  //     Point secondPoint = Point(xCord: 1, yCord: 0, location: 1);
  //     final guiLine = GuiLine(firstPoint: firstPoint, secondPoint: secondPoint);

  //     gameRef.world.add(guiLine);
  //   });
  // }

  //the ai response also passes the test
}
