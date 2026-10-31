import 'package:flutter/material.dart';
import 'package:fridgy/core/theme/styles/app_colors.dart';
import 'package:fridgy/feature/onboarding/presentation/logic/onboarding_steps_manager.dart';
import 'package:fridgy/feature/onboarding/presentation/widgets/onboarding_step_page.dart';
import 'package:fridgy/feature/onboarding/presentation/widgets/onboarding_steps_actions.dart';
import 'package:fridgy/feature/onboarding/presentation/widgets/onboarding_steps_nav.dart';

class OnboardingStepsScreen extends StatefulWidget {
  const OnboardingStepsScreen({
    super.key,
    required this.onFinished,
    required this.onSkip,
  });

  final VoidCallback onFinished;
  final VoidCallback onSkip;

  @override
  State<OnboardingStepsScreen> createState() => _OnboardingStepsScreenState();
}

class _OnboardingStepsScreenState extends State<OnboardingStepsScreen> {
  late final OnboardingStepsManager _manager;

  @override
  void initState() {
    super.initState();
    _manager = OnboardingStepsManager();
  }

  @override
  void dispose() {
    _manager.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surfaceDefault,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: ListenableBuilder(
            listenable: _manager,
            builder: (context, _) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 16),
                  OnboardingStepsNav(onSkip: widget.onSkip),
                  const SizedBox(height: 16),
                  Expanded(
                    child: PageView.builder(
                      controller: _manager.pageController,
                      itemCount: OnboardingStepsManager.steps.length,
                      onPageChanged: _manager.onPageChanged,
                      itemBuilder: (context, index) {
                        return SingleChildScrollView(
                          child: OnboardingStepPage(
                            step: OnboardingStepsManager.steps[index],
                            stepIndex: index,
                            stepCount: OnboardingStepsManager.steps.length,
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 16),
                  OnboardingStepsActions(
                    onContinue: () => _manager.continuePressed(
                      onFinished: widget.onFinished,
                    ),
                    onSkip: widget.onSkip,
                  ),
                  const SizedBox(height: 8),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
