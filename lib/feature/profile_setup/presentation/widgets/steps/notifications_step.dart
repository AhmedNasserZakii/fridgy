import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:fridgy/core/constants/app_assets.dart';
import 'package:fridgy/core/constants/locale_keys.dart';
import 'package:fridgy/feature/profile_setup/presentation/widgets/benefit_row.dart';
import 'package:fridgy/feature/profile_setup/presentation/widgets/setup_illustration.dart';
import 'package:fridgy/feature/profile_setup/presentation/widgets/step_intro.dart';

class NotificationsStep extends StatelessWidget {
  const NotificationsStep({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(24, 12, 24, 24),
      children: [
        const SetupIllustration(
          assetPath: AppAssets.setupNotifications,
          height: 210,
        ),
        const SizedBox(height: 24),
        StepIntro(
          title: LocaleKeys.notificationsTitle.tr(),
          subtitle: LocaleKeys.notificationsSubtitle.tr(),
          centered: true,
        ),
        const SizedBox(height: 24),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18),
          child: Column(
            children: [
              BenefitRow(
                iconAsset: AppAssets.icBellRing,
                label: LocaleKeys.benefitExpiry.tr(),
              ),
              const SizedBox(height: 8),
              BenefitRow(
                iconAsset: AppAssets.icChefHat,
                label: LocaleKeys.benefitRecipes.tr(),
              ),
              const SizedBox(height: 8),
              BenefitRow(
                iconAsset: AppAssets.icBasket,
                label: LocaleKeys.benefitShopping.tr(),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
