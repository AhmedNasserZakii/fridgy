import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fridgy/feature/more/domain/entities/notification_settings_entity.dart';
import 'package:fridgy/feature/more/domain/params/update_notification_settings_params.dart';
import 'package:fridgy/feature/more/domain/repos/notification_settings_repo.dart';
import 'package:fridgy/feature/more/presentation/logic/notification_settings_state.dart';

class NotificationSettingsCubit extends Cubit<NotificationSettingsState> {
  NotificationSettingsCubit({
    required NotificationSettingsRepo notificationSettingsRepo,
  }) : _repo = notificationSettingsRepo,
       super(const NotificationSettingsState()) {
    load();
  }

  final NotificationSettingsRepo _repo;

  Future<void> load() async {
    if (isClosed) return;
    emit(
      state.copyWith(
        status: NotificationSettingsStatus.loading,
        clearError: true,
      ),
    );
    final result = await _repo.getNotificationSettings();
    if (isClosed) return;
    result.fold(
      (failure) => emit(
        state.copyWith(
          status: NotificationSettingsStatus.failure,
          errorMessage: failure.message,
        ),
      ),
      (settings) => emit(
        state.copyWith(
          status: NotificationSettingsStatus.loaded,
          settings: settings,
          clearError: true,
        ),
      ),
    );
  }

  Future<void> setExpiryReminders(bool value) =>
      _patch((s) => s.copyWith(expiryRemindersEnabled: value));

  Future<void> setShoppingListUpdates(bool value) =>
      _patch((s) => s.copyWith(shoppingListUpdates: value));

  Future<void> setHouseholdActivity(bool value) =>
      _patch((s) => s.copyWith(householdActivity: value));

  Future<void> setWeeklyImpactRecap(bool value) =>
      _patch((s) => s.copyWith(weeklyImpactRecap: value));

  Future<void> setRemindDaysBefore(int days) =>
      _patch((s) => s.copyWith(remindDaysBefore: days));

  Future<void> _patch(
    NotificationSettingsEntity Function(NotificationSettingsEntity) update,
  ) async {
    final current = state.settings;
    if (current == null || isClosed) return;
    final optimistic = update(current);
    emit(
      state.copyWith(settings: optimistic, isSaving: true, clearError: true),
    );

    final result = await _repo.updateNotificationSettings(
      UpdateNotificationSettingsParams.fromEntity(optimistic),
    );
    if (isClosed) return;

    result.fold(
      (failure) => emit(
        state.copyWith(
          settings: current,
          isSaving: false,
          errorMessage: failure.message,
        ),
      ),
      (saved) => emit(
        state.copyWith(settings: saved, isSaving: false, clearError: true),
      ),
    );
  }
}
