import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:fridgy/core/constants/locale_keys.dart';
import 'package:fridgy/core/shared_widgets/app_snack_bar.dart';
import 'package:fridgy/core/theme/styles/app_text_styles.dart';
import 'package:fridgy/feature/home/domain/entities/kitchen_category.dart';
import 'package:fridgy/feature/home/presentation/widgets/kitchen_category_tile.dart';

class KitchenCategoriesGrid extends StatelessWidget {
  const KitchenCategoriesGrid({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          LocaleKeys.browseYourKitchen.tr(),
          style: AppTextStyles.titleBold20,
        ),
        const SizedBox(height: 16),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: [
            for (final category in KitchenCategory.values)
              KitchenCategoryTile(
                category: category,
                onTap: () =>
                    AppSnackBar.show(context, LocaleKeys.comingSoon.tr()),
              ),
          ],
        ),
      ],
    );
  }
}
