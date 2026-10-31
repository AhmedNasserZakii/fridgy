import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:fridgy/core/constants/locale_keys.dart';
import 'package:fridgy/core/theme/styles/app_text_styles.dart';

class ExpiringSoonHeader extends StatelessWidget {
  const ExpiringSoonHeader({required this.total, super.key});

  final int total;

  @override
  Widget build(BuildContext context) {
    // The date is the device's local date (D14).
    final today = DateFormat('d MMM yyyy').format(DateTime.now());
    return Text(
      LocaleKeys.expiringHeaderCount.tr(args: ['$total', today]),
      style: AppTextStyles.bodyRegular16,
    );
  }
}
