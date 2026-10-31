import 'package:equatable/equatable.dart';
import 'package:fridgy/feature/profile_setup/domain/entities/household_size.dart';
import 'package:fridgy/feature/profile_setup/domain/entities/workout_frequency.dart';

class ProfilePreferencesParams extends Equatable {
  const ProfilePreferencesParams({
    this.householdSize,
    this.favoriteFoodIds,
    this.dietId,
    this.avoidIngredientIds,
    this.worksOut,
    this.workoutFrequency,
    this.notificationsEnabled,
  });

  final HouseholdSize? householdSize;
  final Set<String>? favoriteFoodIds;
  final String? dietId;
  final Set<String>? avoidIngredientIds;
  final bool? worksOut;
  final WorkoutFrequency? workoutFrequency;
  final bool? notificationsEnabled;

  @override
  List<Object?> get props => [
    householdSize,
    favoriteFoodIds,
    dietId,
    avoidIngredientIds,
    worksOut,
    workoutFrequency,
    notificationsEnabled,
  ];
}
