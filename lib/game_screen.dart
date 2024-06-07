import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';

class GameScreen extends StatelessWidget {
  const GameScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GameWidget(
      game: MyGame(),
    );
  }
}

class MyGame extends FlameGame {
  @override
  Color backgroundColor() {
    // TODO: implement backgroundColor
    return Colors.blueAccent.withOpacity(0.3);
  }

  @override
  Future<void> onLoad() async {
    world.add(Player());
  }
}

class Player extends PositionComponent with HasGameRef<MyGame>, DragCallbacks {
 
 Offset? dragStart;
 Offset? dragUpdate;
  Offset? dragEnd;
 
  @override
  FutureOr<void> onLoad() {
    return super.onLoad();
  }

  @override
  void update(double dt) {
    super.update(dt);
  }

  /*
  
  When i start dragging the player, the position of the player stays  the same but a line in the direction of the drag is drawn.
  The straight line originates from the center of the player and extends to the point where the drag is released.
  during the motion the line should be rendered on the screen.
   */

  @override
  void onDragStart(DragStartEvent event) {
    drag
    super.onDragStart(event);
  }




  @override
  void render(Canvas canvas) {
    super.render(canvas);

    // drawing the player
    canvas.drawCircle(position.toOffset(), 15, Paint()..color = Color.fromARGB(255, 193, 201, 236));
  }
}


