import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fridgy/core/constants/app_assets.dart';
import 'package:fridgy/core/constants/locale_keys.dart';
import 'package:fridgy/core/theme/styles/app_colors.dart';
import 'package:fridgy/core/theme/styles/app_text_styles.dart';

class PhotoFieldRow extends StatelessWidget {
  const PhotoFieldRow({super.key, required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          LocaleKeys.addOrChangePhoto.tr(),
          style: AppTextStyles.fieldLabelSemiBold14,
        ),
        const SizedBox(height: 8),
        Material(
          color: AppColors.backgroundSecondary,
          borderRadius: BorderRadius.circular(12),
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(12),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              child: Row(
                children: [
                  SvgPicture.asset(AppAssets.icCamera, width: 24, height: 24),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      LocaleKeys.addOrChangePhoto.tr(),
                      style: AppTextStyles.fieldValueRegular14,
                    ),
                  ),
                  SvgPicture.asset(
                    AppAssets.icChevronRight,
                    width: 20,
                    height: 20,
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
