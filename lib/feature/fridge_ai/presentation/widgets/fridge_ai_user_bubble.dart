import 'package:flutter/material.dart';
import 'package:fridgy/core/theme/styles/app_colors.dart';
import 'package:fridgy/core/theme/styles/app_text_styles.dart';
import 'package:fridgy/feature/fridge_ai/presentation/widgets/fridge_ai_message_image.dart';

class FridgeAiUserBubble extends StatelessWidget {
  const FridgeAiUserBubble({
    required this.content,
    this.imagePath,
    super.key,
  });

  final String content;
  final String? imagePath;

  @override
  Widget build(BuildContext context) {
    final hasText = content.trim().isNotEmpty;
    final hasImage = imagePath != null && imagePath!.isNotEmpty;

    return Align(
      alignment: AlignmentDirectional.centerEnd,
      child: Container(
        constraints: const BoxConstraints(maxWidth: 306),
        padding: const EdgeInsets.all(10),
        decoration: const BoxDecoration(
          color: AppColors.brandPrimary,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
            bottomLeft: Radius.circular(20),
            bottomRight: Radius.circular(5),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (hasImage) ...[
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: FridgeAiMessageImage(path: imagePath!),
              ),
              if (hasText) const SizedBox(height: 8),
            ],
            if (hasText)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                child: Text(
                  content,
                  style: AppTextStyles.bodyRegular17Secondary.copyWith(
                    color: AppColors.textInverse,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
