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

import 'dart:developer';

import 'package:flutter_test/flutter_test.dart';

import 'Buisiness_Logic/lines.dart';
import 'Buisiness_Logic/point.dart';

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

    //Testing out the equality operator
    test('Testing out the equality operator', () {
      Point point1 = Point(xCord: 0, yCord: 0, location: 0);
      Point point2 = Point(xCord: 0, yCord: 0, location: 1);
      Point point3 = Point(xCord: 0, yCord: 0, location: 2);
      Point point4 = Point(xCord: 0, yCord: 0, location: 3);
      // Line line = Line(point1, point2, point3, point4);
      // Line line2 = Line(point1, point2, point3, point4);
      // expect(line == line2, true);
    });
  });
}
