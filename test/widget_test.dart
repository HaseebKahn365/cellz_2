// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.
/*
Here we are gonna test the buisiness logic for our game. this game has a similar flavor as the android unlock pattern. 
The difference is that we are gonna draw lines between the dots. and when four lines together form a square, the player gets score.

In the test directory  we are gonna implement all the buisiness logic and then we are gonna test it.

 */

//Now that we have implemented all the buisiness logic. it is time to test out the functions

import 'package:flutter_test/flutter_test.dart';

import 'Buisiness_Logic/game_canvas.dart';
import 'Buisiness_Logic/lines.dart';
import 'Buisiness_Logic/point.dart';
import 'Buisiness_Logic/square.dart';

void main() {
  //create a test group to test out the points

  group('Test the point object:', () {
    test('Testing timesUsed init: 0', () {
      //Testing out the Point object.
      //Lets create a point and test out its time used.
      Point point = Point(xCord: 0, yCord: 0, location: 0);
      expect(point.timesUsed, 0);
    });

    //Testing out the increment function
    test('Testing increment usage function', () {
      Point point = Point(xCord: 0, yCord: 0, location: 0);
      point.incrementPointUsage();
      expect(point.timesUsed, 1);
    });

    //Testing out the disability but lets first increment the usage
    test('Testing out the disability function', () {
      Point point = Point(xCord: 0, yCord: 0, location: 0);
      point.incrementPointUsage();
      point.incrementPointUsage();
      expect(point.checkDisability(), false);
      point.incrementPointUsage();
      point.incrementPointUsage();
      expect(point.checkDisability(), true);
    });

    //Testing out the toString function
    test('Testing out the toString function', () {
      Point point = Point(xCord: 0, yCord: 0, location: 0);
      expect(point.toString(), 'Point at (0, 0) isDisabled: false, timesUsed: 0, location: 0');
    });

    //Testing out the equality operator
    test('Testing out the equality operator', () {
      Point point = Point(xCord: 0, yCord: 0, location: 0);
      Point point2 = Point(xCord: 0, yCord: 0, location: 12);
      expect(point == point2, true);
    });
  });

  //Test group to test out the Line object
  group('Test the Line object:', () {
    test('Testing the Line object - Points locations', () {
      //Testing out the Line object
      //Lets create a line object and test out its properties
      Point point1 = Point(xCord: 0, yCord: 0, location: 0);
      Point point2 = Point(xCord: 1, yCord: 0, location: 1);
      Line line = Line(firstPoint: point1, secondPoint: point2, isMine: true);

      //making sure that the locations oof the points are proper
      expect(line.firstPoint.location, 0);
      expect(line.secondPoint.location, 1);
    });

    test('Testing the Line object - Line direction', () {
      //Testing out the Line object
      //Lets create a line object and test out its properties
      Point point1 = Point(xCord: 0, yCord: 0, location: 0);
      Point point2 = Point(xCord: 1, yCord: 0, location: 1);

      Line line = Line(firstPoint: point1, secondPoint: point2, isMine: true);

      expect(line.direction == LineDirection.horiz, true);
    });

    //testing the vertical direction

    //Testing out the toString function
    test('Testing out the toString function', () {
      Point point1 = Point(xCord: 0, yCord: 0, location: 0);
      Point point2 = Point(xCord: 1, yCord: 0, location: 1);
      Point point4 = Point(xCord: 0, yCord: 1, location: 3);
      Line line = Line(firstPoint: point1, secondPoint: point2, isMine: true);
      Line line2 = Line(firstPoint: point1, secondPoint: point4, isMine: true);
      expect(line.toString(), '0-1');
      expect(line2.toString(), '0-3');
    });

    Point point1 = Point(xCord: 0, yCord: 0, location: 0);
    Point point2 = Point(xCord: 1, yCord: 0, location: 1);
    //Testing out the equality operator
    test('Testing out the equality operator', () {
      Point point3 = Point(xCord: 0, yCord: 0, location: 2);
      Point point4 = Point(xCord: 1, yCord: 0, location: 3);
      Line line1 = Line(firstPoint: point1, secondPoint: point2, isMine: true);
      Line line2 = Line(firstPoint: point3, secondPoint: point4, isMine: true);
      expect(line1 == line2, true);

      point4 = Point(xCord: 0, yCord: 1, location: 1);
      line2 = Line(firstPoint: point3, secondPoint: point4, isMine: true);
      expect(line1 == line2, false);
    });

    //Testinng the sum of the points
    test('Testing the sum of the points', () {
      Line line = Line(firstPoint: point1, secondPoint: point2, isMine: true);
      expect(line.getSumOfPoints(), 1); //0+1
    });

    //Testing the isLineDrawn function
    //create two horizontal lines with two similar points but different order add them to map and see if they can get added
    test('Testing the isLineDrawn function', () {
      Line line = Line(firstPoint: point1, secondPoint: point2, isMine: true);
      expect(line.isAlreadyLineDrawn(), false);
      line.addLineToMap();
      Line line2 = Line(firstPoint: point2, secondPoint: point1, isMine: true);
      expect(line2.isAlreadyLineDrawn(), true);
      line2.addLineToMap();
      expect(line2.isAlreadyLineDrawn(), true);
      print(linesDrawn);
      Point point3 = Point(xCord: 1, yCord: 1, location: 2);
      line = Line(firstPoint: point2, secondPoint: point3, isMine: true);
      //find direction then test storage store
      expect(line.direction, LineDirection.vert);
      expect(line.isAlreadyLineDrawn(), false);
      line.addLineToMap();
      expect(line.isAlreadyLineDrawn(), true);
      print(linesDrawn);
    });
  });

//Test group to test out the Square Object
  group('Test the Square object:', () {
    test('Testing the Square object - with properly passed lines as args', () {
      //Testing out the Square object
      //Lets create a square object and test out its properties
      Point point1 = Point(xCord: 0, yCord: 0, location: 0);
      Point point2 = Point(xCord: 1, yCord: 0, location: 1);
      Point point3 = Point(xCord: 0, yCord: 1, location: 3);
      Point point4 = Point(xCord: 1, yCord: 1, location: 4);

      Line leftVert = Line(firstPoint: point1, secondPoint: point3, isMine: true);
      //expect direction to be vertical
      expect(leftVert.direction, LineDirection.vert);
      //get sum of points for the line
      expect(leftVert.getSumOfPoints(), 3);
      Line rightVert = Line(firstPoint: point2, secondPoint: point4, isMine: true);
      //expect direction to be vertical
      expect(rightVert.direction, LineDirection.vert);
      //get sum of points for the line
      expect(rightVert.getSumOfPoints(), 5);
      Line topHoriz = Line(firstPoint: point1, secondPoint: point2, isMine: true);
      //expect direction to be horizontal
      expect(topHoriz.direction, LineDirection.horiz);
      //get sum of points for the line
      expect(topHoriz.getSumOfPoints(), 1);
      Line bottomHoriz = Line(firstPoint: point3, secondPoint: point4, isMine: true);
      //expect direction to be horizontal
      expect(bottomHoriz.direction, LineDirection.horiz);
      //get sum of points for the line
      expect(bottomHoriz.getSumOfPoints(), 7);

      Square square = Square(topHoriz: topHoriz, bottomHoriz: bottomHoriz, rightVert: rightVert, leftVert: leftVert, isMine: true);

      //expect the xCord and yCord to be 0
      expect(square.xCord, 0);
      expect(square.yCord, 0);
      print(square);
    });

    Point point1 = Point(xCord: 0, yCord: 0, location: 0);
    Point point2 = Point(xCord: 1, yCord: 0, location: 1);
    Point point3 = Point(xCord: 0, yCord: 1, location: 3);
    Point point4 = Point(xCord: 1, yCord: 1, location: 4);
    Line leftVert = Line(firstPoint: point1, secondPoint: point3, isMine: true);
    Line rightVert = Line(firstPoint: point2, secondPoint: point4, isMine: true);
    Line topHoriz = Line(firstPoint: point1, secondPoint: point2, isMine: true);
    Line bottomHoriz = Line(firstPoint: point3, secondPoint: point4, isMine: true);
    Square square = Square(topHoriz: bottomHoriz, bottomHoriz: topHoriz, rightVert: rightVert, leftVert: leftVert, isMine: true);

    test('Testing the Square object - with improperly passed lines as args', () {
      //Testing out the Square object
      //Lets create a square object and test out its properties

      //expect direction to be vertical
      expect(leftVert.direction, LineDirection.vert);
      //get sum of points for the line
      expect(leftVert.getSumOfPoints(), 3);

      //expect direction to be vertical
      expect(rightVert.direction, LineDirection.vert);
      //get sum of points for the line
      expect(rightVert.getSumOfPoints(), 5);

      //expect direction to be horizontal
      expect(topHoriz.direction, LineDirection.horiz);
      //get sum of points for the line
      expect(topHoriz.getSumOfPoints(), 1);

      //expect direction to be horizontal
      expect(bottomHoriz.direction, LineDirection.horiz);
      //get sum of points for the line
      expect(bottomHoriz.getSumOfPoints(), 7);

      //expect the xCord and yCord to be 0
      expect(square.xCord, 0);
      expect(square.yCord, 0);

      print(square);
    });

    //test case for new lines with different order of points . ie changing the direction of horizontal from right to left, to , left to right
    late Square square2;

    test('Testing the Square object - with different order of points', () {
      //Testing out the Square object
      //Lets create a square object and test out its properties
      topHoriz = Line(firstPoint: point2, secondPoint: point1, isMine: true);
      bottomHoriz = Line(firstPoint: point4, secondPoint: point3, isMine: true);
      leftVert = Line(firstPoint: point3, secondPoint: point1, isMine: true);
      rightVert = Line(firstPoint: point4, secondPoint: point2, isMine: true);

      square2 = Square(topHoriz: topHoriz, bottomHoriz: bottomHoriz, rightVert: rightVert, leftVert: leftVert, isMine: true);
      //test origin to be 0,0
      expect(square.xCord, 0);
      expect(square.yCord, 0);
      print(square2);
    });

    //test for comparing the squares
    test('Testing the equality operator', () {
      expect(square == square2, true);
    });
  });

  //create a test group for advanced square offset checking

  group('Test the Square object - with advanced offset:', () {
    test('Testing the Squares object - with properly passed arg 9 points and 4 squares', () {
      //Testing out the Square object
      //Lets create a square object and test out its properties
      //testing for square offset at a different location.
      /*
    This will be a very complex test. we will first create 9 dots in the form of 3x3 pattern similar to the android unlock pattern
    Here is the naming convention that we will use for all the 4 squares that can be formed by joining the dots:

    The four sub-squares that form inside the 9 dots are named as top-left aka TL,top-right aka TR,  bottom-right aka BR, bottom-left aka BL.
     These squares are form from four lines ie. topHoriz, bottomHoriz, rightVert, leftVert.
     */

      //lets create the points
      Point point1 = Point(xCord: 0, yCord: 0, location: 0);
      Point point2 = Point(xCord: 1, yCord: 0, location: 1);
      Point point3 = Point(xCord: 2, yCord: 0, location: 2);
      Point point4 = Point(xCord: 0, yCord: 1, location: 3);
      Point point5 = Point(xCord: 1, yCord: 1, location: 4);
      Point point6 = Point(xCord: 2, yCord: 1, location: 5);
      Point point7 = Point(xCord: 0, yCord: 2, location: 6);
      Point point8 = Point(xCord: 1, yCord: 2, location: 7);
      Point point9 = Point(xCord: 2, yCord: 2, location: 8);

      /*
        Altogether the naming for the lines should be as follows: 
    •	for the top line in the Top right square the line name is TTR 
    •	for the left line in the Top right square the line name is LTR 
    •	for the bottom line in the Top right square the line name is BTR 
    •	for the right line in the Top right square the line name is RTR 
    
    •	for the top line in the Top left square the line name is TTL 
    •	for the left line in the Top left square the line name is LTL 
    •	for the bottom line in the Top left square the line name is BTL 
    •	for the right line in the Top left square the line name is RTL 
    
    •	for the top line in the Bottom right square the line name is TBR 
    •	for the left line in the Bottom right square the line name is LBR 
    •	for the bottom line in the Bottom right square the line name is BBR 
    •	for the right line in the Bottom right square the line name is RBR 
    
    •	for the top line in the Bottom left square the line name is TBL 
    •	for the left line in the Bottom left square the line name is LBL 
    •	for the bottom line in the Bottom left square the line name is BBL 
    •	for the right line in the Bottom left square the line name is RBL 

     */

      //lets create lines now for the first square ie. TL aka top left
      Line TTL = Line(firstPoint: point1, secondPoint: point2, isMine: true); //topHoriz
      Line LTL = Line(firstPoint: point1, secondPoint: point4, isMine: true); //leftVert
      Line BTL = Line(firstPoint: point4, secondPoint: point5, isMine: true); //bottomHoriz
      Line RTL = Line(firstPoint: point2, secondPoint: point5, isMine: true); //rightVert
      //lets create the square now and test its offset to be 0,0
      Square squareTL = Square(topHoriz: TTL, bottomHoriz: BTL, rightVert: RTL, leftVert: LTL, isMine: true);
      print('Square TL created with offset $squareTL');
      expect(squareTL.xCord, 0);
      expect(squareTL.yCord, 0);

      //lets create lines now for the second square ie. TR aka top right
      Line TTR = Line(firstPoint: point2, secondPoint: point3, isMine: true); //topHoriz
      Line LTR = Line(firstPoint: point2, secondPoint: point5, isMine: true); //leftVert
      Line BTR = Line(firstPoint: point5, secondPoint: point6, isMine: true); //bottomHoriz
      Line RTR = Line(firstPoint: point3, secondPoint: point6, isMine: true); //rightVert
      //lets create the square now and test its offset to be 1,0
      Square squareTR = Square(topHoriz: TTR, bottomHoriz: BTR, rightVert: RTR, leftVert: LTR, isMine: true);
      print('Square TR created with offset $squareTR');
      expect(squareTR.xCord, 1);
      expect(squareTR.yCord, 0);

      //lets create lines now for the third square ie. BR aka bottom right
      Line TBR = Line(firstPoint: point5, secondPoint: point6, isMine: true); //topHoriz
      Line RBR = Line(firstPoint: point5, secondPoint: point8, isMine: true); //leftVert
      Line BBR = Line(firstPoint: point8, secondPoint: point9, isMine: true); //bottomHoriz
      Line LBR = Line(firstPoint: point6, secondPoint: point9, isMine: true); //rightVert
      //lets create the square now and test its offset to be 1,1
      Square squareBR = Square(topHoriz: TBR, bottomHoriz: BBR, rightVert: LBR, leftVert: RBR, isMine: true);
      print('Square BR created with offset $squareBR');
      expect(squareBR.xCord, 1);
      expect(squareBR.yCord, 1);

      //lets create lines now for the fourth square ie. BL aka bottom left
      Line TBL = Line(firstPoint: point4, secondPoint: point5, isMine: true); //topHoriz
      Line LBL = Line(firstPoint: point4, secondPoint: point7, isMine: true); //leftVert
      Line BBL = Line(firstPoint: point7, secondPoint: point8, isMine: true); //bottomHoriz
      Line RBL = Line(firstPoint: point5, secondPoint: point8, isMine: true); //rightVert
      //lets create the square now and test its offset to be 0,1
      Square squareBL = Square(topHoriz: TBL, bottomHoriz: BBL, rightVert: RBL, leftVert: LBL, isMine: true);
      print('Square BL created with offset $squareBL');
      expect(squareBL.xCord, 0);
      expect(squareBL.yCord, 1);
    });

    //Similar test but this time the order of the points is changed indicating a different direction in which same lines are being drawn

    test('Testing the Squares object - with different ordered-passed Points args. points 9 points and 4 squares', () {
      //Testing out the Square object
      //Lets create a square object and test out its properties
      //testing for square offset at a different location.
      print('Testing the Squares object - with different ordered-passed Points args. points 9 points and 4 squares\n');

      //lets create the points
      Point point1 = Point(xCord: 0, yCord: 0, location: 0);
      Point point2 = Point(xCord: 1, yCord: 0, location: 1);
      Point point3 = Point(xCord: 2, yCord: 0, location: 2);
      Point point4 = Point(xCord: 0, yCord: 1, location: 3);
      Point point5 = Point(xCord: 1, yCord: 1, location: 4);
      Point point6 = Point(xCord: 2, yCord: 1, location: 5);
      Point point7 = Point(xCord: 0, yCord: 2, location: 6);
      Point point8 = Point(xCord: 1, yCord: 2, location: 7);
      Point point9 = Point(xCord: 2, yCord: 2, location: 8);

      //lets create lines now for the first square ie. TL aka top left
      Line TTL = Line(firstPoint: point2, secondPoint: point1, isMine: true); //topHoriz
      Line LTL = Line(firstPoint: point1, secondPoint: point4, isMine: true); //leftVert
      Line BTL = Line(firstPoint: point5, secondPoint: point4, isMine: true); //bottomHoriz
      Line RTL = Line(firstPoint: point5, secondPoint: point2, isMine: true); //rightVert

      //lets create the square now and test its offset to be 0,0
      Square squareTL = Square(topHoriz: TTL, bottomHoriz: BTL, rightVert: RTL, leftVert: LTL, isMine: true);
      print('Square TL created with offset $squareTL');
      expect(squareTL.xCord, 0);
      expect(squareTL.yCord, 0);

      //lets create lines now for the second square ie. TR aka top right
      Line TTR = Line(firstPoint: point3, secondPoint: point2, isMine: true); //topHoriz
      Line LTR = Line(firstPoint: point2, secondPoint: point5, isMine: true); //leftVert
      Line BTR = Line(firstPoint: point6, secondPoint: point5, isMine: true); //bottomHoriz
      Line RTR = Line(firstPoint: point6, secondPoint: point3, isMine: true); //rightVert

      //lets create the square now and test its offset to be 1,0
      Square squareTR = Square(topHoriz: TTR, bottomHoriz: BTR, rightVert: RTR, leftVert: LTR, isMine: true);
      print('Square TR created with offset $squareTR');
      expect(squareTR.xCord, 1);
      expect(squareTR.yCord, 0);

      //lets create lines now for the third square ie. BR aka bottom right
      Line TBR = Line(firstPoint: point6, secondPoint: point5, isMine: true); //topHoriz
      Line RBR = Line(firstPoint: point5, secondPoint: point8, isMine: true); //leftVert
      Line BBR = Line(firstPoint: point9, secondPoint: point8, isMine: true); //bottomHoriz
      Line LBR = Line(firstPoint: point9, secondPoint: point6, isMine: true); //rightVert

      //lets create the square now and test its offset to be 1,1
      Square squareBR = Square(topHoriz: TBR, bottomHoriz: BBR, rightVert: LBR, leftVert: RBR, isMine: true);
      print('Square BR created with offset $squareBR');
      expect(squareBR.xCord, 1);
      expect(squareBR.yCord, 1);

      //lets create lines now for the fourth square ie. BL aka bottom left
      Line TBL = Line(firstPoint: point5, secondPoint: point4, isMine: true); //topHoriz
      Line LBL = Line(firstPoint: point4, secondPoint: point7, isMine: true); //leftVert
      Line BBL = Line(firstPoint: point8, secondPoint: point7, isMine: true); //bottomHoriz
      Line RBL = Line(firstPoint: point8, secondPoint: point5, isMine: true); //rightVert

      //lets create the square now and test its offset to be 0,1
      Square squareBL = Square(topHoriz: TBL, bottomHoriz: BBL, rightVert: RBL, leftVert: LBL, isMine: true);
      print('Square BL created with offset $squareBL');
      expect(squareBL.xCord, 0);
      expect(squareBL.yCord, 1);
    });
  });

  //Testing out the GameCanvas object
  GameCanvas gameCanvas = GameCanvas(
    xPoints: 3,
    yPoints: 3,
  );

  //lets create the points
  Point point1 = Point(xCord: 0, yCord: 0, location: 0);
  Point point2 = Point(xCord: 1, yCord: 0, location: 1);
  Point point3 = Point(xCord: 2, yCord: 0, location: 2);
  Point point4 = Point(xCord: 0, yCord: 1, location: 3);
  Point point5 = Point(xCord: 1, yCord: 1, location: 4);
  Point point6 = Point(xCord: 2, yCord: 1, location: 5);
  Point point7 = Point(xCord: 0, yCord: 2, location: 6);
  Point point8 = Point(xCord: 1, yCord: 2, location: 7);
  Point point9 = Point(xCord: 2, yCord: 2, location: 8);

  group('Test the GameCanvas object:', () {
    test('Testing the GameCanvas object - with properly passed arg 9 points and 4 squares', () {
      //Testing out the GameCanvas object
      //Lets create a GameCanvas object and test out its properties
      //testing for square offset at a different location.
      print('Testing the GameCanvas object - with properly passed arg 9 points and 4 squares\n');

      //lets create a 3x3 grid using the GameCanvas

      //Lets explore the Created points Map and compare each object with the above points and see if they match
      // allPoints.forEach((key, value) {
      //   print('$key : ');
      //   print('$value\n');
      // });
      expect(allPoints[0], point1);
      expect(allPoints[1], point2);
      expect(allPoints[2], point3);
      expect(allPoints[3], point4);
      expect(allPoints[4], point5);
      expect(allPoints[5], point6);
      expect(allPoints[6], point7);
      expect(allPoints[7], point8);
      expect(allPoints[8], point9);
    });

    //Test for the remaining moves left.
    //for a 3x3 grid the moves left should be 12 as calculated by: ((xPoints - 1) * yPoints) + ((yPoints - 1) * xPoints);

    test('Testing the GameCanvas object - 3x3 for movesLeft', () {
      //Testing out the GameCanvas object
      //Lets create a GameCanvas object and test out its properties
      //testing for square offset at a different location.
      print('Testing the GameCanvas object - 3x3 for movesLeft\n');

      expect(gameCanvas.movesLeft, 12);

      //decrement the moves left and check if it is decremented
      gameCanvas.decrementMovesLeft();

      expect(gameCanvas.movesLeft, 11);

      List<Point> tempList = [point1, point2, point3, point4, point5, point6, point7, point8, point9];

      //testing to see if all the points are present in the allPoints map
      expect(allPoints.values.toList(), tempList);
      allPoints.forEach((key, value) {
        if (tempList.contains(value)) {
          tempList.remove(value);
        }
      });
      expect(tempList.length, 0);

      //Test for 3x2 grid
      gameCanvas = GameCanvas(
        xPoints: 3,
        yPoints: 2,
      );

      //Test for the remaining moves left.
      //for a 3x2 grid the moves left should be 7 as calculated by: ((xPoints - 1) * yPoints) + ((yPoints - 1) * xPoints);
      expect(gameCanvas.movesLeft, 7);
      //printing the allPoints map
      allPoints.forEach((key, value) {
        print('$key : ');
        print('$value\n');
      });

      //creating all possible 7 lines using a method defined in the game canvas
      //we will first create all the horizontal lines first from the points that are already in the map of points
      //then we will create all the vertical lines from the points that are already in the map of points

      Map<String, Line> allPossibleLines = gameCanvas.drawAllPossibleLines();
      //printing the allPossibleLines map
      allPossibleLines.forEach((key, value) {
        print('$key : ');
        print('$value\n');
      });
      //make sure that its length is 7 and contains the following lines:
      /*
      0-1 : 
      0-1

      1-2 : 
      1-2

      3-4 : 
      3-4

      4-5 : 
      4-5

      0-3 : 
      0-3

      1-4 : 
      1-4

      2-5 : 
      2-5
       */

      expect(allPossibleLines.length, 7);
      expect(allPossibleLines['0-1']!.firstPoint, Line(firstPoint: point1, secondPoint: point2, isMine: true).firstPoint); //first horizontal line
      expect(allPossibleLines['1-2']!.firstPoint, Line(firstPoint: point2, secondPoint: point3, isMine: true).firstPoint); //second horizontal line
      expect(allPossibleLines['3-4']!.firstPoint, Line(firstPoint: point4, secondPoint: point5, isMine: true).firstPoint); //third horizontal line
      expect(allPossibleLines['4-5']!.firstPoint, Line(firstPoint: point5, secondPoint: point6, isMine: true).firstPoint); //fourth horizontal line

      expect(allPossibleLines['0-3']!.firstPoint, Line(firstPoint: point1, secondPoint: point4, isMine: true).firstPoint); //first vertical line
      expect(allPossibleLines['1-4']!.firstPoint, Line(firstPoint: point2, secondPoint: point5, isMine: true).firstPoint); //second vertical line
      expect(allPossibleLines['2-5']!.firstPoint, Line(firstPoint: point3, secondPoint: point6, isMine: true).firstPoint); //third vertical line
    });
  });
}
