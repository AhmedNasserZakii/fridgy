import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fridgy/core/constants/app_assets.dart';
import 'package:fridgy/core/constants/locale_keys.dart';
import 'package:fridgy/core/shared_widgets/primary_button.dart';
import 'package:fridgy/core/theme/styles/app_colors.dart';
import 'package:fridgy/core/theme/styles/app_text_styles.dart';
import 'package:fridgy/feature/fridge_ai/domain/entities/fridge_ai_mode.dart';
import 'package:fridgy/feature/fridge_ai/domain/entities/proposed_item_entity.dart';
import 'package:fridgy/feature/fridge_ai/presentation/widgets/fridge_ai_soft_button.dart';
import 'package:fridgy/feature/fridge_ai/presentation/widgets/fridge_ai_success_item_row.dart';

class FridgeAiSuccessContent extends StatelessWidget {
  const FridgeAiSuccessContent({
    required this.mode,
    required this.items,
    required this.onViewFridge,
    required this.onContinue,
    super.key,
  });

  final FridgeAiMode mode;
  final List<ProposedItemEntity> items;
  final VoidCallback onViewFridge;
  final VoidCallback onContinue;

  @override
  Widget build(BuildContext context) {
    final isAdd = mode == FridgeAiMode.addFood;
    final heading = isAdd
        ? LocaleKeys.fridgeAiSuccessHeadingAdd.tr()
        : LocaleKeys.fridgeAiSuccessHeadingUse.tr();
    final continueLabel = isAdd
        ? LocaleKeys.fridgeAiSuccessAddMore.tr()
        : LocaleKeys.fridgeAiSuccessUseMore.tr();
    final support = isAdd
        ? LocaleKeys.fridgeAiSuccessSupportAdd.tr(
            args: ['${items.length}'],
          )
        : LocaleKeys.fridgeAiSuccessSupportUse.tr(
            args: ['${items.length}'],
          );

    return SingleChildScrollView(
      padding: const EdgeInsetsDirectional.fromSTEB(20, 10, 20, 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: 8),
          Center(
            child: Container(
              width: 64,
              height: 64,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: AppColors.surfaceAccent,
                borderRadius: BorderRadius.circular(32),
              ),
              child: SvgPicture.asset(
                AppAssets.icCheck,
                width: 32,
                height: 32,
                colorFilter: const ColorFilter.mode(
                  AppColors.brandPrimary,
                  BlendMode.srcIn,
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text(heading, style: AppTextStyles.titleBold28),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.surfaceDefault,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: AppColors.borderDefault),
            ),
            child: Column(
              children: [
                for (var i = 0; i < items.length; i++) ...[
                  if (i > 0) const SizedBox(height: 14),
                  FridgeAiSuccessItemRow(item: items[i]),
                ],
              ],
            ),
          ),
          const SizedBox(height: 16),
          PrimaryButton(
            label: LocaleKeys.fridgeAiSuccessViewFridge.tr(),
            onPressed: onViewFridge,
          ),
          const SizedBox(height: 12),
          FridgeAiSoftButton(label: continueLabel, onPressed: onContinue),
          const SizedBox(height: 12),
          Text(support, style: AppTextStyles.metadataMedium13),
        ],
      ),
    );
  }
}
