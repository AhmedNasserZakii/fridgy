import 'package:flutter/material.dart';
import 'package:fridgy/core/theme/styles/app_colors.dart';
import 'package:fridgy/core/theme/styles/app_text_styles.dart';
import 'package:fridgy/feature/fridge_ai/domain/entities/proposed_item_entity.dart';
import 'package:fridgy/feature/inventory/domain/entities/food_category.dart';
import 'package:fridgy/feature/inventory/presentation/utils/food_item_formatters.dart';

class FridgeAiSuccessItemRow extends StatelessWidget {
  const FridgeAiSuccessItemRow({required this.item, super.key});

  final ProposedItemEntity item;

  @override
  Widget build(BuildContext context) {
    final qty = item.quantity;
    final qtyText = qty == null
        ? '—'
        : (qty == qty.roundToDouble() || qty is int
            ? qty.round().toString()
            : qty.toString());
    final unit = FoodItemFormatters.unitLabel(item.unit);
    final amount = unit.isEmpty ? qtyText : '$qtyText $unit';

    return Row(
      children: [
        Container(
          width: 44,
          height: 44,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: AppColors.surfaceAccent,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            item.emoji ?? _emojiFor(item.category),
            style: const TextStyle(fontSize: 22),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(item.name, style: AppTextStyles.bodySemiBold17Primary),
        ),
        Text(amount, style: AppTextStyles.bodyRegular16Primary),
      ],
    );
  }

  String _emojiFor(FoodCategory? category) {
    switch (category) {
      case FoodCategory.dairy:
        return '🥛';
      case FoodCategory.vegetables:
        return '🥕';
      case FoodCategory.fruits:
        return '🍎';
      case FoodCategory.meat:
        return '🍗';
      case FoodCategory.bakery:
        return '🍞';
      case FoodCategory.other:
      case null:
        return '🥗';
    }
  }
}
