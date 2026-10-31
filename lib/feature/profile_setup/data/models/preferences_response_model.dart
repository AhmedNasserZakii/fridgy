import 'package:fridgy/core/network_services/api_keys.dart';
import 'package:fridgy/feature/profile_setup/domain/entities/household_size.dart';
import 'package:fridgy/feature/profile_setup/domain/entities/workout_frequency.dart';
import 'package:fridgy/feature/profile_setup/domain/params/profile_preferences_params.dart';

class PreferencesResponseModel {
  const PreferencesResponseModel({
    required this.householdSize,
    required this.favoriteFoodIds,
    required this.dietId,
    required this.avoidIngredientIds,
    required this.worksOut,
    required this.workoutFrequency,
    required this.notificationsEnabled,
  });

  final int? householdSize;
  final List<String>? favoriteFoodIds;
  final String? dietId;
  final List<String>? avoidIngredientIds;
  final bool? worksOut;
  final String? workoutFrequency;
  final bool? notificationsEnabled;

  factory PreferencesResponseModel.fromJson(Map<String, dynamic> json) {
    return PreferencesResponseModel(
      householdSize: json[ApiKeys.householdSize] as int?,
      favoriteFoodIds: (json[ApiKeys.favoriteFoodIds] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      dietId: json[ApiKeys.dietId] as String?,
      avoidIngredientIds: (json[ApiKeys.avoidIngredientIds] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      worksOut: json[ApiKeys.worksOut] as bool?,
      workoutFrequency: json[ApiKeys.workoutFrequency] as String?,
      notificationsEnabled: json[ApiKeys.notificationsEnabled] as bool?,
    );
  }

  ProfilePreferencesParams toParams() {
    return ProfilePreferencesParams(
      householdSize: _householdSizeFromJson(householdSize),
      favoriteFoodIds: favoriteFoodIds?.toSet(),
      dietId: dietId,
      avoidIngredientIds: avoidIngredientIds?.toSet(),
      worksOut: worksOut,
      workoutFrequency: _workoutFrequencyFromJson(workoutFrequency),
      notificationsEnabled: notificationsEnabled,
    );
  }

  static HouseholdSize? _householdSizeFromJson(int? value) {
    if (value == null) return null;
    for (final size in HouseholdSize.values) {
      if (size.jsonValue == value) return size;
    }
    return null;
  }

  static WorkoutFrequency? _workoutFrequencyFromJson(String? value) {
    if (value == null) return null;
    for (final frequency in WorkoutFrequency.values) {
      if (frequency.jsonValue == value) return frequency;
    }
    return null;
  }
}
