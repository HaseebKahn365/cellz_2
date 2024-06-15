import 'dart:async';

import 'package:cellz/business_logic/game_canvas.dart';
import 'package:cellz/business_logic/game_state.dart';
import 'package:cellz/game_components/gui_dot.dart';
import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';

class MyGame extends FlameGame {
  final int xP, yP;
  Vector2 appropriateOffset = Vector2(0, 0);

  late final GameCanvas level1Canvas;

  MyGame({required this.xP, required this.yP, required this.appropriateOffset})
      : super(
          camera: CameraComponent.withFixedResolution(width: 600, height: 1000),
        ) {
    debugMode = true;
    level1Canvas = GameCanvas(xPoints: xP, yPoints: yP);
    level1Canvas.createPoints();
  }

  @override
  Color backgroundColor() {
    return Colors.black;
  }

  @override
  FutureOr<void> onLoad() async {
    camera.viewfinder.anchor = Anchor.topLeft;
    // Adding all the dots to the game using the list of allPoints
    GameState.allPoints.forEach((key, value) {
      world.add(Dot(value));
      world.debugColor = Colors.white;
    });
  }

  // @override
  // void onLongTapDown(TapDownEvent event) {
  //   final tapPosition = event.localPosition;
  //   camera.viewfinder.position = tapPosition - appropriateOffset;
  //   updateZoomAmount(); // Increase the zoom level by 20%
  //   super.onLongTapDown(event);
  // }

  // double zoomAmount = 1;
  //add a smooth zoom in effect
  // Assuming this method is called repeatedly over time
  // void updateZoomAmount() async {
  //   const double maxZoom = 2.2; // Target zoom level
  //   const double rateOfChange = 1.2 / 120; // How much to zoom each step
  //   const int delayMilliseconds = 5; // Delay between updates to simulate smooth zooming

  //   // Use a timer to gradually increase zoomAmount
  //   while (zoomAmount < maxZoom) {
  //     await Future.delayed(const Duration(milliseconds: delayMilliseconds), () {
  //       zoomAmount += rateOfChange;

  //       camera.viewfinder.zoom = zoomAmount;
  //     });
  //   }
  // }

  // @override
  // void onScaleUpdate(ScaleUpdateInfo info) {
  //   camera.viewfinder.zoom = 1;
  //   zoomAmount = 1;
  //   print('Zoom: ${info.scale.global}');
  //   super.onScaleUpdate(info);
  // }

  // Call updateZoomAmount() from your game loop or an event handler to smoothly increase the zoom
}
