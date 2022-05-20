import 'package:flutter/material.dart';

class Themes {
  static final lightTheme = ThemeData(
    scaffoldBackgroundColor: const Color(0xFFFFFFFF),
    backgroundColor: const Color(0xFFFFFFFF),
    cardColor: const Color(0xffd8d8d8),
    focusColor: const Color(0xffffffff),
    disabledColor: const Color(0xFF2A2A2A),
    hintColor: const Color(0xFF1C1C1C),
    canvasColor: const Color(0xFF262626),
    highlightColor: const Color(0xFF4F4F4F),
    brightness: Brightness.light,
  );

  static final darkTheme = ThemeData(
    scaffoldBackgroundColor: const Color(0xFF151515),
    backgroundColor: const Color(0xFF151515),
    cardColor: const Color(0xFFD8D8D8),
    focusColor: const Color(0xFF1C1C1C),
    disabledColor: const Color(0xFF2A2A2A),
    hintColor: const Color(0xFF1C1C1C),
    canvasColor: const Color(0xFF262626),
    highlightColor: const Color(0xFF4F4F4F),
    splashColor: const Color(0xFF353535),
    brightness: Brightness.dark,
  );
}