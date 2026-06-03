import 'package:flutter/material.dart';

class AppColors {
  const AppColors._();

  static const background = Color(0xFFF8FAF8);
  static const secondaryBackground = Color(0xFFFFFFFF);
  static const surface = Color(0xFFEBF2EE);
  static const surfaceVariant = Color(0xFFD8E2DC);
  static const primary = Color(0xFF2D6A4F);
  static const secondary = Color(0xFF52B788);
  static const accent = Color(0xFFFF9F1C);
  static const warning = Color(0xFFF4A261);
  static const success = Color(0xFF40916C);
  static const error = Color(0xFFE63946);
  static const info = Color(0xFF457B9D);
  static const primaryText = Color(0xFF1B4332);
  static const secondaryText = Color(0xFF556B5F);
  static const hint = Color(0xFFA3B18A);
  static const outline = Color(0xFFCED4DA);
  static const divider = Color(0xFFE9ECEF);

  static Color byToken(String token) {
    return switch (token) {
      'success' => success,
      'error' => error,
      'warning' => warning,
      'info' => info,
      'primary' => primary,
      _ => primary,
    };
  }
}
