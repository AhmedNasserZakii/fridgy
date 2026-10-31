import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fridgy/core/constants/app_assets.dart';
import 'package:fridgy/core/constants/locale_keys.dart';
import 'package:fridgy/core/shared_widgets/app_snack_bar.dart';
import 'package:fridgy/core/shared_widgets/primary_button.dart';
import 'package:fridgy/core/theme/styles/app_text_styles.dart';
import 'package:fridgy/feature/inventory/presentation/widgets/my_fridge/fridge_empty_action_row.dart';

class FridgeEmptyView extends StatelessWidget {
  const FridgeEmptyView({required this.onAddTap, super.key});

  final VoidCallback onAddTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 24),
        SvgPicture.asset(AppAssets.icRefrigerator, width: 56, height: 56),
        const SizedBox(height: 16),
        Text(
          LocaleKeys.fridgeEmptyTitle.tr(),
          style: AppTextStyles.titleBold20,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 8),
        Text(
          LocaleKeys.fridgeEmptySubtitle.tr(),
          style: AppTextStyles.secondaryBodyRegular14Text,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 24),
        FridgeEmptyActionRow(
          iconAsset: AppAssets.icScanLine,
          title: LocaleKeys.scanFood.tr(),
          subtitle: LocaleKeys.scanFoodEmptySubtitle.tr(),
          onTap: () => AppSnackBar.show(context, LocaleKeys.comingSoon.tr()),
        ),
        const SizedBox(height: 12),
        FridgeEmptyActionRow(
          iconAsset: AppAssets.icPencil,
          title: LocaleKeys.addManually.tr(),
          subtitle: LocaleKeys.addManuallyEmptySubtitle.tr(),
          onTap: onAddTap,
        ),
        const Spacer(),
        PrimaryButton(
          label: LocaleKeys.addYourFirstItem.tr(),
          onPressed: onAddTap,
        ),
      ],
    );
  }
}
