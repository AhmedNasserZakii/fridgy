import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fridgy/core/constants/app_assets.dart';
import 'package:fridgy/core/constants/locale_keys.dart';
import 'package:fridgy/core/theme/styles/app_colors.dart';
import 'package:fridgy/core/theme/styles/app_text_styles.dart';

class SetupHeader extends StatelessWidget {
  const SetupHeader({
    super.key,
    required this.stepNumber,
    required this.showBack,
    required this.onBack,
    this.totalSteps = 7,
  });

  final int stepNumber;
  final int totalSteps;
  final bool showBack;
  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 60,
      child: Row(
        children: [
          SizedBox(
            width: 24,
            height: 24,
            child: showBack
                ? IconButton(
                    onPressed: onBack,
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints.tightFor(
                      width: 24,
                      height: 24,
                    ),
                    icon: SvgPicture.asset(
                      AppAssets.icChevronLeft,
                      width: 24,
                      height: 24,
                    ),
                  )
                : const SizedBox.shrink(),
          ),
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: AppColors.brandPrimary,
                    borderRadius: BorderRadius.circular(9),
                  ),
                  alignment: Alignment.center,
                  child: SvgPicture.asset(
                    AppAssets.logoMark,
                    width: 26,
                    height: 27,
                    colorFilter: const ColorFilter.mode(
                      AppColors.textInverse,
                      BlendMode.srcIn,
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                const Text('FRIDGY', style: AppTextStyles.titleExtraBold20),
              ],
            ),
          ),
          Text(
            LocaleKeys.stepCounterDynamic.tr(
              args: [
                stepNumber.toString().padLeft(2, '0'),
                totalSteps.toString().padLeft(2, '0'),
              ],
            ),
            style: AppTextStyles.metadataMedium13.copyWith(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: AppColors.textHint,
            ),
          ),
        ],
      ),
    );
  }
}
