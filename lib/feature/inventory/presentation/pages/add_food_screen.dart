import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:fridgy/core/constants/app_assets.dart';
import 'package:fridgy/core/constants/locale_keys.dart';
import 'package:fridgy/core/shared_widgets/app_snack_bar.dart';
import 'package:fridgy/core/shared_widgets/back_title_header.dart';
import 'package:fridgy/core/theme/styles/app_colors.dart';
import 'package:fridgy/core/theme/styles/app_text_styles.dart';
import 'package:fridgy/core/utils/app_route.dart';
import 'package:fridgy/feature/inventory/presentation/widgets/food_flow/add_option_card.dart';
import 'package:fridgy/feature/inventory/presentation/widgets/food_flow/guidance_box.dart';

class AddFoodScreen extends StatelessWidget {
  const AddFoodScreen({super.key});

  @override
  Widget build(BuildContext context) {
    void comingSoon() => AppSnackBar.show(context, LocaleKeys.comingSoon.tr());

    return Scaffold(
      backgroundColor: AppColors.surfaceDefault,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsetsDirectional.symmetric(horizontal: 20),
              child: BackTitleHeader(title: LocaleKeys.addFoodTitle.tr()),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsetsDirectional.fromSTEB(20, 8, 20, 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      LocaleKeys.whatsGoingIn.tr(),
                      style: AppTextStyles.headlineBold30,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      LocaleKeys.whatsGoingInSubtitle.tr(),
                      style: AppTextStyles.titleRegular20,
                    ),
                    const SizedBox(height: 20),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: Image.asset(
                        AppAssets.addFoodHero,
                        height: 200,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),
                    ),
                    const SizedBox(height: 20),
                    AddOptionCard(
                      iconAsset: AppAssets.icScanLine,
                      title: LocaleKeys.scanFood.tr(),
                      subtitle: LocaleKeys.scanFoodSubtitle.tr(),
                      accentBackground: true,
                      onTap: comingSoon,
                    ),
                    const SizedBox(height: 12),
                    AddOptionCard(
                      iconAsset: AppAssets.icCamera,
                      title: LocaleKeys.takePhoto.tr(),
                      subtitle: LocaleKeys.takePhotoSubtitle.tr(),
                      onTap: comingSoon,
                    ),
                    const SizedBox(height: 12),
                    AddOptionCard(
                      iconAsset: AppAssets.icPlus,
                      title: LocaleKeys.addManually.tr(),
                      subtitle: LocaleKeys.addManuallySubtitle.tr(),
                      onTap: () => Navigator.of(context)
                          .pushNamed(AppRoute.addFoodManual),
                    ),
                    const SizedBox(height: 20),
                    GuidanceBox(text: LocaleKeys.addFoodGuidance.tr()),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
