import 'package:flutter/material.dart';
import 'package:fridgy/core/theme/styles/app_colors.dart';
import 'package:fridgy/core/theme/styles/app_text_styles.dart';

class FridgeAiSoftButton extends StatelessWidget {
  const FridgeAiSoftButton({
    required this.label,
    required this.onPressed,
    super.key,
  });

  final String label;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.surfaceAccent,
          foregroundColor: AppColors.brandPrimary,
          disabledBackgroundColor: AppColors.surfaceAccent.withValues(
            alpha: 0.6,
          ),
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        child: Text(
          label,
          style: AppTextStyles.bodySemiBold16.copyWith(
            color: AppColors.brandPrimary,
          ),
        ),
      ),
    );
  }
}
