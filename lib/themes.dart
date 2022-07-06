import 'package:flutter/material.dart';

const colorScheme = ColorScheme(
  background: Color(0xFFEAF2CE),
  onBackground: Color(0xFF707365),
  brightness: Brightness.light,
  primary: Color(0xFF53A62D),
  shadow: Color(0xFF707365),
  onPrimary: Colors.black,
  secondary: Color(0xFF9CD918),
  onSecondary: Color(0xFF707365),
  error: Color.fromARGB(206, 255, 62, 48),
  onError: Colors.black,
  surface: Color(0xFFB6D96A),
  onSurface: Color(0xFF9CD918),
  inversePrimary: Color.fromARGB(255, 218, 75, 62),
  // tertiary: Color.fromARGB(185, 177, 50, 48),
);

final elevatedButtonTheme = ElevatedButtonThemeData(
  style: ElevatedButton.styleFrom(
    shape: const CircleBorder(),
    padding: const EdgeInsets.all(20),
    primary: colorScheme.surface,
    onPrimary: Colors.black,
    shadowColor: colorScheme.secondary,
  ),
);

final textTheme = TextTheme(
  headline1: const TextStyle(
    fontSize: 48.0,
    fontWeight: FontWeight.bold,
    color: Color(0xFF53A62D),
  ),
  headline2: const TextStyle(
    fontSize: 36.0,
    fontWeight: FontWeight.w300,
    // color: Color(0xFF707365),
    fontFamily: 'Nunito',
  ),
  headline3: const TextStyle(
    fontSize: 16.0,
    fontWeight: FontWeight.bold,
    fontFamily: 'Nunito',
  ),
  headline6: TextStyle(
    fontSize: 24.0,
    color: colorScheme.primary,
    fontWeight: FontWeight.bold,
    fontFamily: 'Quicksand',
  ),
  headline5: const TextStyle(
    fontSize: 16.0,
    fontWeight: FontWeight.bold,
    fontFamily: 'Quicksand',
    color: Colors.white,
  ),
  bodyText1: const TextStyle(
    fontSize: 16.0,
    fontWeight: FontWeight.w400,
    fontFamily: 'Quicksand',
  ),
  bodyText2: const TextStyle(
    fontSize: 16.0,
    fontWeight: FontWeight.w400,
    fontFamily: 'Quicksand',
    color: Colors.white,
  ),
);

const cardTheme = CardTheme(
  color: Color(0xFFEAF2CE),
  shadowColor: Color(0xFF9CD918),
);
