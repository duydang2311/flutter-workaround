import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

abstract class AppTheme {
  static final lightColorScheme = ColorScheme.fromSeed(
    seedColor: const Color(0xFF0057FF),
  );

  static ColorScheme lighterOutline(ColorScheme colorScheme) =>
      colorScheme.copyWith(
        outline: _lighten(lightColorScheme.outline, 0.3),
        outlineVariant: _lighten(lightColorScheme.outlineVariant, 0.3),
      );

  static final darkColorScheme = ColorScheme.fromSeed(
    seedColor: const Color(0xFF0057FF),
    brightness: Brightness.dark,
  );

  static ColorScheme darkerOutline(ColorScheme colorScheme) =>
      colorScheme.copyWith(
        outline: _darken(lightColorScheme.outline, 0.2),
        outlineVariant: _darken(lightColorScheme.outlineVariant, 0.2),
      );

  static ThemeData build(ColorScheme colorScheme) {
    return ThemeData(
      colorScheme: colorScheme,
      fontFamily: GoogleFonts.sourceSans3().fontFamily,
      snackBarTheme: const SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
      inputDecorationTheme: const InputDecorationTheme(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(8),
          ),
          borderSide: BorderSide(width: 4),
        ),
      ),
      progressIndicatorTheme:
          const ProgressIndicatorThemeData(linearMinHeight: 2),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        selectedItemColor: colorScheme.primary,
        selectedLabelStyle: const TextStyle(fontWeight: FontWeight.w700),
      ),
      listTileTheme: const ListTileThemeData(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(8)),
        ),
      ),
      useMaterial3: true,
    );
  }
}

Color _darken(Color color, [double amount = .1]) {
  final hsl = HSLColor.fromColor(color);
  final hslDark = hsl.withLightness((hsl.lightness - amount).clamp(0.0, 1.0));

  return hslDark.toColor();
}

Color _lighten(Color color, [double amount = .1]) {
  final hsl = HSLColor.fromColor(color);
  final hslLight = hsl.withLightness((hsl.lightness + amount).clamp(0.0, 1.0));

  return hslLight.toColor();
}
