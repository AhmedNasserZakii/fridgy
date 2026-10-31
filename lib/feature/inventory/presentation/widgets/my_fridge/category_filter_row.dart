import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:fridgy/core/constants/locale_keys.dart';
import 'package:fridgy/feature/inventory/domain/entities/food_category.dart';
import 'package:fridgy/feature/inventory/presentation/utils/food_item_formatters.dart';
import 'package:fridgy/feature/inventory/presentation/widgets/my_fridge/filter_chip_text.dart';

class CategoryFilterRow extends StatelessWidget {
  const CategoryFilterRow({
    required this.selected,
    required this.onSelected,
    super.key,
  });

  final FoodCategory? selected;
  final ValueChanged<FoodCategory?> onSelected;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          FilterChipText(
            label: LocaleKeys.categoryAllFood.tr(),
            selected: selected == null,
            onTap: () => onSelected(null),
          ),
          for (final category in FoodCategory.values) ...[
            const SizedBox(width: 12),
            FilterChipText(
              label: FoodItemFormatters.categoryLabel(category),
              selected: selected == category,
              onTap: () => onSelected(category),
            ),
          ],
        ],
      ),
    );
  }
}
