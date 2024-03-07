import 'package:flutter/material.dart';

sealed class AppTheme {
  static final _lightColorScheme = ColorScheme.fromSeed(
    seedColor: const Color(0xFF769c00),
  );

  static final _darkColorScheme = ColorScheme.fromSeed(
    seedColor: const Color(0xFF769c00),
    brightness: Brightness.dark,
  );

  static ThemeData get light => _build(_lightColorScheme);
  static ThemeData get dark => _build(_darkColorScheme);

  static ThemeData _build(ColorScheme colorScheme) {
    return ThemeData(
      colorScheme: colorScheme,
      appBarTheme: AppBarTheme(color: colorScheme.tertiaryContainer),
      snackBarTheme: const SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 20),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
      inputDecorationTheme: const InputDecorationTheme(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(8)),
        ),
      ),
      progressIndicatorTheme:
          const ProgressIndicatorThemeData(linearMinHeight: 2),
      useMaterial3: true,
    );
  }
}
