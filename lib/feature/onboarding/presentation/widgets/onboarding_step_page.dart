import 'package:flutter/material.dart';
import 'package:fridgy/feature/onboarding/domain/entities/onboarding_step_entity.dart';
import 'package:fridgy/feature/onboarding/presentation/widgets/onboarding_step_copy.dart';
import 'package:fridgy/feature/onboarding/presentation/widgets/onboarding_step_hero.dart';
import 'package:fridgy/feature/onboarding/presentation/widgets/onboarding_step_progress.dart';

class OnboardingStepPage extends StatelessWidget {
  const OnboardingStepPage({
    super.key,
    required this.step,
    required this.stepIndex,
    required this.stepCount,
  });

  final OnboardingStepEntity step;
  final int stepIndex;
  final int stepCount;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        OnboardingStepHero(imagePath: step.imagePath),
        const SizedBox(height: 16),
        OnboardingStepProgress(
          currentIndex: stepIndex,
          stepCount: stepCount,
        ),
        const SizedBox(height: 16),
        OnboardingStepCopy(
          title: step.title,
          body: step.body,
        ),
      ],
    );
  }
}
