import 'package:flutter/material.dart';
import 'package:truck_tracker/config/preferences.dart';

class AppTheme {
  static final lightTheme = ThemeData(
    primaryColor: Color(Preferences.primaryGreen),
    scaffoldBackgroundColor: Colors.white,

    // Input field theme
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Color(Preferences.secondaryGreen),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(
          color: Color(Preferences.primaryGreen),
          width: 2,
        ),
      ),
      labelStyle: const TextStyle(
        color: Colors.black87,
        fontSize: Preferences.inputFontSize,
      ),
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 14,
      ),
    ),

    // Button theme
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: Color(Preferences.secondaryGreen),
        foregroundColor: Colors.black,
        minimumSize: const Size.fromHeight(Preferences.buttonHeight),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        textStyle: const TextStyle(
          fontSize: Preferences.buttonFontSize,
          fontWeight: FontWeight.bold,
        ),
      ),
    ),
  );
}