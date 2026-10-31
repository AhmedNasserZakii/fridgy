import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fridgy/core/constants/app_assets.dart';
import 'package:fridgy/core/theme/styles/app_colors.dart';
import 'package:fridgy/core/theme/styles/app_text_styles.dart';

class FoodFormSelectField extends StatelessWidget {
  const FoodFormSelectField({
    super.key,
    required this.label,
    required this.valueText,
    required this.hint,
    required this.onTap,
    this.errorText,
  });

  final String label;
  final String valueText;
  final String hint;
  final VoidCallback onTap;
  final String? errorText;

  @override
  Widget build(BuildContext context) {
    final hasError = errorText != null && errorText!.isNotEmpty;
    final borderColor = hasError ? AppColors.error : AppColors.borderInput;
    final display = valueText.isEmpty ? hint : valueText;
    final valueStyle = valueText.isEmpty
        ? AppTextStyles.fieldHintRegular14
        : AppTextStyles.fieldValueRegular14;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: AppTextStyles.fieldLabelSemiBold14),
        const SizedBox(height: 8),
        Material(
          color: AppColors.surfaceDefault,
          borderRadius: BorderRadius.circular(12),
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(12),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: borderColor),
              ),
              child: Row(
                children: [
                  Expanded(child: Text(display, style: valueStyle)),
                  SvgPicture.asset(
                    AppAssets.icChevronDown,
                    width: 20,
                    height: 20,
                  ),
                ],
              ),
            ),
          ),
        ),
        if (hasError) ...[
          const SizedBox(height: 6),
          Text(errorText!, style: AppTextStyles.errorCaptionRegular12),
        ],
      ],
    );
  }
}
