import 'package:flutter/material.dart';

class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  @override
  Widget build(BuildContext context) {
    return Container(padding: EdgeInsets.only(top: 64.0),
        decoration: BoxDecoration(
          gradient: LinearGradient(
              colors: signUpGradients,
              begin: Alignment.topLeft,
              end: Alignment.bottomRight),
        ),
    child: ListView(
    ),);
  }
}

const List<Color> signUpGradients = [
  /* Color(0xFFFF9945),
  Color(0xFFFc6076),*/
  /*kShrinePink500,
  kShrinePink600,
  Colors.pinkAccent,*/
  Colors.black,
  Colors.black87
];
