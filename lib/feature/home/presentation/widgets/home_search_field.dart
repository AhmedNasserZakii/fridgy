import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fridgy/core/constants/app_assets.dart';
import 'package:fridgy/core/constants/locale_keys.dart';
import 'package:fridgy/core/theme/styles/app_colors.dart';
import 'package:fridgy/core/theme/styles/app_text_styles.dart';

class HomeSearchField extends StatelessWidget {
  const HomeSearchField({required this.onTap, super.key});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.backgroundSecondary,
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: SizedBox(
          height: 48,
          child: Padding(
            padding: const EdgeInsetsDirectional.symmetric(horizontal: 14),
            child: Row(
              children: [
                SvgPicture.asset(AppAssets.icSearch, width: 20, height: 20),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    LocaleKeys.searchFoodHint.tr(),
                    style: AppTextStyles.secondaryBodyRegular14Text,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
