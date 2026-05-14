import 'package:flutter/material.dart';
import 'colors.dart';
import 'button_theme.dart';
import 'input_theme.dart';

class AppTheme {
  static ThemeData buildTheme() {
    return ThemeData(
      primaryColor: coffeeColor,
      appBarTheme: const AppBarTheme(backgroundColor: coffeeColor),
      scaffoldBackgroundColor: crema,
      elevatedButtonTheme: buildElevatedButtonTheme(),
      inputDecorationTheme: buildInputDecorationTheme(),
    );
  }
}
