import 'package:flutter/material.dart';
import 'package:fridgy/core/theme/styles/app_colors.dart';
import 'package:fridgy/core/theme/styles/app_text_styles.dart';

class FilterChipText extends StatelessWidget {
  const FilterChipText({
    required this.label,
    required this.selected,
    required this.onTap,
    super.key,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final style = selected
        ? AppTextStyles.bodySemiBold16Brand.copyWith(
            decoration: TextDecoration.underline,
            decorationColor: AppColors.brandPrimary,
            decorationThickness: 2,
          )
        : AppTextStyles.bodyRegular16;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsetsDirectional.symmetric(
          horizontal: 4,
          vertical: 8,
        ),
        child: Text(label, style: style),
      ),
    );
  }
}
