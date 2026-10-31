import 'package:equatable/equatable.dart';
import 'package:fridgy/feature/more/domain/entities/notification_settings_entity.dart';

/// Request body for `PUT notification-settings`. Excludes
/// [NotificationSettingsEntity.osPermissionGranted] — that flag is owned by
/// the OS, never written by the app.
class UpdateNotificationSettingsParams extends Equatable {
  const UpdateNotificationSettingsParams({
    required this.expiryRemindersEnabled,
    required this.remindDaysBefore,
    required this.reminderTime,
    required this.timezone,
    required this.shoppingListUpdates,
    required this.householdActivity,
    required this.weeklyImpactRecap,
  });

  factory UpdateNotificationSettingsParams.fromEntity(
    NotificationSettingsEntity entity,
  ) {
    return UpdateNotificationSettingsParams(
      expiryRemindersEnabled: entity.expiryRemindersEnabled,
      remindDaysBefore: entity.remindDaysBefore,
      reminderTime: entity.reminderTime,
      timezone: entity.timezone,
      shoppingListUpdates: entity.shoppingListUpdates,
      householdActivity: entity.householdActivity,
      weeklyImpactRecap: entity.weeklyImpactRecap,
    );
  }

  final bool expiryRemindersEnabled;
  final int remindDaysBefore;
  final String reminderTime;
  final String timezone;
  final bool shoppingListUpdates;
  final bool householdActivity;
  final bool weeklyImpactRecap;

  @override
  List<Object?> get props => [
    expiryRemindersEnabled,
    remindDaysBefore,
    reminderTime,
    timezone,
    shoppingListUpdates,
    householdActivity,
    weeklyImpactRecap,
  ];
}
