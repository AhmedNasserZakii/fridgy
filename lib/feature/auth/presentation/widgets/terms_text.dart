import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:fridgy/core/constants/locale_keys.dart';
import 'package:fridgy/core/theme/styles/app_colors.dart';
import 'package:fridgy/core/theme/styles/app_text_styles.dart';

class TermsText extends StatelessWidget {
  const TermsText({super.key});

  @override
  Widget build(BuildContext context) {
    // TODO(legal-urls): make Terms of Use / Privacy Policy tappable when URLs exist.
    return Text.rich(
      TextSpan(
        style: AppTextStyles.captionRegular12,
        children: [
          TextSpan(text: LocaleKeys.termsPrefix.tr()),
          TextSpan(
            text: LocaleKeys.termsOfUse.tr(),
            style: AppTextStyles.captionRegular12.copyWith(
              color: AppColors.brandPrimary,
              fontWeight: FontWeight.w600,
            ),
          ),
          TextSpan(text: LocaleKeys.termsAnd.tr()),
          TextSpan(
            text: LocaleKeys.privacyPolicy.tr(),
            style: AppTextStyles.captionRegular12.copyWith(
              color: AppColors.brandPrimary,
              fontWeight: FontWeight.w600,
            ),
          ),
          TextSpan(text: LocaleKeys.termsSuffix.tr()),
        ],
      ),
    );
  }
}
