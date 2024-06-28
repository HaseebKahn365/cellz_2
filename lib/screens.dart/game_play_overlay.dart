// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:cellz/business_logic/game_state.dart';
import 'package:flutter/material.dart';

//creating an instance of the class

class GamePlayScreen extends StatefulWidget {
  GamePlayScreen({Key? key}) : super(key: key) {}

  @override
  State<GamePlayScreen> createState() => _GamePlayScreenState();
}

class _GamePlayScreenState extends State<GamePlayScreen> {
  //lets override the back button to make sure that user doesn't leave the game accidently

  bool isLineCreated = false;
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return (await showDialog(
              context: context,
              builder: (context) => AlertDialog(
                title: Text('Are you sure?'),
                content: Text('Do you want to exit the game and lose?'),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(false),
                    child: Text('No'),
                  ),
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(true),
                    child: Text('Yes'),
                  ),
                ],
              ),
            )) ??
            false;
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text('Level: 1'),
          //in the actions we will display the moves left
          actions: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Row(
                children: [
                  Text('Moves Left :  '),
                  Text(
                    '12',
                    style: TextStyle(fontSize: 21),
                  ),
                ],
              ),
            ),
          ],
        ),
        body: Center(
          child: Column(
            children: [
              PlayersBox(),
              //creating a container with rounded borders that will contain the stack
            ],
          ),
        ),
      ),
    );
  }
}

class PlayersBox extends StatefulWidget {
  const PlayersBox({
    super.key,
  });

  @override
  State<PlayersBox> createState() => _PlayersBoxState();
}

class _PlayersBoxState extends State<PlayersBox> {
//creating the state variables for the scores of the players

  @override
  Widget build(BuildContext context) {
    return PlayersDetail();
  }
}

class PlayersDetail extends StatelessWidget {
  const PlayersDetail({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        //container for User

        Container(
          height: 85,
          width: 170,
          decoration: BoxDecoration(
            //if the state variable isMyTurn is true then display the inversePrimary color otherwise display the onSurfaceVariant color
            color: GameState.myTurn ? Theme.of(context).colorScheme.inversePrimary.withOpacity(0.2) : Theme.of(context).colorScheme.onSurfaceVariant.withOpacity(0.05),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      //display only 9 characters of the name otherwise use overflowellipsis
                      'Haseeb',
                      style: TextStyle(
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Text(
                          'Score:',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w300,
                          ),
                        ),
                        Text(
                          '12',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w300,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12.0),
                child: Stack(
                  children: [
                    CircleAvatar(
                      radius: 30,
                      //display current user profile image which is stored in imageFile variable if imageFIle is null then display the default profile image
                      // backgroundImage:Image.asset('assets/images/5.jpg') :
                      //bg should be 5.jpg from assets
                      backgroundImage: Image.asset('assets/images/5.jpg').image,
                    ),

                    //circular progress indicator
                    SizedBox(
                      width: 60,
                      height: 60,
                      //return the progressDemo only if it is the current user's turn otherwise return an empty container
                      child: GameState.myTurn ? CircularProgressDemo() : Container(),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),

        const SizedBox(width: 10),

        //container for player 2

        Container(
          height: 85,
          width: 170,
          decoration: BoxDecoration(
            color: GameState.myTurn ? Theme.of(context).colorScheme.onSurfaceVariant.withOpacity(0.05) : Theme.of(context).colorScheme.inversePrimary.withOpacity(0.2),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15.0),
                child: Stack(
                  children: [
                    CircleAvatar(
                      radius: 30,
                      backgroundImage: NetworkImage('https://media.istockphoto.com/photos/beautiful-profile-picture-id182773387?k=6&m=182773387&s=612x612&w=0&h=kXCC5JaOAdOUE5iyd9F2YocAk2O3OEmj6scZs2-QtEk='),
                    ),

                    //circular progress indicator
                    //return the progressDemo only if it is the other user's turn otherwise return an empty container
                    SizedBox(
                      width: 60,
                      height: 60,
                      child: GameState.myTurn ? Container() : CircularProgressDemo(),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      //display only 13 characters of the name otherwise use overflowellipsis
                      'AI',
                      style: TextStyle(
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Text(
                          'Score:',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w300,
                          ),
                        ),
                        Text(
                          '12',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w300,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class CircularProgressDemo extends StatefulWidget {
  @override
  _CircularProgressDemoState createState() => _CircularProgressDemoState();
}

class _CircularProgressDemoState extends State<CircularProgressDemo> with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 20), // Set the duration to 20 seconds
    );

    _animation = Tween<double>(begin: 0, end: 1).animate(_controller);

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return CircularProgressIndicator(
          value: _animation.value,
          strokeWidth: 4.0,
          backgroundColor: Colors.white,
          valueColor: AlwaysStoppedAnimation<Color>(
            Theme.of(context).colorScheme.onSecondaryContainer,
          ),
        );
      },
    );
  }
}
