import 'lines.dart';

class Square {
  late Line l1Horizontal; //TOP HORIZONTAL LINE
  late Line l2Horizontal; //BOTTOM HORIZONTAL LINE
  late Line l1Vertical; //LEFT VERTICAL LINE
  late Line l2Vertical; //RIGHT VERTICAL LINE
  int xCord = 0;
  int yCord = 0; //these cordinates indicate the offset for the ui to show where to render the square
  bool isMine;
  Square({required Line firstHoriz, required Line secondHoriz, required Line firstVert, required Line secondVert, this.isMine = false}) {
    if (firstHoriz.getSumOfPoints() < secondHoriz.getSumOfPoints()) {
      l1Horizontal = firstHoriz;
      l2Horizontal = secondHoriz;
    } else {
      l1Horizontal = secondHoriz;
      l2Horizontal = firstHoriz;
    }

    if (firstVert.getSumOfPoints() < secondVert.getSumOfPoints()) {
      l1Vertical = firstVert;
      l2Vertical = secondVert;
    } else {
      l1Vertical = secondVert;
      l2Vertical = firstVert;
    }

    findAndSetCordinates();
  }

  void findAndSetCordinates() {
    if (l1Horizontal.firstPoint.location < l1Vertical.firstPoint.location) {
      xCord = l1Horizontal.firstPoint.xCord;
      yCord = l1Horizontal.firstPoint.yCord;
      return;
    } else {
      xCord = l1Horizontal.secondPoint.xCord;
      yCord = l1Horizontal.secondPoint.yCord;
    }
  }
}
