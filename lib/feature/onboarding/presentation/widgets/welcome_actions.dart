import 'package:flutter/material.dart';
import 'package:fridgy/core/shared_widgets/primary_button.dart';
import 'package:fridgy/core/shared_widgets/text_action_button.dart';

class WelcomeActions extends StatelessWidget {
  const WelcomeActions({
    super.key,
    required this.onGetStarted,
    required this.onSignIn,
  });

  final VoidCallback onGetStarted;
  final VoidCallback onSignIn;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        PrimaryButton(label: 'Get started', onPressed: onGetStarted),
        TextActionButton(label: 'Sign in', onPressed: onSignIn),
      ],
    );
  }
}
