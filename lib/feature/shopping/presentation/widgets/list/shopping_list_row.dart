import 'package:flutter/material.dart';
import 'package:fridgy/core/shared_widgets/custom_network_image.dart';
import 'package:fridgy/core/theme/styles/app_colors.dart';
import 'package:fridgy/core/theme/styles/app_text_styles.dart';
import 'package:fridgy/feature/inventory/presentation/utils/food_item_formatters.dart';
import 'package:fridgy/feature/shopping/domain/entities/shopping_list_item_entity.dart';

class ShoppingListRow extends StatelessWidget {
  const ShoppingListRow({
    required this.item,
    required this.onToggle,
    required this.onDelete,
    super.key,
  });

  final ShoppingListItemEntity item;
  final VoidCallback onToggle;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final qty = item.quantity == item.quantity.roundToDouble()
        ? '${item.quantity.round()}'
        : '${item.quantity}';
    final unit = FoodItemFormatters.unitLabel(item.unit);
    final subtitle = unit.isEmpty ? qty : '$qty $unit';

    return Material(
      color: AppColors.surfaceDefault,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        onTap: onToggle,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.borderDefault),
          ),
          child: Row(
            children: [
              Checkbox(
                value: item.isChecked,
                onChanged: (_) => onToggle(),
                activeColor: AppColors.brandPrimary,
              ),
              CustomNetworkImage(
                imageUrl: item.imageUrl ?? '',
                width: 48,
                height: 48,
                borderRadius: 10,
                placeholderColor: AppColors.backgroundSecondary,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.name,
                      style: AppTextStyles.bodySemiBold16.copyWith(
                        decoration:
                            item.isChecked ? TextDecoration.lineThrough : null,
                        color: item.isChecked
                            ? AppColors.textSecondary
                            : AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: AppTextStyles.secondaryBodyRegular14Text,
                    ),
                  ],
                ),
              ),
              IconButton(
                onPressed: onDelete,
                icon: const Icon(Icons.delete_outline, color: AppColors.error),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
