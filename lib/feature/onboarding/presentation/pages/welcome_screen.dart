import 'package:flutter/material.dart';
import 'package:fridgy/core/shared_widgets/fridgy_brand_header.dart';
import 'package:fridgy/core/theme/styles/app_colors.dart';
import 'package:fridgy/feature/onboarding/presentation/widgets/welcome_actions.dart';
import 'package:fridgy/feature/onboarding/presentation/widgets/welcome_editorial_copy.dart';
import 'package:fridgy/feature/onboarding/presentation/widgets/welcome_hero_image.dart';
import 'package:fridgy/feature/onboarding/presentation/widgets/welcome_keywords_row.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({
    super.key,
    required this.onGetStarted,
    required this.onSignIn,
  });

  final VoidCallback onGetStarted;
  final VoidCallback onSignIn;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surfaceDefault,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: const [
                      FridgyBrandHeader(),
                      SizedBox(height: 16),
                      WelcomeHeroImage(),
                      SizedBox(height: 16),
                      WelcomeEditorialCopy(),
                      SizedBox(height: 16),
                      WelcomeKeywordsRow(),
                    ],
                  ),
                ),
              ),
              WelcomeActions(
                onGetStarted: onGetStarted,
                onSignIn: onSignIn,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
