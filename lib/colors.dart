import 'package:flutter/material.dart';

class Palette {
  static const MaterialColor kToDark = MaterialColor(
    0xFF2858F5, // 0% comes in here, this will be color picked if no shade is selected when defining a Color property which doesn’t require a swatch.
    <int, Color>{
      50: Color.fromARGB(255, 41, 98, 255),
      100: Color.fromARGB(255, 41, 98, 255),
      200: Color.fromARGB(255, 41, 98, 255),
      300: Color.fromARGB(255, 41, 98, 255),
      400: Color.fromARGB(255, 41, 98, 255),
      500: Color.fromARGB(255, 41, 98, 255),
      600: Color.fromARGB(255, 41, 98, 255),
      700: Color.fromARGB(255, 41, 98, 255),
      800: Color.fromARGB(255, 41, 98, 255),
      900: Color.fromARGB(255, 41, 98, 255),
    },
  );
}
