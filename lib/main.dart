// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:cellz/level_screens/level1.dart';
import 'package:cellz/screens.dart/level_parralax_widget.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: ListView(
      children: [
        //navigate to gameScreen on elevated button
        ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => Level1()),
            );
          },
          child: Text('Play Game'),
        ),
        const SizedBox(height: 300),
        Container(
          height: MediaQuery.of(context).size.height / 4,
          child: Card(
            elevation: 20,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: ParralaxCard(),
            ),
          ),
        ),
        Container(
          height: MediaQuery.of(context).size.height / 4,
          child: Card(
            elevation: 20,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: ParralaxCard(),
            ),
          ),
        ),
      ],
    ));
  }
}

class GameScreen extends StatelessWidget {
  const GameScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Level1());
  }
}
