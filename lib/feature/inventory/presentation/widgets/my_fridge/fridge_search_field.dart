import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fridgy/core/constants/app_assets.dart';
import 'package:fridgy/core/constants/locale_keys.dart';
import 'package:fridgy/core/theme/styles/app_colors.dart';
import 'package:fridgy/core/theme/styles/app_text_styles.dart';

class FridgeSearchField extends StatelessWidget {
  const FridgeSearchField({
    required this.controller,
    required this.onChanged,
    super.key,
  });

  final TextEditingController controller;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 48,
      padding: const EdgeInsetsDirectional.symmetric(horizontal: 14),
      decoration: BoxDecoration(
        color: AppColors.backgroundSecondary,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          SvgPicture.asset(AppAssets.icSearch, width: 20, height: 20),
          const SizedBox(width: 10),
          Expanded(
            child: TextField(
              controller: controller,
              onChanged: onChanged,
              textInputAction: TextInputAction.search,
              style: AppTextStyles.fieldValueRegular14,
              cursorColor: AppColors.brandPrimary,
              decoration: InputDecoration(
                isCollapsed: true,
                border: InputBorder.none,
                hintText: LocaleKeys.searchFoodHint.tr(),
                hintStyle: AppTextStyles.secondaryBodyRegular14Text,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
