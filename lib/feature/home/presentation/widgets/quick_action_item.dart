import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fridgy/core/theme/styles/app_colors.dart';
import 'package:fridgy/core/theme/styles/app_text_styles.dart';

class QuickActionItem extends StatelessWidget {
  const QuickActionItem({
    required this.iconAsset,
    required this.label,
    required this.onTap,
    super.key,
  });

  final String iconAsset;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Column(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: AppColors.surfaceAccent,
                borderRadius: BorderRadius.circular(16),
              ),
              alignment: Alignment.center,
              child: SvgPicture.asset(iconAsset, width: 22, height: 22),
            ),
            const SizedBox(height: 8),
            Text(
              label,
              style: AppTextStyles.smallLabelSemiBold11,
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
