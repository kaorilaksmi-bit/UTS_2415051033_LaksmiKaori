// lib/core/app_theme.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

ThemeData buildTheme() {
  final base = ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(
      seedColor: AppColors.primary,
      primary: AppColors.primary,
    ),
  );
  return base.copyWith(
    scaffoldBackgroundColor: Colors.white,
    textTheme: base.textTheme.apply(
      fontFamily: GoogleFonts.poppins().fontFamily,
    ),
  );
}