import 'package:equatable/equatable.dart';
import 'package:fridgy/feature/profile_setup/domain/entities/household_size.dart';
import 'package:fridgy/feature/profile_setup/domain/entities/setup_options_entity.dart';
import 'package:fridgy/feature/profile_setup/domain/entities/workout_frequency.dart';

enum OptionsStatus { loading, loaded, failure }

enum SubmitStatus { idle, loading, success, failure }

class ProfileSetupState extends Equatable {
  const ProfileSetupState({
    this.isEditMode = false,
    this.optionsStatus = OptionsStatus.loading,
    this.options,
    this.optionsError,
    this.currentStep = 0,
    this.householdSize,
    this.favoriteFoodIds = const {},
    this.dietId,
    this.avoidIngredientIds = const {},
    this.worksOut,
    this.workoutFrequency,
    this.notificationsEnabled,
    this.skippedSteps = const {},
    this.submitStatus = SubmitStatus.idle,
    this.submitError,
  });

  final bool isEditMode;
  final OptionsStatus optionsStatus;
  final SetupOptionsEntity? options;
  final String? optionsError;
  final int currentStep;
  final HouseholdSize? householdSize;
  final Set<String> favoriteFoodIds;
  final String? dietId;
  final Set<String> avoidIngredientIds;
  final bool? worksOut;
  final WorkoutFrequency? workoutFrequency;
  final bool? notificationsEnabled;
  final Set<int> skippedSteps;
  final SubmitStatus submitStatus;
  final String? submitError;

  static const int totalSteps = 7;
  static const int editTotalSteps = 2;

  /// Display step number for the counter (1-based).
  int get displayStepNumber => currentStep + 1;

  int get progressSegmentCount => isEditMode ? editTotalSteps : totalSteps;

  bool get canContinue {
    if (isEditMode) {
      switch (currentStep) {
        case 0:
          return favoriteFoodIds.isNotEmpty;
        case 1:
          return dietId != null;
        default:
          return true;
      }
    }
    switch (currentStep) {
      case 0:
        return householdSize != null;
      case 1:
        return favoriteFoodIds.isNotEmpty;
      case 2:
        return dietId != null;
      case 3:
        return worksOut != null;
      case 4:
        return workoutFrequency != null;
      default:
        return true;
    }
  }

  ProfileSetupState copyWith({
    bool? isEditMode,
    OptionsStatus? optionsStatus,
    SetupOptionsEntity? options,
    String? optionsError,
    bool clearOptionsError = false,
    int? currentStep,
    HouseholdSize? householdSize,
    bool clearHouseholdSize = false,
    Set<String>? favoriteFoodIds,
    String? dietId,
    bool clearDietId = false,
    Set<String>? avoidIngredientIds,
    bool? worksOut,
    bool clearWorksOut = false,
    WorkoutFrequency? workoutFrequency,
    bool clearWorkoutFrequency = false,
    bool? notificationsEnabled,
    Set<int>? skippedSteps,
    SubmitStatus? submitStatus,
    String? submitError,
    bool clearSubmitError = false,
  }) {
    return ProfileSetupState(
      isEditMode: isEditMode ?? this.isEditMode,
      optionsStatus: optionsStatus ?? this.optionsStatus,
      options: options ?? this.options,
      optionsError: clearOptionsError
          ? null
          : (optionsError ?? this.optionsError),
      currentStep: currentStep ?? this.currentStep,
      householdSize: clearHouseholdSize
          ? null
          : (householdSize ?? this.householdSize),
      favoriteFoodIds: favoriteFoodIds ?? this.favoriteFoodIds,
      dietId: clearDietId ? null : (dietId ?? this.dietId),
      avoidIngredientIds: avoidIngredientIds ?? this.avoidIngredientIds,
      worksOut: clearWorksOut ? null : (worksOut ?? this.worksOut),
      workoutFrequency: clearWorkoutFrequency
          ? null
          : (workoutFrequency ?? this.workoutFrequency),
      notificationsEnabled: notificationsEnabled ?? this.notificationsEnabled,
      skippedSteps: skippedSteps ?? this.skippedSteps,
      submitStatus: submitStatus ?? this.submitStatus,
      submitError: clearSubmitError ? null : (submitError ?? this.submitError),
    );
  }

  @override
  List<Object?> get props => [
    isEditMode,
    optionsStatus,
    options,
    optionsError,
    currentStep,
    householdSize,
    favoriteFoodIds,
    dietId,
    avoidIngredientIds,
    worksOut,
    workoutFrequency,
    notificationsEnabled,
    skippedSteps,
    submitStatus,
    submitError,
  ];
}
