import 'package:flutter/material.dart';

/// Paleta do app — inspirada em painéis e quadros de comando de fábrica.
class AppColors {
  AppColors._();

  static const bg = Color(0xFF14181D);
  static const bgGradientEnd = Color(0xFF1B222B);
  static const surface = Color(0xFF1E252D);
  static const surfaceRaised = Color(0xFF262E38);
  static const surfaceSunken = Color(0xFF10141A);
  static const border = Color(0xFF333D48);
  static const borderLight = Color(0xFF3E4A58);

  static const primary = Color(0xFF4F86E3);
  static const primaryDark = Color(0xFF33579C);
  static const amber = Color(0xFFF0A93D);
  static const success = Color(0xFF35C27D);
  static const successDark = Color(0xFF1F8F5A);
  static const danger = Color(0xFFE5533D);

  static const textPrimary = Color(0xFFEDEFF2);
  static const textSecondary = Color(0xFFAEB6C2);
  static const textMuted = Color(0xFF6E7885);
}

/// Estilos de texto reutilizados em todas as telas.
class AppText {
  AppText._();

  static const eyebrow = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w700,
    letterSpacing: 2.0,
    color: AppColors.textMuted,
  );

  static const title = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.w800,
    letterSpacing: -0.3,
    color: AppColors.textPrimary,
    height: 1.2,
  );

  static const subtitle = TextStyle(
    fontSize: 15,
    fontWeight: FontWeight.w500,
    color: AppColors.textSecondary,
  );

  static const body = TextStyle(
    fontSize: 15,
    fontWeight: FontWeight.w500,
    color: AppColors.textPrimary,
  );

  static const label = TextStyle(
    fontSize: 13,
    fontWeight: FontWeight.w600,
    color: AppColors.textSecondary,
  );

  // Estilo "contador mecânico" — dígitos monoespaçados e espaçados.
  static const counter = TextStyle(
    fontFamily: 'monospace',
    fontSize: 60,
    fontWeight: FontWeight.w700,
    letterSpacing: 4,
    height: 1,
    color: AppColors.amber,
  );

  static const button = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w700,
    letterSpacing: 1.1,
    color: Colors.white,
  );
}

/// Decoração padrão de campos de texto para o tema escuro.
InputDecoration appInputDecoration({
  required String label,
  String? hint,
  IconData? icon,
  String? counterText,
}) {
  return InputDecoration(
    labelText: label,
    hintText: hint,
    counterText: counterText,
    labelStyle: AppText.label,
    hintStyle: AppText.label.copyWith(color: AppColors.textMuted),
    prefixIcon:
        icon != null ? Icon(icon, color: AppColors.textMuted, size: 20) : null,
    filled: true,
    fillColor: AppColors.surfaceSunken,
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(14),
      borderSide: const BorderSide(color: AppColors.border),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(14),
      borderSide: const BorderSide(color: AppColors.border),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(14),
      borderSide: const BorderSide(color: AppColors.primary, width: 1.6),
    ),
  );
}

/// ThemeData completo do app.
ThemeData buildAppTheme() {
  return ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    scaffoldBackgroundColor: AppColors.bg,
    colorScheme: ColorScheme.fromSeed(
      seedColor: AppColors.primary,
      brightness: Brightness.dark,
      primary: AppColors.primary,
      surface: AppColors.surface,
    ),
    textTheme: Typography.whiteMountainView.apply(
      bodyColor: AppColors.textPrimary,
      displayColor: AppColors.textPrimary,
    ),
    snackBarTheme: const SnackBarThemeData(
      backgroundColor: AppColors.surfaceRaised,
      contentTextStyle: TextStyle(color: AppColors.textPrimary),
      behavior: SnackBarBehavior.floating,
    ),
  );
}