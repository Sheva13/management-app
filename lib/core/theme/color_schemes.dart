import 'package:flutter/material.dart';
import '../constants/app_colors.dart';

class ColorSchemes {
  ColorSchemes._();

  static const ColorScheme lightColorScheme = ColorScheme(
    brightness: Brightness.light,
    primary: AppColors.greenPrimary,
    onPrimary: AppColors.white,
    primaryContainer: Color(0xFFC8E6C9),
    onPrimaryContainer: AppColors.greenDark,
    secondary: AppColors.redPrimary,
    onSecondary: AppColors.white,
    secondaryContainer: Color(0xFFFFCDD2),
    onSecondaryContainer: AppColors.redDark,
    surface: AppColors.white,
    onSurface: AppColors.textPrimary,
    surfaceContainerHighest: Color(0xFFF5F5F5),
    onSurfaceVariant: AppColors.textSecondary,
    error: AppColors.error,
    onError: AppColors.white,
    outline: AppColors.divider,
    outlineVariant: AppColors.border,
  );

  static const ColorScheme darkColorScheme = ColorScheme(
    brightness: Brightness.dark,
    primary: AppColors.greenPrimary,
    onPrimary: AppColors.white,
    primaryContainer: Color(0xFF1B5E20),
    onPrimaryContainer: Color(0xFFC8E6C9),
    secondary: AppColors.redPrimary,
    onSecondary: AppColors.white,
    secondaryContainer: Color(0xFFB71C1C),
    onSecondaryContainer: Color(0xFFFFCDD2),
    surface: Color(0xFF1A1A1A),
    onSurface: AppColors.white,
    surfaceContainerHighest: Color(0xFF2A2A2A),
    onSurfaceVariant: AppColors.textSecondary,
    error: AppColors.error,
    onError: AppColors.white,
    outline: Color(0xFF3A3A3A),
    outlineVariant: Color(0xFF4A4A4A),
  );
}
