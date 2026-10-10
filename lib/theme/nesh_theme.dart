import 'package:flutter/material.dart';

class NeshColors {
  static const Color black = Color(0xFF000000);
  static const Color surface = Color(0xFF121212);
  static const Color surfaceAlt = Color(0xFF1E1E1E);
  static const Color neon = Color(0xFF00FF66);
  static const Color neonDim = Color(0xFF00CC52);
  static const Color neonGlow = Color(0x3300FF66);
  static const Color textPrimary = Color(0xFFFFFFFF);
  static const Color textSecondary = Color(0xFFAAAAAA);
  static const Color error = Color(0xFFFF3333);
}

class NeshTheme {
  static ThemeData get darkTheme => ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        scaffoldBackgroundColor: NeshColors.black,
        primaryColor: NeshColors.neon,
        colorScheme: const ColorScheme.dark(
          primary: NeshColors.neon,
          secondary: NeshColors.neon,
          surface: NeshColors.surface,
          error: NeshColors.error,
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: NeshColors.black,
          elevation: 0,
          centerTitle: true,
          iconTheme: IconThemeData(color: NeshColors.neon),
        ),
        cardTheme: CardThemeData(
          color: NeshColors.surface,
          elevation: 4,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: NeshColors.surfaceAlt,
          labelStyle: const TextStyle(color: NeshColors.textSecondary),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: NeshColors.neon, width: 1.5),
          ),
        ),
      );
}
