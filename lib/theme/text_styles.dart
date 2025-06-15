import 'package:flutter/material.dart';
import 'colors.dart';

class AppTextStyles {
  // Display styles (largest) - Minimal and clean
  static const TextStyle displayLarge = TextStyle(
    fontSize: 57,
    fontWeight: FontWeight.w300, // Lighter weight for minimal look
    letterSpacing: -0.25,
    color: AppColors.grey900,
  );

  static const TextStyle displayMedium = TextStyle(
    fontSize: 45,
    fontWeight: FontWeight.w300,
    color: AppColors.grey900,
  );

  static const TextStyle displaySmall = TextStyle(
    fontSize: 36,
    fontWeight: FontWeight.w400,
    color: AppColors.grey800,
  );

  // Headline styles - Clean and readable
  static const TextStyle headlineLarge = TextStyle(
    fontSize: 32,
    fontWeight: FontWeight.w400, // Reduced weight
    color: AppColors.grey900,
  );

  static const TextStyle headlineMedium = TextStyle(
    fontSize: 28,
    fontWeight: FontWeight.w400,
    color: AppColors.grey900,
  );

  static const TextStyle headlineSmall = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.w500,
    color: AppColors.grey800,
  );

  // Title styles - Subtle hierarchy
  static const TextStyle titleLarge = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w500, // Reduced from w600
    color: AppColors.grey800,
  );

  static const TextStyle titleMedium = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w500,
    color: AppColors.grey700,
  );

  static const TextStyle titleSmall = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w500,
    color: AppColors.grey700,
  );

  // Body styles - Clean and readable
  static const TextStyle bodyLarge = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    color: AppColors.grey600, // Softer than before
    height: 1.5, // Better line spacing
  );

  static const TextStyle bodyMedium = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: AppColors.grey600,
    height: 1.4,
  );

  static const TextStyle bodySmall = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    color: AppColors.grey500, // More subtle
    height: 1.3,
  );

  // Label styles - Minimal emphasis
  static const TextStyle labelLarge = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    color: AppColors.grey600,
  );

  static const TextStyle labelMedium = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w500,
    color: AppColors.grey500,
  );

  static const TextStyle labelSmall = TextStyle(
    fontSize: 10,
    fontWeight: FontWeight.w500,
    color: AppColors.grey400, // Very subtle
  );

  // Caption - Very minimal
  static const TextStyle caption = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    color: AppColors.grey400,
  );

  // Button text - Clean and simple
  static const TextStyle button = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w500, // Reduced from w600
    color: AppColors.white,
  );
}
