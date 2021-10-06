import 'package:flutter/material.dart';

final defaultTheme = ThemeData(
  brightness: Brightness.dark,
  primaryColor: Colors.lightBlue[500],
  fontFamily: 'Georgia',
  textTheme: const TextTheme(
    headline1: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
    headline6: TextStyle(
        fontSize: 20, fontStyle: FontStyle.italic, fontWeight: FontWeight.bold),
    bodyText2: TextStyle(fontSize: 14),
  ),
);
