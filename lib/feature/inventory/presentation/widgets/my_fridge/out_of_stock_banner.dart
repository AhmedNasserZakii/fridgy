import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:fridgy/core/constants/locale_keys.dart';
import 'package:fridgy/core/theme/styles/app_text_styles.dart';
import 'package:fridgy/feature/inventory/domain/entities/food_item_entity.dart';
import 'package:fridgy/feature/inventory/presentation/utils/food_item_formatters.dart';

class OutOfStockBanner extends StatelessWidget {
  const OutOfStockBanner({
    required this.items,
    required this.activeCount,
    super.key,
  });

  final List<FoodItemEntity> items;
  final int activeCount;

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) return const SizedBox.shrink();

    final names = items.map((item) => item.name).join(' · ');
    final unitLabel = items.length == 1 && items.first.unit != null
        ? FoodItemFormatters.unitLabel(items.first.unit!)
        : LocaleKeys.unitPcs.tr();

    return Padding(
      padding: const EdgeInsetsDirectional.only(top: 8),
      child: Text(
        LocaleKeys.outOfStockFooter.tr(
          args: [names, unitLabel, '$activeCount'],
        ),
        style: AppTextStyles.captionRegular12,
      ),
    );
  }
}
