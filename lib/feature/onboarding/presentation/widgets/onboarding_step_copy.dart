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
      children: [
        Text(
          title,
          style: AppTextStyles.headlineBold30,
        ),
        const SizedBox(height: 16),
        Text(
          body,
          style: AppTextStyles.bodyRegular16,
        ),
      ],
    );
  }
}
