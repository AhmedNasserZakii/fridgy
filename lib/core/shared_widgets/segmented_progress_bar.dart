import 'package:flutter/material.dart';
import 'package:fridgy/core/theme/styles/app_colors.dart';

class SegmentedProgressBar extends StatelessWidget {
  const SegmentedProgressBar({
    super.key,
    required this.segmentCount,
    required this.currentIndex,
  });

  final int segmentCount;
  final int currentIndex;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(segmentCount, (index) {
        final filled = index <= currentIndex;
        return Expanded(
          child: Container(
            height: 4,
            margin: EdgeInsetsDirectional.only(
              end: index == segmentCount - 1 ? 0 : 4,
            ),
            decoration: BoxDecoration(
              color: filled ? AppColors.brandPrimary : AppColors.brandLight,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
        );
      }),
    );
  }
}
