import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fridgy/core/constants/app_assets.dart';
import 'package:fridgy/core/theme/styles/app_colors.dart';
import 'package:fridgy/core/theme/styles/app_text_styles.dart';
import 'package:fridgy/feature/profile_setup/domain/entities/food_category_entity.dart';

class FoodFavoriteTile extends StatelessWidget {
  const FoodFavoriteTile({
    super.key,
    required this.category,
    required this.selected,
    required this.onTap,
  });

  final FoodCategoryEntity category;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 108,
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: selected ? AppColors.brandLight : AppColors.surfaceDefault,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: selected ? AppColors.brandPrimary : AppColors.borderInput,
            width: selected ? 1.5 : 1,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(category.emoji, style: const TextStyle(fontSize: 29)),
                const Spacer(),
                Container(
                  width: 20,
                  height: 20,
                  decoration: BoxDecoration(
                    color: selected
                        ? AppColors.brandPrimary
                        : AppColors.surfaceDefault,
                    borderRadius: BorderRadius.circular(6),
                    border: selected
                        ? null
                        : Border.all(color: AppColors.borderInput, width: 1.5),
                  ),
                  alignment: Alignment.center,
                  child: selected
                      ? SvgPicture.asset(
                          AppAssets.icCheck,
                          width: 14,
                          height: 14,
                        )
                      : null,
                ),
              ],
            ),
            const SizedBox(height: 6),
            Text(
              category.name,
              style: AppTextStyles.secondaryBodySemiBold14.copyWith(
                fontSize: 12,
                height: 1.3,
                color: AppColors.textFieldLabel,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
