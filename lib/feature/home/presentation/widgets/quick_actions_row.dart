import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:fridgy/core/constants/app_assets.dart';
import 'package:fridgy/core/constants/locale_keys.dart';
import 'package:fridgy/core/shared_widgets/app_snack_bar.dart';
import 'package:fridgy/feature/home/presentation/widgets/quick_action_item.dart';

class QuickActionsRow extends StatelessWidget {
  const QuickActionsRow({super.key});

  @override
  Widget build(BuildContext context) {
    void comingSoon() => AppSnackBar.show(context, LocaleKeys.comingSoon.tr());

    return Row(
      children: [
        QuickActionItem(
          iconAsset: AppAssets.icScanLine,
          label: LocaleKeys.scanFood.tr(),
          onTap: comingSoon,
        ),
        const SizedBox(width: 8),
        QuickActionItem(
          iconAsset: AppAssets.icPlus,
          label: LocaleKeys.addItem.tr(),
          onTap: comingSoon,
        ),
        const SizedBox(width: 8),
        QuickActionItem(
          iconAsset: AppAssets.icSparkles,
          label: LocaleKeys.cookWithAi.tr(),
          onTap: comingSoon,
        ),
        const SizedBox(width: 8),
        QuickActionItem(
          iconAsset: AppAssets.icCalendarDays,
          label: LocaleKeys.mealPlanner.tr(),
          onTap: comingSoon,
        ),
      ],
    );
  }
}
