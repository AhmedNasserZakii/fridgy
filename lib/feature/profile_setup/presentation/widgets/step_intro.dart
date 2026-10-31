import 'package:flutter/material.dart';
import 'package:fridgy/core/theme/styles/app_text_styles.dart';

class StepIntro extends StatelessWidget {
  const StepIntro({
    super.key,
    required this.title,
    required this.subtitle,
    this.centered = false,
  });

  final String title;
  final String subtitle;
  final bool centered;

  @override
  Widget build(BuildContext context) {
    final align = centered ? TextAlign.center : TextAlign.start;
    return Column(
      crossAxisAlignment: centered
          ? CrossAxisAlignment.center
          : CrossAxisAlignment.start,
      children: [
        Text(
          title,
          textAlign: align,
          style: AppTextStyles.titleBold20.copyWith(
            fontSize: 24,
            height: 1.13,
            letterSpacing: -1.2,
          ),
        ),
        const SizedBox(height: 14),
        Text(
          subtitle,
          textAlign: align,
          style: AppTextStyles.bodyRegular16.copyWith(height: 1.5),
        ),
      ],
    );
  }
}
