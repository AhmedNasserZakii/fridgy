import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:fridgy/core/constants/locale_keys.dart';
import 'package:fridgy/core/shared_widgets/primary_button.dart';
import 'package:fridgy/core/theme/styles/app_text_styles.dart';

class ShoppingListEmptyView extends StatelessWidget {
  const ShoppingListEmptyView({required this.onAddTap, super.key});

  final VoidCallback onAddTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            LocaleKeys.shoppingListEmptyTitle.tr(),
            textAlign: TextAlign.center,
            style: AppTextStyles.titleBold20,
          ),
          const SizedBox(height: 8),
          Text(
            LocaleKeys.shoppingListEmptyBody.tr(),
            textAlign: TextAlign.center,
            style: AppTextStyles.secondaryBodyRegular14Text,
          ),
          const SizedBox(height: 24),
          PrimaryButton(
            label: LocaleKeys.shoppingAddItem.tr(),
            onPressed: onAddTap,
          ),
        ],
      ),
    );
  }
}
