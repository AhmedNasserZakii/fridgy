import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:fridgy/core/constants/locale_keys.dart';
import 'package:fridgy/core/theme/styles/app_text_styles.dart';

class NotificationGroupHeader extends StatelessWidget {
  const NotificationGroupHeader({required this.date, super.key});

  final DateTime date;

  @override
  Widget build(BuildContext context) {
    return Text(_label(), style: AppTextStyles.titleBold20);
  }

  String _label() {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final target = DateTime(date.year, date.month, date.day);
    final difference = today.difference(target).inDays;
    if (difference == 0) return LocaleKeys.today.tr();
    if (difference == 1) return LocaleKeys.yesterday.tr();
    return DateFormat('d MMM yyyy').format(target);
  }
}
