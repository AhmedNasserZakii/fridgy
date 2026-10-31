import 'package:equatable/equatable.dart';
import 'package:fridgy/feature/more/domain/entities/notification_settings_entity.dart';

enum NotificationSettingsStatus { loading, loaded, failure }

class NotificationSettingsState extends Equatable {
  const NotificationSettingsState({
    this.status = NotificationSettingsStatus.loading,
    this.settings,
    this.errorMessage,
    this.isSaving = false,
  });

  final NotificationSettingsStatus status;
  final NotificationSettingsEntity? settings;
  final String? errorMessage;
  final bool isSaving;

  NotificationSettingsState copyWith({
    NotificationSettingsStatus? status,
    NotificationSettingsEntity? settings,
    String? errorMessage,
    bool clearError = false,
    bool? isSaving,
  }) {
    return NotificationSettingsState(
      status: status ?? this.status,
      settings: settings ?? this.settings,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
      isSaving: isSaving ?? this.isSaving,
    );
  }

  @override
  List<Object?> get props => [status, settings, errorMessage, isSaving];
}
