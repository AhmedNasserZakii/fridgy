import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fridgy/core/constants/app_assets.dart';
import 'package:fridgy/core/theme/styles/app_colors.dart';
import 'package:fridgy/core/theme/styles/app_text_styles.dart';

class FridgeAiAssistantBubble extends StatelessWidget {
  const FridgeAiAssistantBubble({required this.content, super.key});

  final String content;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SvgPicture.asset(AppAssets.icFridgyAvatar, width: 28, height: 28),
        const SizedBox(width: 8),
        Flexible(
          child: Container(
            constraints: const BoxConstraints(maxWidth: 306),
            padding: const EdgeInsets.all(14),
            decoration: const BoxDecoration(
              color: AppColors.surfaceAccent,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
                bottomLeft: Radius.circular(5),
                bottomRight: Radius.circular(20),
              ),
            ),
            child: Text(
              content,
              style: AppTextStyles.bodyRegular17Secondary.copyWith(
                color: AppColors.textPrimary,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
