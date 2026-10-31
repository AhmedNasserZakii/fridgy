import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:fridgy/core/theme/styles/app_colors.dart';
import 'package:fridgy/core/theme/styles/app_text_styles.dart';
import 'package:fridgy/feature/inventory/domain/entities/expiry_status.dart';
import 'package:fridgy/feature/inventory/domain/entities/food_item_entity.dart';
import 'package:fridgy/feature/inventory/presentation/utils/food_item_formatters.dart';

class FoodCard extends StatelessWidget {
  const FoodCard({required this.item, this.onTap, super.key});

  final FoodItemEntity item;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final expiry = FoodItemFormatters.expiryLine(item);
    final expiryStyle = switch (item.expiryStatus) {
      ExpiryStatus.useSoon => AppTextStyles.captionSemiBold12Warning,
      ExpiryStatus.expired => AppTextStyles.errorCaptionRegular12.copyWith(
        fontWeight: FontWeight.w600,
      ),
      ExpiryStatus.fresh || null => AppTextStyles.captionRegular12,
    };

    return Material(
      color: AppColors.backgroundSecondary,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: item.imageUrl == null || item.imageUrl!.isEmpty
                    ? Container(
                        width: 72,
                        height: 72,
                        color: AppColors.borderDefault,
                        child: const Icon(
                          Icons.image_not_supported_outlined,
                          color: AppColors.textSecondary,
                        ),
                      )
                    : CachedNetworkImage(
                        imageUrl: item.imageUrl!,
                        width: 72,
                        height: 72,
                        fit: BoxFit.cover,
                        placeholder: (context, url) => Container(
                          width: 72,
                          height: 72,
                          color: AppColors.borderDefault,
                        ),
                        errorWidget: (context, url, error) => Container(
                          width: 72,
                          height: 72,
                          color: AppColors.borderDefault,
                          child: const Icon(
                            Icons.broken_image_outlined,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(item.name, style: AppTextStyles.bodySemiBold16Primary),
                    Text(
                      FoodItemFormatters.subtitle(item),
                      style: AppTextStyles.captionRegular12,
                    ),
                    if (expiry != null) Text(expiry, style: expiryStyle),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
