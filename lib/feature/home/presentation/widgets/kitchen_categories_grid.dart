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
    final categories = KitchenCategory.values;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          LocaleKeys.browseYourKitchen.tr(),
          style: AppTextStyles.titleBold20,
        ),
        const SizedBox(height: 16),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: categories.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
            childAspectRatio: 1.2,
          ),
          itemBuilder: (context, index) {
            final category = categories[index];
            return KitchenCategoryTile(
              category: category,
              onTap: () =>
                  AppSnackBar.show(context, LocaleKeys.comingSoon.tr()),
            );
          },
        ),
      ],
    );
  }
}
