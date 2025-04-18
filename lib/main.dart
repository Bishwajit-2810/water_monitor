import 'package:flutter/material.dart';
import 'package:water_monitor/splash_screen.dart';
import 'package:water_monitor/theme/theme.dart';
import 'package:water_monitor/theme/theme_notifier.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: isDarkThemeNotifier,
      builder: (BuildContext context, dynamic isDarkTheme, Widget? child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: (isDarkTheme) ? darkMode : lightMode,
          home: SplashScreen(),
        );
      },
    );
  }
}
