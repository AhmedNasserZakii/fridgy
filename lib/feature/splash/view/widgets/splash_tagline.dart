import 'package:flutter/material.dart';
import 'package:fridgy/core/theme/styles/app_text_styles.dart';

class SplashTagline extends StatelessWidget {
  const SplashTagline({super.key});

  @override
  Widget build(BuildContext context) {
    return const Text(
      'Your Food. Smarter.',
      textAlign: TextAlign.center,
      style: AppTextStyles.titleRegular20,
    );
  }
}
