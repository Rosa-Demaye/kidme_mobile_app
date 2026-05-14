import 'package:flutter/material.dart';
import 'app_colors.dart';

/// Centralized theme management for the Kidme application.
///
/// Follows a "Professional-Clean" aesthetic inspired by modern startups
/// like Stripe and Linear, emphasizing typography, spacing, and subtle shadows.
class AppTheme {
  const AppTheme._();

  /// Returns the global light theme configuration.
  ///
  /// This theme defines:
  /// - Material 3 design standards.
  /// - Custom [ColorScheme] using brand-specific colors.
  /// - Global styles for Buttons, Cards, and Input fields to ensure UI consistency.
  static ThemeData get light {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: AppColors.professionalBlue,
      primary: AppColors.primaryNavy,
      secondary: AppColors.professionalBlue,
      tertiary: AppColors.goldAccent,
      surface: Colors.white,
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: AppColors.softWhite,
      fontFamily: 'Roboto', // Professional, readable sans-serif font.
      
      // Typography system emphasizing hierarchy and clarity.
      textTheme: const TextTheme(
        displaySmall: TextStyle(
          color: AppColors.primaryNavy,
          fontSize: 34,
          fontWeight: FontWeight.w800,
          height: 1.05,
        ),
        headlineSmall: TextStyle(
          color: AppColors.primaryNavy,
          fontSize: 24,
          fontWeight: FontWeight.w800,
        ),
        titleLarge: TextStyle(
          color: AppColors.darkText,
          fontSize: 20,
          fontWeight: FontWeight.w800,
        ),
        titleMedium: TextStyle(
          color: AppColors.darkText,
          fontSize: 16,
          fontWeight: FontWeight.w700,
        ),
        bodyLarge: TextStyle(
          color: AppColors.darkText,
          fontSize: 15,
          height: 1.45,
        ),
        bodyMedium: TextStyle(
          color: AppColors.softGrey,
          fontSize: 13,
          height: 1.35,
        ),
      ),
      
      // Clean, flat AppBar style.
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.softWhite,
        foregroundColor: AppColors.primaryNavy,
        elevation: 0,
        centerTitle: false,
      ),
      
      // Soft card styling with subtle borders instead of heavy shadows.
      cardTheme: CardThemeData(
        color: Colors.white,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18),
          side: const BorderSide(color: AppColors.cardBorder),
        ),
      ),
      
      // Bold, high-contrast action buttons.
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.professionalBlue,
          foregroundColor: Colors.white,
          minimumSize: const Size.fromHeight(54),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
          textStyle: const TextStyle(fontWeight: FontWeight.w800),
        ),
      ),
      
      // Modern input field styling with a soft background.
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
