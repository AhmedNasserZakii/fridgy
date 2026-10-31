import 'package:flutter/material.dart';
import 'package:fridgy/core/theme/styles/app_colors.dart';

abstract class AppTheme {
  static ThemeData light() {
    return ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: AppColors.surfaceDefault,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.brandPrimary,
        primary: AppColors.brandPrimary,
        surface: AppColors.surfaceDefault,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.surfaceDefault,
        elevation: 0,
        scrolledUnderElevation: 0,
      ),
    );
  }
}
