import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:fridgy/core/constants/locale_keys.dart';
import 'package:fridgy/core/theme/styles/app_text_styles.dart';

class ComingSoonView extends StatelessWidget {
  const ComingSoonView({required this.title, super.key});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(title, style: AppTextStyles.titleBold20),
          const SizedBox(height: 8),
          Text(
            LocaleKeys.tabComingSoon.tr(),
            style: AppTextStyles.secondaryBodyRegular14Text,
          ),
        ],
      ),
    );
  }
}
