import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:fridgy/core/constants/locale_keys.dart';
import 'package:fridgy/core/shared_widgets/primary_button.dart';
import 'package:fridgy/core/theme/styles/app_colors.dart';
import 'package:fridgy/core/theme/styles/app_text_styles.dart';
import 'package:fridgy/feature/fridge_ai/domain/entities/proposed_consumption_entity.dart';
import 'package:fridgy/feature/fridge_ai/domain/entities/recipe_suggestion_entity.dart';

class FridgeAiProposedConsumptionsCard extends StatelessWidget {
  const FridgeAiProposedConsumptionsCard({
    required this.consumptions,
    required this.recipes,
    required this.onConfirm,
    required this.isLoading,
    super.key,
  });

  final List<ProposedConsumptionEntity> consumptions;
  final List<RecipeSuggestionEntity> recipes;
  final VoidCallback onConfirm;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surfaceDefault,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.borderDefault),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (consumptions.isNotEmpty) ...[
            Text(
              LocaleKeys.fridgeAiProposedConsumptionsTitle.tr(),
              style: AppTextStyles.bodySemiBold17Primary,
            ),
            const SizedBox(height: 12),
            for (final item in consumptions) ...[
              Text(_line(item), style: AppTextStyles.secondaryBodyRegular15),
              const SizedBox(height: 8),
            ],
          ],
          if (recipes.isNotEmpty) ...[
            const SizedBox(height: 8),
            Text(
              LocaleKeys.fridgeAiRecipesTitle.tr(),
              style: AppTextStyles.bodySemiBold17Primary,
            ),
            const SizedBox(height: 12),
            for (final recipe in recipes) ...[
              Text(recipe.title, style: AppTextStyles.secondaryBodySemiBold14),
              const SizedBox(height: 4),
              Text(
                recipe.description,
                style: AppTextStyles.secondaryBodyRegular15,
              ),
              const SizedBox(height: 10),
            ],
          ],
          if (consumptions.isNotEmpty) ...[
            const SizedBox(height: 4),
            PrimaryButton(
              label: LocaleKeys.fridgeAiConfirmConsume.tr(),
              onPressed: isLoading ? null : onConfirm,
              isLoading: isLoading,
            ),
          ],
        ],
      ),
    );
  }

  String _line(ProposedConsumptionEntity item) {
    final unit = item.unit?.name;
    final qty = item.quantity % 1 == 0
        ? item.quantity.toInt().toString()
        : item.quantity.toString();
    final amount = unit == null ? qty : '$qty $unit';
    return '${item.name} — $amount';
  }
}
