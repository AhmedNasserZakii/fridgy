import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:fridgy/core/constants/locale_keys.dart';
import 'package:fridgy/core/shared_widgets/food_card.dart';
import 'package:fridgy/core/theme/styles/app_text_styles.dart';
import 'package:fridgy/feature/inventory/domain/entities/food_item_entity.dart';

class RestSection extends StatelessWidget {
  const RestSection({
    required this.items,
    required this.onItemTap,
    super.key,
  });

  final List<FoodItemEntity> items;
  final ValueChanged<String> onItemTap;

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(LocaleKeys.restOfKitchen.tr(), style: AppTextStyles.titleBold20),
        const SizedBox(height: 12),
        for (final item in items) ...[
          FoodCard(item: item, onTap: () => onItemTap(item.id)),
          const SizedBox(height: 12),
        ],
      ],
    );
  }
}
