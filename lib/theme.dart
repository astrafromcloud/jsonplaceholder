import 'package:flutter/material.dart';

class ThemeConfig{
  static Color grad1 = const Color(0xFF322C54);
  static Color grad2 = const Color(0xFF231D49);
  static Color widgetColor = const Color(0xFF221C44);
  static Color backgroundColor = const Color(0xFF0F0B21);

  static ThemeData themeData = ThemeData(
    backgroundColor: backgroundColor,
  );

  static TextStyle textStyle = const TextStyle(
    fontFamily: 'Raleway',
    fontWeight: FontWeight.w700
  );

  static LinearGradient gradient = LinearGradient(
      colors: [grad1, grad2],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter
  );

}