import 'package:flutter/material.dart';

final Color _primaryColor = Color.fromRGBO(252, 174, 95, 1);
final Color _backgroundColor = Color.fromRGBO(143, 209, 194, 0.749);
final Color _textColor = Color.fromRGBO(0, 0, 0, 1);
ThemeData themeData = ThemeData(
  primaryColor: _primaryColor,
  backgroundColor: _backgroundColor,
  textTheme: TextTheme(
    headline1: TextStyle(
      fontSize: 24,
      fontWeight: FontWeight.bold,
      color: _textColor,
    ),
    headline2: TextStyle(
      fontSize: 20,
      fontWeight: FontWeight.bold,
      color: _textColor,
    ),
    bodyText1: TextStyle(
      fontSize: 16,
      color: _textColor,
    ),
    button: TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.bold,
      color: Colors.white,
    ),
  ),
);
