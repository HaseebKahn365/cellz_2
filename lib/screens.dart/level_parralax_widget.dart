import 'package:cellz/screens.dart/parralax_bg.dart';
import 'package:flutter/material.dart';

class ParralaxCard extends StatefulWidget {
  const ParralaxCard({super.key});

  @override
  State<ParralaxCard> createState() => _ParralaxCardState();
}

class _ParralaxCardState extends State<ParralaxCard> {
  double topFour = 0;
  double topThree = 0;
  double topTwo = 0;
  double topOne = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NotificationListener(
        onNotification: (notif) {
          if (notif is ScrollUpdateNotification) {
            if (notif.scrollDelta == null) return true;
            setState(() {
              topFour -= notif.scrollDelta! * 4 / 16;
              topThree -= notif.scrollDelta! * 4 / 12;
              topTwo -= notif.scrollDelta! * 4 / 8;
              topOne -= notif.scrollDelta! * 2.5 / 3;
            });
          }
          return true;
        },
        child: Stack(
          children: [
            ParalaxBackground(
              top: topFour,
              asset: "assets/images/4.png",
            ),
            ParalaxBackground(
              top: topThree,
              asset: "assets/images/3.png",
            ),
            ParalaxBackground(
              top: topTwo,
              asset: "assets/images/2.png",
            ),
            ParalaxBackground(
              top: topOne,
              asset: "assets/images/1.png",
            ),
            SingleChildScrollView(
              physics: const ClampingScrollPhysics(),
              child: Column(
                children: [
                  const SizedBox(height: 190),
                  Container(
                    height: 100,
                    color: Color.fromARGB(255, 42, 0, 139),
                    alignment: Alignment.center,
                    child: Text(
                      "Paralax Effect",
                      style: Theme.of(context).textTheme.headlineMedium?.copyWith(color: Colors.white),
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
