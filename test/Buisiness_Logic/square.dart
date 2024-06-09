import 'lines.dart';

class Square {
  late Line l1Horizontal; //TOP HORIZONTAL LINE
  late Line l2Horizontal; //BOTTOM HORIZONTAL LINE
  late Line l1Vertical; //LEFT VERTICAL LINE
  late Line l2Vertical; //RIGHT VERTICAL LINE
  bool isMine;
  Square({required Line firstHoriz, required Line secondHoriz, required Line firstVert, required Line secondVert, this.isMine = false}) {
    /*
  Here we need to properly check which line to make l1Horizontal, l2Horizontal, l1Vertical, l2Vertical respectively.
  Here is the rule:
  We need to get the toString of each line which will give us... for example:
  l1Horizontal = 0-1
  l2Horizontal = 1-2
  l1Vertical = 0-3
  l2Vertical = 1-4

  We know that the sum of 0+1 of l1Horizontal is less than the sum of 1+2 of l2Horizontal. this means that the line with smaller sum and with direction as Horiz, is the l1Horizontal line.
  similarly in case of vertical lines
  0+3 < 1+4
  this indicates that 0-3 is the l1Vertical line
  1+4 is the l2Vertical line

  we have a method known as getSumOfPoints() in the Line class which will return the sum of the locations of the two points of the line.
  
  Here is the code to implement this logic:
   */

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
  }
}
