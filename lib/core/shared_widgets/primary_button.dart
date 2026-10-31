import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fridgy/core/theme/styles/app_colors.dart';
import 'package:fridgy/core/theme/styles/app_text_styles.dart';

class PrimaryButton extends StatelessWidget {
  const PrimaryButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.trailingIcon,
    this.isLoading = false,
    this.isStroked = false,
  });

  final String label;
  final VoidCallback? onPressed;
  final String? trailingIcon;
  final bool isLoading;
  final bool isStroked;

  @override
  Widget build(BuildContext context) {
    final enabled = onPressed != null && !isLoading;
    final foreground = isStroked
        ? AppColors.brandPrimary
        : AppColors.textInverse;

    return SizedBox(
      width: double.infinity,
      height: 52,
      child: ElevatedButton(
        onPressed: enabled ? onPressed : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: isStroked
              ? AppColors.surfaceDefault
              : AppColors.brandPrimary,
          disabledBackgroundColor: isStroked
              ? AppColors.surfaceDefault
              : AppColors.brandPrimary.withValues(alpha: 0.6),
          foregroundColor: foreground,
          disabledForegroundColor: foreground.withValues(alpha: 0.6),
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: isStroked
                ? const BorderSide(color: AppColors.brandPrimary)
                : BorderSide.none,
          ),
        ),
        child: isLoading
            ? SizedBox(
                width: 22,
                height: 22,
                child: CircularProgressIndicator(
                  strokeWidth: 2.5,
                  color: foreground,
                ),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    label,
                    style: isStroked
                        ? AppTextStyles.bodySemiBold16Brand
                        : AppTextStyles.bodySemiBold16,
                  ),
                  if (trailingIcon != null) ...[
                    const SizedBox(width: 8),
                    SvgPicture.asset(
                      trailingIcon!,
                      width: 20,
                      height: 20,
                      colorFilter: ColorFilter.mode(
                        foreground,
                        BlendMode.srcIn,
                      ),
                    ),
                  ],
                ],
              ),
      ),
    );
  }
}
