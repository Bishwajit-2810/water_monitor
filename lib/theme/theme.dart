import 'package:flutter/material.dart';

ThemeData lightMode = ThemeData(
  // useMaterial3: true,
  brightness: Brightness.light,
  colorScheme: ColorScheme.light(surface: Colors.white),
);

ThemeData darkMode = ThemeData(
  // useMaterial3: true,
  brightness: Brightness.dark,
  colorScheme: ColorScheme.dark(surface: Color(0xff222331)),
);
