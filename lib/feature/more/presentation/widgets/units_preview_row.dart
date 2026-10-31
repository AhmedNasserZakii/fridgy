import 'package:flutter/material.dart';
import 'package:fridgy/core/theme/styles/app_text_styles.dart';

class UnitsPreviewRow extends StatelessWidget {
  const UnitsPreviewRow({
    super.key,
    required this.title,
    required this.subtitle,
  });

  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(minHeight: 58),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: AppTextStyles.bodySemiBold16Primary),
            Text(subtitle, style: AppTextStyles.captionRegular12),
          ],
        ),
      ),
    );
  }
}
