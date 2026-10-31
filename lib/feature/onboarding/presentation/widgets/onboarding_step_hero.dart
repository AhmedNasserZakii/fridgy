import 'package:flutter/material.dart';

class OnboardingStepHero extends StatelessWidget {
  const OnboardingStepHero({
    super.key,
    required this.imagePath,
  });

  final String imagePath;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(28),
      child: Image.asset(
        imagePath,
        height: 330,
        width: double.infinity,
        fit: BoxFit.cover,
      ),
    );
  }
}
