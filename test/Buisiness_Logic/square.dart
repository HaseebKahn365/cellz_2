import 'lines.dart';
import 'point.dart';

class Square {
  late Line topHoriz; //TOP HORIZONTAL LINE
  late Line bottomHoriz; //BOTTOM HORIZONTAL LINE
  late Line rightVert; //RIGHT VERTICAL LINE
  late Line leftVert; //LEFT VERTICAL LINE
  int xCord = 0;
  int yCord = 0; //these cordinates indicate the offset for the ui to show where to render the square
  bool isMine;

/*
    We know that the sum of 0+1 of topHoriz is less than the sum of 3+4 of bottom horiz. this means that the line with smaller sum and with direction as Horiz, is the topHoriz line.
  similarly in case of vertical lines
  0+3 < 1+4
  this indicates that 0-3 is the left vertical line
  1+4 is the right line

  */

  Square({required this.topHoriz, required this.bottomHoriz, required this.rightVert, required this.leftVert, required this.isMine}) {
    if (topHoriz.getSumOfPoints() > bottomHoriz.getSumOfPoints()) {
      Line temp = topHoriz;
      topHoriz = bottomHoriz;
      bottomHoriz = temp;
    }
    if (leftVert.getSumOfPoints() > rightVert.getSumOfPoints()) {
      Line temp = leftVert;
      leftVert = rightVert;
      rightVert = temp;
    }
    setSquareCordinates();
  }

  //now the coordinates of the point with least location will be the xCord and yCord of the square
  void setSquareCordinates() {
    //in the top horizontal line find the point with smaller location value and set its cordinates as the cordinates for the square
    if (topHoriz.firstPoint.location < topHoriz.secondPoint.location) {
      print('no need to adjust the direction of the line');
      xCord = topHoriz.firstPoint.xCord;
      yCord = topHoriz.firstPoint.yCord;
    } else {
      print('adjusting with the direction of the line');
      xCord = topHoriz.secondPoint.xCord;
      yCord = topHoriz.secondPoint.yCord;
    }
  }

  @override
  String toString() {
    return '''Square at ($xCord, $yCord) and lines {
    topHoriz: $topHoriz,
    bottomHoriz: $bottomHoriz,
    rightVert: $rightVert,
    leftVert: $leftVert
    }''';
  }

  //lets override the == operator to compare two squares
  @override
  bool operator ==(Object other) {
    if (other is Square) {
      return topHoriz == other.topHoriz && bottomHoriz == other.bottomHoriz && rightVert == other.rightVert && leftVert == other.leftVert;
    }
    return false;
  }
}

void main() {
  Point point1 = Point(xCord: 0, yCord: 0, location: 0);
  Point point2 = Point(xCord: 1, yCord: 0, location: 1);
  Point point3 = Point(xCord: 2, yCord: 0, location: 2);
  Point point4 = Point(xCord: 0, yCord: 1, location: 3);
  Point point5 = Point(xCord: 1, yCord: 1, location: 4);
  Point point6 = Point(xCord: 2, yCord: 1, location: 5);
  Point point7 = Point(xCord: 0, yCord: 2, location: 6);
  Point point8 = Point(xCord: 1, yCord: 2, location: 7);
  Point point9 = Point(xCord: 2, yCord: 2, location: 8);

  Line TTL = Line(firstPoint: point1, secondPoint: point2, isMine: true); //topHoriz
  Line LTL = Line(firstPoint: point1, secondPoint: point4, isMine: true); //leftVert
  Line BTL = Line(firstPoint: point4, secondPoint: point5, isMine: true); //bottomHoriz
  Line RTL = Line(firstPoint: point2, secondPoint: point5, isMine: true); //rightVert
  //lets create the square now and test its offset to be 0,0
  Square squareTL = Square(topHoriz: TTL, bottomHoriz: BTL, rightVert: RTL, leftVert: LTL, isMine: true);
  print('Square TL created with offset $squareTL');

  //lets create lines now for the second square ie. TR aka top right
  Line TTR = Line(firstPoint: point2, secondPoint: point3, isMine: true); //topHoriz
  Line LTR = Line(firstPoint: point2, secondPoint: point5, isMine: true); //leftVert
  Line BTR = Line(firstPoint: point5, secondPoint: point6, isMine: true); //bottomHoriz
  Line RTR = Line(firstPoint: point3, secondPoint: point6, isMine: true); //rightVert
  //lets create the square now and test its offset to be 1,0
  Square squareTR = Square(topHoriz: TTR, bottomHoriz: BTR, rightVert: RTR, leftVert: LTR, isMine: true);
  print('Square TR created with offset $squareTR');
}
