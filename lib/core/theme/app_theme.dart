import 'package:flutter/material.dart';
import 'package:test_app/core/theme/color_schemes.dart';

class AppTheme {
  static final ThemeData light = ThemeData(
      useMaterial3: true,
      colorScheme: lightColorScheme,
      fontFamily: 'Montserrat',
      appBarTheme: const AppBarTheme(elevation: 10));

  static final ThemeData dark = ThemeData(
      useMaterial3: true,
      colorScheme: darkColorScheme,
      fontFamily: 'Montserrat',
      appBarTheme: const AppBarTheme(elevation: 10));
}
