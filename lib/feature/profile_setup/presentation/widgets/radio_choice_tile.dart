import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fridgy/core/theme/styles/app_colors.dart';
import 'package:fridgy/core/theme/styles/app_text_styles.dart';

enum RadioChoiceVariant { compact, emoji, iconSubtitle }

class RadioChoiceTile extends StatelessWidget {
  const RadioChoiceTile({
    super.key,
    required this.label,
    required this.selected,
    required this.onTap,
    this.variant = RadioChoiceVariant.compact,
    this.emoji,
    this.subtitle,
    this.iconAsset,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;
  final RadioChoiceVariant variant;
  final String? emoji;
  final String? subtitle;
  final String? iconAsset;

  @override
  Widget build(BuildContext context) {
    final height = switch (variant) {
      RadioChoiceVariant.compact => 56.0,
      RadioChoiceVariant.emoji => 72.0,
      RadioChoiceVariant.iconSubtitle => 72.0,
    };

    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: height,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          color: selected ? AppColors.brandLight : AppColors.surfaceDefault,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: selected ? AppColors.brandPrimary : AppColors.borderStrong,
            width: selected ? 1.5 : 1,
          ),
        ),
        child: Row(
          children: [
            if (variant == RadioChoiceVariant.emoji && emoji != null) ...[
              Text(emoji!, style: const TextStyle(fontSize: 26)),
              const SizedBox(width: 12),
            ],
            if (variant == RadioChoiceVariant.iconSubtitle &&
                iconAsset != null) ...[
              SvgPicture.asset(iconAsset!, width: 24, height: 24),
              const SizedBox(width: 12),
            ],
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: AppTextStyles.secondaryBodySemiBold14.copyWith(
                      fontSize: variant == RadioChoiceVariant.compact ? 13 : 15,
                      color: variant == RadioChoiceVariant.compact
                          ? AppColors.brandPrimary
                          : AppColors.textFieldLabel,
                    ),
                  ),
                  if (subtitle != null) ...[
                    const SizedBox(height: 2),
                    Text(
                      subtitle!,
                      style: AppTextStyles.captionRegular12.copyWith(
                        color: AppColors.textHint,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            _RadioDot(selected: selected),
          ],
        ),
      ),
    );
  }
}

class _RadioDot extends StatelessWidget {
  const _RadioDot({required this.selected});

  final bool selected;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 20,
      height: 20,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: selected ? AppColors.brandPrimary : AppColors.surfaceDefault,
        border: Border.all(
          color: selected ? AppColors.brandPrimary : AppColors.borderStrong,
          width: 1.5,
        ),
      ),
      child: selected
          ? Center(
              child: Container(
                width: 8,
                height: 8,
                decoration: const BoxDecoration(
                  color: AppColors.textInverse,
                  shape: BoxShape.circle,
                ),
              ),
            )
          : null,
    );
  }
}
