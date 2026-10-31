import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:fridgy/core/constants/locale_keys.dart';
import 'package:fridgy/core/shared_widgets/food_card.dart';
import 'package:fridgy/feature/home/presentation/widgets/section_header.dart';
import 'package:fridgy/feature/inventory/domain/entities/food_item_entity.dart';

class UseFirstSection extends StatelessWidget {
  const UseFirstSection({
    required this.items,
    required this.onSeeAll,
    super.key,
  });

  final List<FoodItemEntity> items;
  final VoidCallback onSeeAll;

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SectionHeader(
          title: LocaleKeys.useTheseFirst.tr(),
          subtitle: LocaleKeys.useTheseFirstSubtitle.tr(),
          actionLabel: LocaleKeys.seeAll.tr(),
          onAction: onSeeAll,
        ),
        const SizedBox(height: 16),
        for (var i = 0; i < items.length; i++) ...[
          if (i > 0) const SizedBox(height: 16),
          FoodCard(item: items[i]),
        ],
      ],
    );
  }
}
