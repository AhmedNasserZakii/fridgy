import 'package:fridgy/core/network_services/api_keys.dart';
import 'package:fridgy/feature/profile_setup/domain/params/profile_preferences_params.dart';

class PreferencesRequestModel {
  const PreferencesRequestModel({
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

  factory PreferencesRequestModel.fromParams(ProfilePreferencesParams params) {
    return PreferencesRequestModel(
      householdSize: params.householdSize?.toJson(),
      favoriteFoodIds: params.favoriteFoodIds?.toList(),
      dietId: params.dietId,
      avoidIngredientIds: params.avoidIngredientIds?.toList(),
      worksOut: params.worksOut,
      workoutFrequency: params.workoutFrequency?.toJson(),
      notificationsEnabled: params.notificationsEnabled,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      ApiKeys.householdSize: householdSize,
      ApiKeys.favoriteFoodIds: favoriteFoodIds,
      ApiKeys.dietId: dietId,
      ApiKeys.avoidIngredientIds: avoidIngredientIds,
      ApiKeys.worksOut: worksOut,
      ApiKeys.workoutFrequency: workoutFrequency,
      ApiKeys.notificationsEnabled: notificationsEnabled,
    };
  }
}
