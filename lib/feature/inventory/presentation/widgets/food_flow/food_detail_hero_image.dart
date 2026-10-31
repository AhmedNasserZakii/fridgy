import 'package:flutter/material.dart';
import 'package:fridgy/core/shared_widgets/custom_network_image.dart';

class FoodDetailHeroImage extends StatelessWidget {
  const FoodDetailHeroImage({super.key, this.imageUrl});

  final String? imageUrl;

  @override
  Widget build(BuildContext context) {
    return CustomNetworkImage(
      imageUrl: imageUrl ?? '',
      height: 220,
      width: double.infinity,
      borderRadius: 20,
      errorIcon: Icons.image_not_supported_outlined,
      errorIconSize: 48,
    );
  }
}
