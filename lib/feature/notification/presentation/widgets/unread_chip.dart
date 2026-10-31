import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:fridgy/core/constants/locale_keys.dart';
import 'package:fridgy/core/theme/styles/app_colors.dart';
import 'package:fridgy/core/theme/styles/app_text_styles.dart';

class UnreadChip extends StatelessWidget {
  const UnreadChip({required this.count, super.key});

  final int count;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 32,
      alignment: Alignment.center,
      padding: const EdgeInsetsDirectional.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: AppColors.surfaceAccent,
        borderRadius: BorderRadius.circular(99),
      ),
      child: Text(
        LocaleKeys.unreadCountChip.tr(args: ['$count']),
        style: AppTextStyles.captionSemiBold12Brand,
      ),
    );
  }
}
