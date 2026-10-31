import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fridgy/core/theme/styles/app_colors.dart';

class FridgeAiPendingImagePreview extends StatelessWidget {
  const FridgeAiPendingImagePreview({
    required this.path,
    required this.onRemove,
    super.key,
  });

  final String path;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: AlignmentDirectional.centerStart,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(14),
            child: Image.file(
              File(path),
              width: 72,
              height: 72,
              fit: BoxFit.cover,
              errorBuilder: (_, _, _) => Container(
                width: 72,
                height: 72,
                color: AppColors.surfaceAccent,
                alignment: Alignment.center,
                child: const Icon(Icons.image_outlined),
              ),
            ),
          ),
          PositionedDirectional(
            top: -6,
            end: -6,
            child: Material(
              color: AppColors.surfaceDark,
              shape: const CircleBorder(),
              child: InkWell(
                customBorder: const CircleBorder(),
                onTap: onRemove,
                child: const Padding(
                  padding: EdgeInsets.all(4),
                  child: Icon(
                    Icons.close,
                    size: 14,
                    color: AppColors.textInverse,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
