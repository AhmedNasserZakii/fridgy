import 'package:flutter/material.dart';
import 'package:fridgy/core/theme/styles/app_colors.dart';
import 'package:fridgy/core/theme/styles/app_text_styles.dart';

class FridgeAiModeSegmentTab extends StatelessWidget {
  const FridgeAiModeSegmentTab({
    required this.label,
    required this.selected,
    required this.onTap,
    super.key,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: selected ? AppColors.brandPrimary : Colors.transparent,
      borderRadius: BorderRadius.circular(7),
      elevation: selected ? 2 : 0,
      shadowColor: AppColors.black.withValues(alpha: 0.12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(7),
        child: Center(
          child: Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: selected
                ? AppTextStyles.segmentSelectedSemiBold13
                : AppTextStyles.segmentUnselectedRegular13,
          ),
        ),
      ),
    );
  }
}
