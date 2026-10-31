import 'package:flutter/material.dart';
import 'package:fridgy/core/shared_widgets/custom_network_image.dart';
import 'package:fridgy/core/theme/styles/app_colors.dart';
import 'package:fridgy/core/theme/styles/app_text_styles.dart';
import 'package:fridgy/feature/inventory/presentation/utils/food_item_formatters.dart';
import 'package:fridgy/feature/shopping/domain/entities/catalog_product_entity.dart';

class CatalogProductCard extends StatelessWidget {
  const CatalogProductCard({
    required this.product,
    required this.onTap,
    super.key,
  });

  final CatalogProductEntity product;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final price = product.price;
    final currency = product.currency ?? '';
    final priceText = price == null
        ? ''
        : '${price == price.roundToDouble() ? price.round() : price} $currency';

    return Material(
      color: AppColors.surfaceDefault,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.borderDefault),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: ClipRRect(
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(16),
                  ),
                  child: CustomNetworkImage(
                    imageUrl: product.imageUrl ?? '',
                    placeholderColor: AppColors.backgroundSecondary,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      product.name,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.bodySemiBold16,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      FoodItemFormatters.categoryLabel(product.category),
                      style: AppTextStyles.secondaryBodyRegular14Text,
                    ),
                    if (priceText.isNotEmpty) ...[
                      const SizedBox(height: 4),
                      Text(priceText, style: AppTextStyles.bodySemiBold16),
                    ],
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
