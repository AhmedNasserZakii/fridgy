import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:fridgy/core/constants/app_assets.dart';
import 'package:fridgy/core/constants/locale_keys.dart';
import 'package:fridgy/core/shared_widgets/app_snack_bar.dart';
import 'package:fridgy/core/shared_widgets/back_title_header.dart';
import 'package:fridgy/core/theme/styles/app_colors.dart';
import 'package:fridgy/core/theme/styles/app_text_styles.dart';
import 'package:fridgy/feature/more/presentation/widgets/context_guidance_box.dart';
import 'package:fridgy/feature/more/presentation/widgets/settings_list_row.dart';

class PrivacyScreen extends StatelessWidget {
  const PrivacyScreen({super.key});

  void _comingSoon(BuildContext context) {
    AppSnackBar.show(context, LocaleKeys.comingSoon.tr());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surfaceDefault,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: BackTitleHeader(title: LocaleKeys.privacyAndData.tr()),
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
                children: [
                  Text(
                    LocaleKeys.privacyHeadline.tr(),
                    style: AppTextStyles.titleBold26,
                  ),
                  const SizedBox(height: 16),
                  ContextGuidanceBox(message: LocaleKeys.privacyDemoNote.tr()),
                  const SizedBox(height: 16),
                  Text(
                    LocaleKeys.sharedWithHousehold.tr(),
                    style: AppTextStyles.titleBold20,
                  ),
                  const SizedBox(height: 16),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.backgroundSecondary,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          LocaleKeys.sharedWithHouseholdBody.tr(),
                          style: AppTextStyles.secondaryBodyRegular14Text
                              .copyWith(color: AppColors.textPrimary),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          LocaleKeys.sharedWithHouseholdNote.tr(),
                          style: AppTextStyles.secondaryBodyRegular14Text,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),
                  SettingsListRow(
                    iconAsset: AppAssets.icUsers,
                    title: LocaleKeys.manageHouseholdAccess.tr(),
                    subtitle: LocaleKeys.manageHouseholdAccessSubtitle.tr(),
                    onTap: () => _comingSoon(context),
                  ),
                  SettingsListRow(
                    iconAsset: AppAssets.icDownload,
                    title: LocaleKeys.exportMyData.tr(),
                    subtitle: LocaleKeys.exportMyDataSubtitle.tr(),
                    onTap: () => _comingSoon(context),
                  ),
                  SettingsListRow(
                    iconAsset: AppAssets.icTrash,
                    title: LocaleKeys.deleteMyData.tr(),
                    subtitle: LocaleKeys.deleteMyDataSubtitle.tr(),
                    onTap: () => _comingSoon(context),
                  ),
                  SettingsListRow(
                    iconAsset: AppAssets.icFileText,
                    title: LocaleKeys.privacyPolicy.tr(),
                    subtitle: LocaleKeys.privacyPolicySubtitle.tr(),
                    onTap: () => _comingSoon(context),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    LocaleKeys.privacyFooterNote.tr(),
                    style: AppTextStyles.captionRegular12,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
