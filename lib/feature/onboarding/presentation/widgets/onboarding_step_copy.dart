import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:fridgy/core/theme/styles/app_text_styles.dart';

class OnboardingStepCopy extends StatelessWidget {
  const OnboardingStepCopy({
    super.key,
    required this.title,
    required this.body,
  });

  final String title;
  final String body;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        AutoSizeText(
          title,
          maxLines: 2,
          minFontSize: 18,
          stepGranularity: 1,
          style: AppTextStyles.headlineBold30,
        ),
        const SizedBox(height: 16),
        AutoSizeText(
          body,
          maxLines: 3,
          minFontSize: 12,
          stepGranularity: 1,
          style: AppTextStyles.bodyRegular16,
        ),
      ],
    );
  }
}
