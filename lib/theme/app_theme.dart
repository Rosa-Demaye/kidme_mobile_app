import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'app_colors.dart';

/// Centralized theme management for the Kidme application.
class AppTheme {
  const AppTheme._();

  static ThemeData get light {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: AppColors.midnightNavy,
      primary: AppColors.primaryNavy,
      secondary: AppColors.professionalBlue,
      tertiary: AppColors.goldAccent,
      surface: Colors.white,
    );

    final textTheme = GoogleFonts.interTextTheme();

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: AppColors.mist,
      textTheme: textTheme.copyWith(
        displaySmall: GoogleFonts.inter(
          color: AppColors.primaryNavy,
          fontSize: 34,
          fontWeight: FontWeight.w900,
          height: 1.05,
          letterSpacing: -0.5,
        ),
        headlineSmall: GoogleFonts.inter(
          color: AppColors.primaryNavy,
          fontSize: 24,
          fontWeight: FontWeight.w800,
          letterSpacing: -0.3,
        ),
        titleLarge: GoogleFonts.inter(
          color: AppColors.darkText,
          fontSize: 20,
          fontWeight: FontWeight.w800,
        ),
        titleMedium: GoogleFonts.inter(
          color: AppColors.darkText,
          fontSize: 16,
          fontWeight: FontWeight.w700,
        ),
        bodyLarge: GoogleFonts.inter(
          color: AppColors.darkText,
          fontSize: 15,
          height: 1.45,
        ),
        bodyMedium: GoogleFonts.inter(
          color: AppColors.softGrey,
          fontSize: 13,
          height: 1.35,
        ),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.softWhite,
        foregroundColor: AppColors.primaryNavy,
        elevation: 0,
        centerTitle: false,
      ),
      cardTheme: CardThemeData(
        color: Colors.white,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18),
          side: const BorderSide(color: AppColors.cardBorder),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primaryNavy,
          foregroundColor: Colors.white,
          minimumSize: const Size.fromHeight(54),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
          textStyle: const TextStyle(fontWeight: FontWeight.w800),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppColors.primaryNavy,
          textStyle: const TextStyle(fontWeight: FontWeight.w800),
        ),
      ),
      navigationBarTheme: const NavigationBarThemeData(
        backgroundColor: Colors.white,
        indicatorColor: AppColors.blueMist,
        labelTextStyle: WidgetStatePropertyAll(
          TextStyle(fontWeight: FontWeight.w700, fontSize: 12),
        ),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: AppColors.blueMist,
        selectedColor: AppColors.primaryNavy,
        labelStyle: const TextStyle(color: AppColors.primaryNavy),
        secondaryLabelStyle: const TextStyle(color: Colors.white),
        side: const BorderSide(color: AppColors.cardBorder),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white,
        hintStyle: const TextStyle(color: AppColors.softGrey),
        prefixIconColor: AppColors.softGrey,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}
