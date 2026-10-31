import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fridgy/core/constants/app_assets.dart';
import 'package:fridgy/core/theme/styles/app_colors.dart';
import 'package:fridgy/core/theme/styles/app_text_styles.dart';

class AddOptionCard extends StatelessWidget {
  const AddOptionCard({
    super.key,
    required this.iconAsset,
    required this.title,
    required this.subtitle,
    required this.onTap,
    this.accentBackground = false,
  });

  final String iconAsset;
  final String title;
  final String subtitle;
  final VoidCallback onTap;
  final bool accentBackground;

  @override
  Widget build(BuildContext context) {
    final background = accentBackground
        ? AppColors.surfaceAccent
        : AppColors.backgroundSecondary;

    return Material(
      color: background,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              SvgPicture.asset(iconAsset, width: 24, height: 24),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: AppTextStyles.bodySemiBold16),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: AppTextStyles.secondaryBodyRegular14Text,
                    ),
                  ],
                ),
              ),
              SvgPicture.asset(
                AppAssets.icChevronRight,
                width: 20,
                height: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
