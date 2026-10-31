import 'package:flutter/material.dart';
import 'package:fridgy/core/theme/styles/app_colors.dart';

class OnboardingStepProgress extends StatelessWidget {
  const OnboardingStepProgress({
    super.key,
    required this.currentIndex,
    required this.stepCount,
  });

  final int currentIndex;
  final int stepCount;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        for (var i = 0; i < stepCount; i++) ...[
          if (i > 0) const SizedBox(width: 6),
          AnimatedContainer(
            duration: const Duration(milliseconds: 250),
            curve: Curves.easeInOut,
            width: i == currentIndex ? 28 : 8,
            height: 6,
            decoration: BoxDecoration(
              color: i == currentIndex
                  ? AppColors.brandPrimary
                  : AppColors.borderDefault,
              borderRadius: BorderRadius.circular(99),
            ),
          ),
        ],
      ],
    );
  }
}
