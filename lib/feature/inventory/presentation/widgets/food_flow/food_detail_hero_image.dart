import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:fridgy/core/theme/styles/app_colors.dart';

class FoodDetailHeroImage extends StatelessWidget {
  const FoodDetailHeroImage({super.key, this.imageUrl});

  final String? imageUrl;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: imageUrl == null || imageUrl!.isEmpty
          ? Container(
              height: 220,
              color: AppColors.borderDefault,
              child: const Icon(
                Icons.image_not_supported_outlined,
                color: AppColors.textSecondary,
                size: 48,
              ),
            )
          : CachedNetworkImage(
              imageUrl: imageUrl!,
              height: 220,
              width: double.infinity,
              fit: BoxFit.cover,
              placeholder: (context, url) => Container(
                height: 220,
                color: AppColors.borderDefault,
              ),
              errorWidget: (context, url, error) => Container(
                height: 220,
                color: AppColors.borderDefault,
                child: const Icon(
                  Icons.image_not_supported_outlined,
                  color: AppColors.textSecondary,
                ),
              ),
            ),
    );
  }
}
