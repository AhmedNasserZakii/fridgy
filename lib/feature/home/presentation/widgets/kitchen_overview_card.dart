import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:fridgy/core/constants/app_assets.dart';
import 'package:fridgy/core/constants/locale_keys.dart';
import 'package:fridgy/core/theme/styles/app_colors.dart';
import 'package:fridgy/core/theme/styles/app_text_styles.dart';

class KitchenOverviewCard extends StatelessWidget {
  const KitchenOverviewCard({
    required this.totalItems,
    required this.expiringSoonCount,
    required this.onViewFridge,
    this.onExpiringTap,
    super.key,
  });

  final int totalItems;
  final int expiringSoonCount;
  final VoidCallback onViewFridge;
  final VoidCallback? onExpiringTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 250,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.surfaceAccent,
        borderRadius: BorderRadius.circular(28),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  LocaleKeys.fridgeLookingGood.tr(),
                  style: AppTextStyles.titleBold22,
                ),
                const SizedBox(height: 12),
                Text(
                  LocaleKeys.itemsReadyToEnjoy.tr(args: ['$totalItems']),
                  style: AppTextStyles.captionRegular12,
                ),
                const SizedBox(height: 18),
                Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(
                        text: LocaleKeys.itemsInKitchen.tr(
                          args: ['$totalItems'],
                        ),
                        style: AppTextStyles.heroStatBold18,
                      ),
                      TextSpan(
                        text: LocaleKeys.itemsInKitchenSuffix.tr(),
                        style: AppTextStyles.heroStatLabel11,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 4),
                GestureDetector(
                  onTap: onExpiringTap,
                  child: Text(
                    LocaleKeys.expiringSoonCount.tr(
                      args: ['$expiringSoonCount'],
                    ),
                    style: AppTextStyles.heroExpiringSemiBold13,
                  ),
                ),
                const Spacer(),
                GestureDetector(
                  onTap: onViewFridge,
                  child: Text(
                    LocaleKeys.viewMyFridge.tr(),
                    style: AppTextStyles.secondaryBodySemiBold14Brand,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Image.asset(
              AppAssets.homeHero,
              width: 138,
              height: 214,
              fit: BoxFit.cover,
            ),
          ),
        ],
      ),
    );
  }
}
