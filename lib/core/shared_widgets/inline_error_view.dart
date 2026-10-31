import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:fridgy/core/constants/locale_keys.dart';
import 'package:fridgy/core/shared_widgets/primary_button.dart';
import 'package:fridgy/core/theme/styles/app_text_styles.dart';

/// Centered inline error message with a retry button, used by data-driven
/// screens when a request fails.
class InlineErrorView extends StatelessWidget {
  const InlineErrorView({
    required this.message,
    required this.onRetry,
    super.key,
  });

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsetsDirectional.symmetric(horizontal: 24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              message,
              style: AppTextStyles.secondaryBodyRegular14Text,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            PrimaryButton(label: LocaleKeys.tryAgain.tr(), onPressed: onRetry),
          ],
        ),
      ),
    );
  }
}
