import 'package:flutter/material.dart';
import 'package:fridgy/core/constants/app_assets.dart';
import 'package:fridgy/feature/onboarding/domain/entities/onboarding_step_entity.dart';

class OnboardingStepsManager extends ChangeNotifier {
  OnboardingStepsManager() {
    pageController = PageController();
  }

  late final PageController pageController;
  int currentIndex = 0;

  static const List<OnboardingStepEntity> steps = [
    OnboardingStepEntity(
      imagePath: AppAssets.onboardingStepOrder,
      title: 'A little order. A lot more fresh.',
      body:
          "Keep your fridge, freezer and pantry together. Add food your way, and always know what's at home.",
    ),
    OnboardingStepEntity(
      imagePath: AppAssets.onboardingStepReminder,
      title: 'Good food deserves a reminder.',
      body:
          "Get a gentle nudge before the dates you enter. Always check packaging and food condition—reminders don't guarantee safety.",
    ),
    OnboardingStepEntity(
      imagePath: AppAssets.onboardingStepRecipes,
      title: 'Dinner starts with what you have.',
      body:
          "Discover simple recipes for your ingredients. Turn a handful of spinach into tonight's favourite meal.",
    ),
  ];

  bool get isLastPage => currentIndex >= steps.length - 1;

  void onPageChanged(int index) {
    currentIndex = index;
    notifyListeners();
  }

  void continuePressed({required VoidCallback onFinished}) {
    if (isLastPage) {
      onFinished();
      return;
    }

    pageController.nextPage(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }
}
