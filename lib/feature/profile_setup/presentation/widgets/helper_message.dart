import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fridgy/core/constants/app_assets.dart';
import 'package:fridgy/core/theme/styles/app_colors.dart';
import 'package:fridgy/core/theme/styles/app_text_styles.dart';

class HelperMessage extends StatelessWidget {
  const HelperMessage({super.key, required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SvgPicture.asset(
          AppAssets.icInfo,
          width: 15,
          height: 15,
          colorFilter: const ColorFilter.mode(
            AppColors.brandPrimary,
            BlendMode.srcIn,
          ),
        ),
        const SizedBox(width: 7),
        Expanded(
          child: Text(
            message,
            style: AppTextStyles.captionRegular12.copyWith(
              height: 1.5,
              color: AppColors.textHint,
            ),
          ),
        ),
      ],
    );
  }
}
