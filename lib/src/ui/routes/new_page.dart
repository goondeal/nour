import 'package:flutter/material.dart';

class NewPage extends StatelessWidget {
  NewPage({this.title, Key key}): super(key: key);
  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title),),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        color: Colors.white,
        child: Center(
          child: Text('this is $title Page'),
        ),
      ),
      
    );
  }
}