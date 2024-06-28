// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';

class CellzApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: HomeScreen(),
        theme: ThemeData(
          // colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.deepPurple),
          brightness: Brightness.dark,
        ));
  }
}

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Icon(Icons.menu),
        title: Text('Cellz'),
        centerTitle: true,
        actions: [
          //icon to toggle brightness
          IconButton(
            icon: Icon(Icons.brightness_4),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            ProfileSection(),
            TabSection(),
          ],
        ),
      ),
    );
  }
}

class ProfileSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.0),
      child: Column(
        children: [
          Row(
            children: [
              // CircleAvatar(
              //   radius: 60,
              //   backgroundImage: NetworkImage('https://via.placeholder.com/150'),
              // ),
              Container(
                width: 120,
                height: 200,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.4),
                      blurRadius: 10,
                      offset: Offset(0, 5),
                    ),
                  ],
                  image: DecorationImage(
                    image: Image.asset('assets/images/5.jpg').image,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              SizedBox(width: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Abdul Haseeb',
                    style: TextStyle(fontSize: 25, fontWeight: FontWeight.w400),
                  ),
                  const SizedBox(height: 10),
                  Text('Wins / Losses:', style: TextStyle(fontSize: 12)),
                  //22/3
                  Row(
                    children: [
                      Text('22',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w200,
                          )),
                      Text('/', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w200)),
                      Text('3', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w200)),
                    ],
                  ),

                  // Text('Score:', style: TextStyle(fontSize: 12)),
                  // // 1200
                  // Text('1200', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w200)),
                  const SizedBox(height: 10),
                  // hearts
                  Text('Hearts:',
                      style: TextStyle(
                        fontSize: 12,
                      )),
                  Row(
                    children: [
                      Icon(Icons.favorite_border),
                      Icon(Icons.favorite_border),
                      Icon(Icons.favorite_border),
                    ],
                  ),
                  const SizedBox(height: 10),

                  Text('Next Life:', style: TextStyle(fontSize: 12)),
                  // 2:30
                  Text('2:30', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w200)),
                ],
              ),
            ],
          ),
          SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Text('Current Level: ', style: TextStyle(fontSize: 12)),
                  Text('12', style: TextStyle(fontSize: 18)),
                ],
              ),
              //elevated button with icon
              OutlinedButton.icon(
                onPressed: () {},
                icon: Icon(Icons.favorite),
                label: Text('Ad'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class TabSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Column(
        children: [
          TabBar(
            tabs: [
              Tab(text: 'Overview'),
              Tab(text: 'Journey'),
              Tab(text: 'Special'),
            ],
          ),
          Container(
            height: 300,
            child: TabBarView(
              children: [
                // Center(child: Text('Overview Content')),

                //creating a coursel similar to google photos
                Center(child: Text('Journey Content')),
                Center(child: Text('Special Content')),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
