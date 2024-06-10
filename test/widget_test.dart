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
    test('Testing the Square object - with different order of points', () {
      //Testing out the Square object
      //Lets create a square object and test out its properties
      topHoriz = Line(firstPoint: point2, secondPoint: point1, isMine: true);
      bottomHoriz = Line(firstPoint: point4, secondPoint: point3, isMine: true);
      leftVert = Line(firstPoint: point3, secondPoint: point1, isMine: true);
      rightVert = Line(firstPoint: point4, secondPoint: point2, isMine: true);

      square = Square(topHoriz: topHoriz, bottomHoriz: bottomHoriz, rightVert: rightVert, leftVert: leftVert, isMine: true);
      //test origin to be 0,0
      expect(square.xCord, 0);
      expect(square.yCord, 0);
      print(square);
    });
  });
}
