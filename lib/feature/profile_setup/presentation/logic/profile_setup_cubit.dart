import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fridgy/feature/profile_setup/domain/entities/household_size.dart';
import 'package:fridgy/feature/profile_setup/domain/entities/workout_frequency.dart';
import 'package:fridgy/feature/profile_setup/domain/params/profile_preferences_params.dart';
import 'package:fridgy/feature/profile_setup/domain/repos/profile_setup_repo.dart';
import 'package:fridgy/feature/profile_setup/presentation/logic/profile_setup_state.dart';

class ProfileSetupCubit extends Cubit<ProfileSetupState> {
  ProfileSetupCubit({
    required ProfileSetupRepo profileSetupRepo,
    this.isEditMode = false,
  }) : _repo = profileSetupRepo,
       super(ProfileSetupState(isEditMode: isEditMode)) {
    load();
  }

  final ProfileSetupRepo _repo;
  final bool isEditMode;

  Future<void> load() async {
    await loadOptions();
    if (isEditMode) {
      await loadPreferences();
    }
  }

  Future<void> loadOptions() async {
    if (isClosed) return;
    emit(
      state.copyWith(
        optionsStatus: OptionsStatus.loading,
        clearOptionsError: true,
      ),
    );

    final result = await _repo.getSetupOptions();
    if (isClosed) return;

    result.fold(
      (failure) => emit(
        state.copyWith(
          optionsStatus: OptionsStatus.failure,
          optionsError: failure.message,
        ),
      ),
      (options) => emit(
        state.copyWith(
          optionsStatus: OptionsStatus.loaded,
          options: options,
          clearOptionsError: true,
        ),
      ),
    );
  }

  Future<void> loadPreferences() async {
    if (isClosed) return;
    final result = await _repo.getPreferences();
    if (isClosed) return;

    result.fold(
      (failure) => emit(
        state.copyWith(
          optionsStatus: OptionsStatus.failure,
          optionsError: failure.message,
        ),
      ),
      (prefs) {
        emit(
          state.copyWith(
            householdSize: prefs.householdSize,
            favoriteFoodIds: prefs.favoriteFoodIds ?? {},
            dietId: prefs.dietId,
            avoidIngredientIds: prefs.avoidIngredientIds ?? {},
            worksOut: prefs.worksOut,
            workoutFrequency: prefs.workoutFrequency,
            notificationsEnabled: prefs.notificationsEnabled,
            currentStep: 0,
            clearOptionsError: true,
          ),
        );
      },
    );
  }

  void selectHouseholdSize(HouseholdSize size) {
    final skipped = Set<int>.from(state.skippedSteps)..remove(0);
    emit(state.copyWith(householdSize: size, skippedSteps: skipped));
  }

  void toggleFavoriteFood(String id) {
    final next = Set<String>.from(state.favoriteFoodIds);
    if (!next.add(id)) next.remove(id);
    final skipped = Set<int>.from(state.skippedSteps)..remove(1);
    emit(state.copyWith(favoriteFoodIds: next, skippedSteps: skipped));
  }

  void selectDiet(String id) {
    final skipped = Set<int>.from(state.skippedSteps)..remove(2);
    emit(state.copyWith(dietId: id, skippedSteps: skipped));
  }

  void setAvoidIngredients(Set<String> ids) {
    emit(state.copyWith(avoidIngredientIds: ids));
  }

  void selectWorksOut(bool value) {
    final skipped = Set<int>.from(state.skippedSteps)..remove(3);
    emit(
      state.copyWith(
        worksOut: value,
        skippedSteps: skipped,
        clearWorkoutFrequency: !value,
      ),
    );
  }

  void selectWorkoutFrequency(WorkoutFrequency frequency) {
    final skipped = Set<int>.from(state.skippedSteps)..remove(4);
    emit(state.copyWith(workoutFrequency: frequency, skippedSteps: skipped));
  }

  void continueStep() {
    if (!state.canContinue) return;
    if (isEditMode) {
      if (state.currentStep == 0) {
        emit(state.copyWith(currentStep: 1));
        return;
      }
      submit();
      return;
    }
    _goForward();
  }

