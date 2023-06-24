import 'package:flutter/material.dart';

class AppColors {
  // MaterialColor primarAppColor = Colors.orange;
  MaterialColor primarAppColor =
      MaterialColorGenerator.from(Color.fromARGB(255, 34, 35, 61));
  // Color primaryColor = Colors.amber[800]!;

  Color primaryColor = Color.fromARGB(255, 34, 35, 61)!;

  Color secondaryColor = Colors.amber[600]!;
  Color tertiaryColor = Colors.amber[400]!;
  Color iconColor = Colors.black;
  Color textColor = Colors.white;

  Color readtextColor = Colors.black;
  Color backgroundColor = Colors.white;
}

class MaterialColorGenerator {
  static MaterialColor from(Color color) {
    return MaterialColor(color.value, <int, Color>{
      50: color.withOpacity(0.1),
      100: color.withOpacity(0.2),
      200: color.withOpacity(0.3),
      300: color.withOpacity(0.4),
      400: color.withOpacity(0.5),
      500: color.withOpacity(0.6),
      600: color.withOpacity(0.7),
      700: color.withOpacity(0.8),
      800: color.withOpacity(0.9),
      900: color.withOpacity(1.0),
    });
  }
}
