import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fridgy/core/theme/styles/app_colors.dart';
import 'package:fridgy/core/theme/styles/app_text_styles.dart';

class FridgeAiModeCard extends StatelessWidget {
  const FridgeAiModeCard({
    required this.iconAsset,
    required this.title,
    required this.body,
    required this.onTap,
    super.key,
  });

  final String iconAsset;
  final String title;
  final String body;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.surfaceDefault,
      borderRadius: BorderRadius.circular(20),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Ink(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: AppColors.borderDefault),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  children: [
                    SvgPicture.asset(iconAsset, width: 22, height: 22),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        title,
                        style: AppTextStyles.bodySemiBold17Primary,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(body, style: AppTextStyles.secondaryBodyRegular15),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
