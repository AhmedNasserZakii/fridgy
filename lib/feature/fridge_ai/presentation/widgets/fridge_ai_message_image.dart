import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fridgy/core/shared_widgets/custom_network_image.dart';
import 'package:fridgy/core/theme/styles/app_colors.dart';

class FridgeAiMessageImage extends StatelessWidget {
  const FridgeAiMessageImage({required this.path, super.key});

  final String path;

  @override
  Widget build(BuildContext context) {
    final isNetwork = path.startsWith('http://') || path.startsWith('https://');
    return AspectRatio(
      aspectRatio: 4 / 3,
      child: isNetwork
          ? CustomNetworkImage(
              imageUrl: path,
              placeholderColor: AppColors.surfaceAccent,
            )
          : Image.file(
              File(path),
              fit: BoxFit.cover,
              errorBuilder: (_, _, _) => Container(
                color: AppColors.surfaceAccent,
                alignment: Alignment.center,
                child: const Icon(Icons.broken_image_outlined),
              ),
            ),
    );
  }
}
