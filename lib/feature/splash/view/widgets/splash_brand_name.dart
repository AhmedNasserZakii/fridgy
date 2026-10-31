import 'package:flutter/material.dart';
import 'package:fridgy/core/theme/styles/app_text_styles.dart';

class SplashBrandName extends StatelessWidget {
  const SplashBrandName({super.key});

  @override
  Widget build(BuildContext context) {
    return const Text(
      'FRIDGY',
      textAlign: TextAlign.center,
      style: AppTextStyles.displayExtraBold34,
    );
  }
}
