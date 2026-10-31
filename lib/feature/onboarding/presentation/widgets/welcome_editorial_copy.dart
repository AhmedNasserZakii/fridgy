import 'package:flutter/material.dart';
import 'package:fridgy/core/theme/styles/app_text_styles.dart';

class WelcomeEditorialCopy extends StatelessWidget {
  const WelcomeEditorialCopy({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Meet Fridgy, your smarter kitchen companion.',
          style: AppTextStyles.headlineBold34,
        ),
        SizedBox(height: 16),
        Text(
          'Less food forgotten. More meals to love. A little help for every kitchen.',
          style: AppTextStyles.bodyRegular16,
        ),
      ],
    );
  }
}
