import 'package:flutter/material.dart';
import 'package:fridgy/core/theme/styles/app_text_styles.dart';

class AuthSwitchPrompt extends StatelessWidget {
  const AuthSwitchPrompt({
    super.key,
    required this.leading,
    required this.actionLabel,
    required this.onPressed,
  });

  final String leading;
  final String actionLabel;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 52,
      width: double.infinity,
      child: TextButton(
        onPressed: onPressed,
        style: TextButton.styleFrom(padding: EdgeInsets.zero),
        child: Text.rich(
          TextSpan(
            children: [
              TextSpan(
                text: '$leading ',
                style: AppTextStyles.secondaryBodyRegular14Text,
              ),
              TextSpan(
                text: actionLabel,
                style: AppTextStyles.secondaryBodySemiBold14Brand,
              ),
            ],
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
