import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:fridgy/core/constants/locale_keys.dart';
import 'package:fridgy/core/theme/styles/app_colors.dart';
import 'package:fridgy/core/theme/styles/app_text_styles.dart';
import 'package:fridgy/feature/home/domain/entities/weekly_impact_entity.dart';

class WeeklyImpactCard extends StatelessWidget {
  const WeeklyImpactCard({required this.impact, super.key});

  final WeeklyImpactEntity impact;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          LocaleKeys.yourWeeklyImpact.tr(),
          style: AppTextStyles.titleBold20,
        ),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.surfaceAccent,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                LocaleKeys.youSavedItems.tr(
                  args: ['${impact.savedItemsCount}'],
                ),
                style: AppTextStyles.titleBold20,
              ),
              const SizedBox(height: 14),
              Text(
                LocaleKeys.estimatedSavings.tr(
                  args: [impact.estimatedSavings.display],
                ),
                style: AppTextStyles.secondaryBodyRegular14Text,
              ),
              const SizedBox(height: 12),
              ClipRRect(
                borderRadius: BorderRadius.circular(99),
                child: LinearProgressIndicator(
                  value: impact.progress,
                  minHeight: 6,
                  backgroundColor: AppColors.borderDefault,
                  color: AppColors.brandPrimary,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                LocaleKeys.weeklyGoalProgress.tr(
                  args: [
                    '${impact.savedItemsCount}',
                    '${impact.goalItemsCount}',
                  ],
                ),
                style: AppTextStyles.captionRegular12,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
