import 'package:flutter/material.dart';

class ParalaxBackground extends StatelessWidget {
  const ParalaxBackground({
    super.key,
    required this.asset,
    this.top,
  });

  final double? top;
  final String asset;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        //create a bg color

        Positioned(
          top: top!,
          left: 0,
          right: 0,
          child: SizedBox(
            height: 200,
            child: Image(
              image: AssetImage(asset),
              fit: BoxFit.cover,
            ),
          ),
        ),
        Container(
          height: 200,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color.fromARGB(255, 175, 175, 175).withOpacity(0.3),
                Colors.transparent,
              ],
            ),
          ),
        ),
      ],
    );
  }
}
