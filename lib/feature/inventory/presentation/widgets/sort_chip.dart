import 'package:flutter/material.dart';
import 'package:fridgy/core/theme/styles/app_colors.dart';
import 'package:fridgy/core/theme/styles/app_text_styles.dart';

/// Non-tappable chip showing the current sort (only `expiry_asc` exists, D14).
class SortChip extends StatelessWidget {
  const SortChip({required this.label, super.key});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 32,
      alignment: Alignment.center,
      padding: const EdgeInsetsDirectional.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: AppColors.surfaceAccent,
        borderRadius: BorderRadius.circular(99),
      ),
      child: Text(label, style: AppTextStyles.captionSemiBold12Brand),
    );
  }
}