  void skipStep() {
    if (isEditMode) {
      final skipped = Set<int>.from(state.skippedSteps);
      if (state.currentStep == 0) {
        skipped.add(1);
        emit(state.copyWith(skippedSteps: skipped, favoriteFoodIds: {}));
        emit(state.copyWith(currentStep: 1));
        return;
      }
      skipped.add(2);
      emit(
        state.copyWith(
          skippedSteps: skipped,
          clearDietId: true,
          avoidIngredientIds: {},
        ),
      );
      submit();
      return;
    }

    final skipped = Set<int>.from(state.skippedSteps)..add(state.currentStep);
    final step = state.currentStep;

    if (step == 0) {
      emit(state.copyWith(skippedSteps: skipped, clearHouseholdSize: true));
    } else if (step == 1) {
      emit(state.copyWith(skippedSteps: skipped, favoriteFoodIds: {}));
    } else if (step == 2) {
      emit(
        state.copyWith(
          skippedSteps: skipped,
          clearDietId: true,
          avoidIngredientIds: {},
        ),
      );
    } else if (step == 3) {
      skipped.add(4);
      emit(
        state.copyWith(
          skippedSteps: skipped,
          clearWorksOut: true,
          clearWorkoutFrequency: true,
        ),
      );
    } else if (step == 4) {
      emit(state.copyWith(skippedSteps: skipped, clearWorkoutFrequency: true));
    } else {
      emit(state.copyWith(skippedSteps: skipped));
    }

    _goForward();
  }

  /// Returns true when the screen should pop instead of navigating back.
  bool back() {
    if (isEditMode) {
      if (state.currentStep <= 0) return true;
      emit(state.copyWith(currentStep: state.currentStep - 1));
      return false;
    }

    if (state.currentStep <= 0) return false;

    var previous = state.currentStep - 1;
    if (state.currentStep == 5 && state.skippedSteps.contains(4)) {
      previous = 3;
    }

    emit(state.copyWith(currentStep: previous));
    return false;
  }

  void enableNotifications() {
    emit(state.copyWith(notificationsEnabled: true));
    submit();
  }

  void maybeLater() {
    emit(state.copyWith(notificationsEnabled: false));
    submit();
  }

  Future<void> submit() async {
    if (isClosed) return;
    emit(
      state.copyWith(
        submitStatus: SubmitStatus.loading,
        clearSubmitError: true,
      ),
    );

    final ProfilePreferencesParams params;
    if (isEditMode) {
      params = ProfilePreferencesParams(
        householdSize: state.householdSize,
        favoriteFoodIds: state.skippedSteps.contains(1)
            ? null
            : state.favoriteFoodIds,
        dietId: state.skippedSteps.contains(2) ? null : state.dietId,
        avoidIngredientIds: state.skippedSteps.contains(2)
            ? null
            : state.avoidIngredientIds,
        worksOut: state.worksOut,
        workoutFrequency: state.worksOut == true
            ? state.workoutFrequency
            : null,
        notificationsEnabled: state.notificationsEnabled,
      );
    } else {
      params = ProfilePreferencesParams(
        householdSize: state.skippedSteps.contains(0)
            ? null
            : state.householdSize,
        favoriteFoodIds: state.skippedSteps.contains(1)
            ? null
            : state.favoriteFoodIds,
        dietId: state.skippedSteps.contains(2) ? null : state.dietId,
        avoidIngredientIds: state.skippedSteps.contains(2)
            ? null
            : state.avoidIngredientIds,
        worksOut: state.skippedSteps.contains(3) ? null : state.worksOut,
        workoutFrequency:
            (state.skippedSteps.contains(3) ||
                state.skippedSteps.contains(4) ||
                state.worksOut != true)
            ? null
            : state.workoutFrequency,
        notificationsEnabled: state.notificationsEnabled,
      );
    }

    final result = await _repo.savePreferences(params);
    if (isClosed) return;

    result.fold(
      (failure) => emit(
        state.copyWith(
          submitStatus: SubmitStatus.failure,
          submitError: failure.message,
        ),
      ),
      (_) {
        if (isEditMode) {
          emit(
            state.copyWith(
              submitStatus: SubmitStatus.success,
              clearSubmitError: true,
            ),
          );
          return;
        }
        emit(
          state.copyWith(
            submitStatus: SubmitStatus.success,
            currentStep: 6,
            clearSubmitError: true,
          ),
        );
      },
    );
  }

  void _goForward() {
    final step = state.currentStep;
    if (step >= 5) return;

    if (step == 3) {
      final skipFrequency =
          state.worksOut != true || state.skippedSteps.contains(3);
      if (skipFrequency) {
        final skipped = Set<int>.from(state.skippedSteps)..add(4);
        emit(
          state.copyWith(
            currentStep: 5,
            skippedSteps: skipped,
            clearWorkoutFrequency: true,
          ),
        );
        return;
      }
    }

    emit(state.copyWith(currentStep: step + 1));
  }
}
