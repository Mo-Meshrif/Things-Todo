import 'package:flutter/material.dart';

import 'color_manager.dart';

class ThemeManager {
  static ThemeData lightTheme() {
    return ThemeData(
      // main colors
      primaryColor: ColorManager.primary,
      hintColor: ColorManager.swatch,
      backgroundColor: ColorManager.background,
      // app bar theme
      appBarTheme: AppBarTheme(
        elevation: 0,
        centerTitle: false,
        color: ColorManager.primary,
      ),
      // input decoration theme (text form field)
      inputDecorationTheme: const InputDecorationTheme(
        contentPadding: EdgeInsets.symmetric(horizontal: 10),
        hintStyle: TextStyle(color: Colors.grey),
        border: InputBorder.none,
      ),
      // elevated button them
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: ColorManager.primary,
        ),
      ),
    );
  }
}
