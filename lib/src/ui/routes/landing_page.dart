import 'package:flutter/material.dart';

class LandingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
      children: <Widget>[
        Container(
          width: double.infinity,
          height: double.infinity,
          child: Image.asset(
            'assets/nour.jpg',
            fit: BoxFit.cover,
          ),
        ),
        Center(
          child: const CircularProgressIndicator(),
        )
      ],
    ));
  }
}
