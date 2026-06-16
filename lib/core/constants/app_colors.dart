import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  static const Color white = Color(0xFFFFFFFF);
  static const Color background = Color(0xFFFFFFFF);

  static const Color greenPrimary = Color(0xFF4CAF50);
  static const Color greenDark = Color(0xFF2E7D32);

  static const Color redPrimary = Color(0xFFF44336);
  static const Color redDark = Color(0xFFC62828);

  static const Color textPrimary = Color(0xFF1A1A1A);
  static const Color textSecondary = Color(0xFF6B7280);

  static const Color divider = Color(0xFFE5E7EB);
  static const Color border = Color(0xFFE5E7EB);

  static const Color success = Color(0xFF4CAF50);
  static const Color warning = Color(0xFFFF9800);
  static const Color error = Color(0xFFF44336);

  static const Color shadow = Color(0x14000000);

  static const LinearGradient mainGradient = LinearGradient(
    colors: [greenPrimary, redPrimary],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient greenGradient = LinearGradient(
    colors: [greenPrimary, greenDark],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient redGradient = LinearGradient(
    colors: [redPrimary, redDark],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient sidebarActiveGradient = LinearGradient(
    colors: [greenPrimary, redPrimary],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const Color sidebarBackground = Color(0xD9FFFFFF);
  static const Color sidebarBorder = Color(0x33FFFFFF);
  static const Color sidebarShadow = Color(0x14000000);
  static const Color sidebarInactive = Color(0xFF6B7280);
}
