import 'package:flutter/material.dart';
import 'package:fridgy/core/shared_widgets/fridgy_brand_header.dart';
import 'package:fridgy/core/theme/styles/app_text_styles.dart';

class OnboardingStepsNav extends StatelessWidget {
  const OnboardingStepsNav({super.key, required this.onSkip});

  final VoidCallback onSkip;

  @override
  Widget build(BuildContext context) {
    return FridgyBrandHeader(
      trailing: TextButton(
        onPressed: onSkip,
        style: TextButton.styleFrom(
          padding: EdgeInsets.zero,
          minimumSize: Size.zero,
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        ),
        child: const Text('Skip', style: AppTextStyles.secondaryBodyRegular14),
      ),
    );
  }
}
