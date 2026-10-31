import 'package:flutter/material.dart';
import 'package:fridgy/core/theme/styles/app_colors.dart';
import 'package:fridgy/core/theme/styles/app_text_styles.dart';

class NumberChoiceChip extends StatelessWidget {
  const NumberChoiceChip({
    super.key,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          height: 56,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: selected ? AppColors.brandPrimary : AppColors.surfaceDefault,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: selected ? AppColors.brandPrimary : AppColors.borderInput,
            ),
          ),
          child: Text(
            label,
            style: AppTextStyles.secondaryBodySemiBold14.copyWith(
              fontSize: 18,
              color: selected ? AppColors.textInverse : AppColors.textPrimary,
            ),
          ),
        ),
      ),
    );
  }
}
