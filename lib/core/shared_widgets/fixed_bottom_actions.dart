import 'package:flutter/material.dart';
import 'package:fridgy/core/shared_widgets/primary_button.dart';
import 'package:fridgy/core/shared_widgets/text_action_button.dart';
import 'package:fridgy/core/theme/styles/app_colors.dart';

class FixedBottomActions extends StatelessWidget {
  const FixedBottomActions({
    super.key,
    required this.primaryLabel,
    required this.onPrimaryPressed,
    this.secondaryLabel,
    this.onSecondaryPressed,
    this.primaryTrailingIcon,
    this.isPrimaryLoading = false,
    this.secondaryChild,
  });

  final String primaryLabel;
  final VoidCallback? onPrimaryPressed;
  final String? secondaryLabel;
  final VoidCallback? onSecondaryPressed;
  final String? primaryTrailingIcon;
  final bool isPrimaryLoading;
  final Widget? secondaryChild;

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: AppColors.surfaceDefault,
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 8),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              PrimaryButton(
                label: primaryLabel,
                onPressed: onPrimaryPressed,
                trailingIcon: primaryTrailingIcon,
                isLoading: isPrimaryLoading,
              ),
              if (secondaryChild != null) ...[
                const SizedBox(height: 8),
                secondaryChild!,
              ] else if (secondaryLabel != null) ...[
                const SizedBox(height: 8),
                TextActionButton(
                  label: secondaryLabel!,
                  onPressed: onSecondaryPressed,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
