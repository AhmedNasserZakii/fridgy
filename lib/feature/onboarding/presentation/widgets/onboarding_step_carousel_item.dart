import 'package:flutter/material.dart';
import 'package:fridgy/feature/onboarding/presentation/widgets/onboarding_step_hero.dart';

class OnboardingStepCarouselItem extends StatelessWidget {
  const OnboardingStepCarouselItem({
    super.key,
    required this.imagePath,
    required this.index,
    required this.pageController,
  });

  final String imagePath;
  final int index;
  final PageController pageController;

  static const double _pageGap = 8;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: pageController,
      builder: (context, child) {
        final page =
            pageController.hasClients && pageController.position.haveDimensions
            ? pageController.page ?? index.toDouble()
            : index.toDouble();
        final distance = (page - index).abs().clamp(0.0, 1.0);
        final scale = 1 - (distance * 0.08);
        final opacity = 1 - (distance * 0.35);

        return Opacity(
          opacity: opacity,
          child: Transform.scale(scale: scale, child: child),
        );
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: _pageGap),
        child: OnboardingStepHero(imagePath: imagePath),
      ),
    );
  }
}
