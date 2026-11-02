import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:fridgy/core/theme/styles/app_colors.dart';

class CustomNetworkImage extends StatelessWidget {
  const CustomNetworkImage({
    required this.imageUrl,
    super.key,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.borderRadius,
    this.borderRadiusGeometry,
    this.errorIcon = Icons.broken_image_outlined,
    this.errorIconSize,
    this.placeholderColor = AppColors.borderDefault,
    this.errorWidget,
  });

  final String imageUrl;
  final double? width;
  final double? height;
  final BoxFit fit;
  final double? borderRadius;
  final BorderRadiusGeometry? borderRadiusGeometry;
  final IconData errorIcon;
  final double? errorIconSize;
  final Color placeholderColor;
  final Widget? errorWidget;

  bool get _hasUrl => imageUrl.trim().isNotEmpty;

  BorderRadiusGeometry get _radius =>
      borderRadiusGeometry ?? BorderRadius.circular(borderRadius ?? 0);

  Widget _fallback({required IconData icon}) {
    return Container(
      width: width,
      height: height,
      color: placeholderColor,
      alignment: Alignment.center,
      child: Icon(icon, size: errorIconSize, color: AppColors.textSecondary),
    );
  }

  @override
  Widget build(BuildContext context) {
    final child = !_hasUrl
        ? _fallback(icon: Icons.image_not_supported_outlined)
        : CachedNetworkImage(
            imageUrl: imageUrl,
            width: width,
            height: height,
            fit: fit,
            fadeInDuration: const Duration(milliseconds: 150),
            fadeOutDuration: const Duration(milliseconds: 100),
            placeholder: (_, _) => Container(
              width: width,
              height: height,
              color: placeholderColor,
            ),
            errorWidget: (_, _, _) => errorWidget ?? _fallback(icon: errorIcon),
          );

    if (borderRadius == null && borderRadiusGeometry == null) {
      return child;
    }

    return ClipRRect(borderRadius: _radius, child: child);
  }
}
