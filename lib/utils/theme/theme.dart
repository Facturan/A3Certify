import 'package:a3certify/utils/theme/custom_theme/text_theme.dart';
import 'package:flutter/material.dart';

class RAppTheme {
  RAppTheme._();

  static ThemeData LightTheme = ThemeData(
      useMaterial3: true,
      fontFamily: 'Poppins',
      brightness: Brightness.light,
      primaryColor: Colors.blue,
      scaffoldBackgroundColor: Colors.white,
      textTheme: RTextTheme.lighTextTheme,
      );
  static ThemeData darkTheme = ThemeData(
    useMaterial3: true,
      fontFamily: 'Poppins',
      brightness: Brightness.dark,
      primaryColor: Colors.blue,
      scaffoldBackgroundColor: Colors.black,
      textTheme: RTextTheme.darkTextTheme,
  );
}
