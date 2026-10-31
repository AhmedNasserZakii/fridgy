import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:fridgy/core/constants/locale_keys.dart';
import 'package:fridgy/core/theme/styles/app_colors.dart';
import 'package:fridgy/core/theme/styles/app_text_styles.dart';
import 'package:fridgy/feature/inventory/domain/entities/expiry_status.dart';
import 'package:fridgy/feature/inventory/domain/entities/food_item_entity.dart';
import 'package:fridgy/feature/inventory/presentation/utils/food_item_formatters.dart';

class DetailStatusChips extends StatelessWidget {
  const DetailStatusChips({super.key, required this.item});

  final FoodItemEntity item;

  @override
  Widget build(BuildContext context) {
    final chips = <Widget>[];

    if (item.expiryStatus == ExpiryStatus.useSoon) {
      final days = item.daysLeft ?? 0;
      final daysText = days == 1
          ? LocaleKeys.day.tr(args: ['1'])
          : LocaleKeys.days.tr(args: ['$days']);
      chips.add(
        _Chip(
          label: LocaleKeys.useSoonDaysLeft.tr(args: [daysText]),
          background: AppColors.brandLight,
          foreground: AppColors.expiryWarning,
        ),
      );
    }

    final category = FoodItemFormatters.categoryLabel(item.category);
    if (category.isNotEmpty) {
      chips.add(
        _Chip(
          label: category,
          background: AppColors.backgroundSecondary,
          foreground: AppColors.textSecondary,
        ),
      );
    }

    if (chips.isEmpty) return const SizedBox.shrink();

    return Wrap(spacing: 8, runSpacing: 8, children: chips);
  }
}

class _Chip extends StatelessWidget {
  const _Chip({
    required this.label,
    required this.background,
    required this.foreground,
  });

  final String label;
  final Color background;
  final Color foreground;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: AppTextStyles.captionSemiBold12.copyWith(color: foreground),
      ),
    );
  }
}
