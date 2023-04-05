import 'package:flutter/material.dart';

final Color _primaryColor = Color(0xfffcae5f);
final Color _backgroundColor = Color(0xbf8fd1c2);
final Color _textColor = Color(0xff000000);

ThemeData themeData = ThemeData(
  primaryColor: _primaryColor,
  backgroundColor: _backgroundColor,
  textTheme: TextTheme(
    bodyText1: TextStyle(
      fontSize: 16,
      color: _textColor,
    ),
  ),
);
