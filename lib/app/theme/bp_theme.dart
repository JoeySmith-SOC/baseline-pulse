import 'package:baseline_pulse/app/theme/bp_colors.dart';
import 'package:flutter/material.dart';

abstract final class BpTheme {
  static ThemeData build() {
    final ColorScheme scheme = const ColorScheme.dark(
      primary: BpColors.red,
      secondary: BpColors.red,
      surface: BpColors.slate,
      onSurface: BpColors.white,
      onPrimary: BpColors.white,
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: scheme,
      scaffoldBackgroundColor: BpColors.black,
      appBarTheme: const AppBarTheme(
        backgroundColor: BpColors.black,
        foregroundColor: BpColors.white,
      ),
      cardTheme: CardThemeData(
        color: BpColors.slate,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: BpColors.border),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: BpColors.slate,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: BpColors.border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: BpColors.border),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          minimumSize: const Size(double.infinity, 52),
          backgroundColor: BpColors.red,
          foregroundColor: BpColors.white,
          textStyle: const TextStyle(fontWeight: FontWeight.w700),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        ),
      ),
    );
  }
}
