import 'package:flutter/material.dart';
import 'package:fridgy/core/theme/styles/app_text_styles.dart';

class AuthIntroText extends StatelessWidget {
  const AuthIntroText({
    super.key,
    required this.headline,
    required this.subtitle,
    this.useLargeTitleHeight = false,
  });

  final String headline;
  final String subtitle;
  final bool useLargeTitleHeight;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          headline,
          style: useLargeTitleHeight
              ? AppTextStyles.largeTitleBold30
              : AppTextStyles.headlineBold30,
        ),
        const SizedBox(height: 8),
        Text(subtitle, style: AppTextStyles.bodyRegular16),
      ],
    );
  }
}
