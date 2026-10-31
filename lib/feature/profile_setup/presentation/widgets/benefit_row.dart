import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fridgy/core/theme/styles/app_colors.dart';
import 'package:fridgy/core/theme/styles/app_text_styles.dart';

class BenefitRow extends StatelessWidget {
  const BenefitRow({super.key, required this.iconAsset, required this.label});

  final String iconAsset;
  final String label;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 44,
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: AppColors.brandLight,
              borderRadius: BorderRadius.circular(14),
            ),
            alignment: Alignment.center,
            child: SvgPicture.asset(iconAsset, width: 19, height: 19),
          ),
          const SizedBox(width: 14),
          Text(
            label,
            style: AppTextStyles.secondaryBodySemiBold14.copyWith(
              fontSize: 15,
              fontWeight: FontWeight.w500,
              color: AppColors.textFieldLabel,
            ),
          ),
        ],
      ),
    );
  }
}
