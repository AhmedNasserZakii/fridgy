import 'package:flutter/material.dart';
import 'package:fridgy/core/shared_widgets/primary_button.dart';
import 'package:fridgy/core/shared_widgets/text_action_button.dart';

class OnboardingStepsActions extends StatelessWidget {
  const OnboardingStepsActions({
    super.key,
    required this.onContinue,
    required this.onSkip,
  });

  final VoidCallback onContinue;
  final VoidCallback onSkip;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        PrimaryButton(label: 'Continue', onPressed: onContinue),
        TextActionButton(label: 'Skip for now', onPressed: onSkip),
      ],
    );
  }
}
