import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fridgy/core/theme/styles/app_text_styles.dart';

class SettingsListRow extends StatelessWidget {
  const SettingsListRow({
    super.key,
    required this.iconAsset,
    required this.title,
    this.subtitle,
    this.onTap,
  });

  final String iconAsset;
  final String title;
  final String? subtitle;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: ConstrainedBox(
        constraints: const BoxConstraints(minHeight: 58),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Row(
            children: [
              SvgPicture.asset(iconAsset, width: 22, height: 22),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: AppTextStyles.bodySemiBold16Primary),
                    if (subtitle != null) ...[
                      Text(subtitle!, style: AppTextStyles.captionRegular12),
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
