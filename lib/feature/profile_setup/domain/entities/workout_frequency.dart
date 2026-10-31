import 'package:fridgy/core/constants/app_assets.dart';
import 'package:fridgy/core/constants/locale_keys.dart';

enum WorkoutFrequency {
  days12(
    'days_1_2',
    LocaleKeys.workoutDays12,
    LocaleKeys.workoutDays12Subtitle,
    AppAssets.icWorkoutLight,
  ),
  days34(
    'days_3_4',
    LocaleKeys.workoutDays34,
    LocaleKeys.workoutDays34Subtitle,
    AppAssets.icWorkoutConsistent,
  ),
  days56(
    'days_5_6',
    LocaleKeys.workoutDays56,
    LocaleKeys.workoutDays56Subtitle,
    AppAssets.icWorkoutActive,
  ),
  everyDay(
    'every_day',
    LocaleKeys.workoutEveryDay,
    LocaleKeys.workoutEveryDaySubtitle,
    AppAssets.icWorkoutDaily,
  );

  const WorkoutFrequency(
    this.jsonValue,
    this.labelKey,
    this.subtitleKey,
    this.iconAsset,
  );

  final String jsonValue;
  final String labelKey;
  final String subtitleKey;
  final String iconAsset;

  String toJson() => jsonValue;
}
