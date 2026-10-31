import 'package:flutter/material.dart';
import 'package:fridgy/core/theme/styles/app_colors.dart';

abstract class AppTextStyles {
  static const TextStyle displayExtraBold34 = TextStyle(
    fontSize: 34,
    fontWeight: FontWeight.w800,
    height: 1.13,
    color: AppColors.textPrimary,
  );

  static const TextStyle headlineBold34 = TextStyle(
    fontSize: 34,
    fontWeight: FontWeight.w700,
    height: 1.4,
    color: AppColors.textPrimary,
  );

  static const TextStyle headlineBold30 = TextStyle(
    fontSize: 30,
    fontWeight: FontWeight.w700,
    height: 1.4,
    color: AppColors.textPrimary,
  );

  static const TextStyle titleExtraBold20 = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w800,
    height: 1.4,
    color: AppColors.textPrimary,
  );

  static const TextStyle titleRegular20 = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w400,
    height: 1.4,
    color: AppColors.textSecondary,
  );

  static const TextStyle bodySemiBold16 = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    height: 1.4,
    color: AppColors.textInverse,
  );

  static const TextStyle bodyRegular16 = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    height: 1.4,
    color: AppColors.textSecondary,
  );

  static const TextStyle bodySemiBold16Brand = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    height: 1.0,
    color: AppColors.brandPrimary,
  );

  static const TextStyle secondaryBodyRegular14 = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    height: 1.4,
    color: AppColors.brandPrimary,
  );

  static const TextStyle metadataMedium13 = TextStyle(
    fontSize: 13,
    fontWeight: FontWeight.w500,
    height: 1.0,
    color: AppColors.textSecondary,
  );
}
