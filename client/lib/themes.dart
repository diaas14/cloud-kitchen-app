import 'package:flutter/material.dart';

final Color _primaryColor = Color(0xfffcae5f);
final Color _backgroundColor = Color(0xbf8fd1c2);
final Color _textColor = Color(0xff000000);
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
