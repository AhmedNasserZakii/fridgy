import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:fridgy/core/constants/locale_keys.dart';
import 'package:fridgy/core/shared_widgets/primary_button.dart';
import 'package:fridgy/core/theme/styles/app_colors.dart';
import 'package:fridgy/core/theme/styles/app_text_styles.dart';
import 'package:fridgy/feature/fridge_ai/domain/entities/proposed_item_entity.dart';

class FridgeAiProposedItemsCard extends StatelessWidget {
  const FridgeAiProposedItemsCard({
    required this.items,
    required this.onConfirm,
    required this.isLoading,
    super.key,
  });

  final List<ProposedItemEntity> items;
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
          Text(
            LocaleKeys.fridgeAiProposedItemsTitle.tr(),
            style: AppTextStyles.bodySemiBold17Primary,
          ),
          const SizedBox(height: 12),
          for (final item in items) ...[
            Text(_line(item), style: AppTextStyles.secondaryBodyRegular15),
            const SizedBox(height: 8),
          ],
          const SizedBox(height: 4),
          PrimaryButton(
            label: LocaleKeys.fridgeAiConfirmAdd.tr(),
            onPressed: isLoading ? null : onConfirm,
            isLoading: isLoading,
          ),
        ],
      ),
    );
  }

  String _line(ProposedItemEntity item) {
    final unit = item.unit?.name;
    final qty = item.quantity;
    final qtyText = qty == null
        ? '?'
        : (qty % 1 == 0 ? qty.toInt().toString() : qty.toString());
    final amount = unit == null ? qtyText : '$qtyText $unit';
    final expiry = item.expiresAt == null
        ? ''
        : ' · ${item.expiresAt!.toIso8601String().substring(0, 10)}';
    return '${item.name} — $amount$expiry';
  }
}
