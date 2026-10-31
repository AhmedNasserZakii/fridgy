import 'package:fridgy/core/network_services/api_keys.dart';
import 'package:fridgy/feature/more/domain/entities/notification_settings_entity.dart';

class NotificationSettingsModel {
  const NotificationSettingsModel({
    required this.osPermissionGranted,
    required this.expiryRemindersEnabled,
    required this.remindDaysBefore,
    required this.reminderTime,
    required this.timezone,
    required this.shoppingListUpdates,
    required this.householdActivity,
    required this.weeklyImpactRecap,
  });

  final bool osPermissionGranted;
  final bool expiryRemindersEnabled;
  final int remindDaysBefore;
  final String reminderTime;
  final String timezone;
  final bool shoppingListUpdates;
  final bool householdActivity;
  final bool weeklyImpactRecap;

  factory NotificationSettingsModel.fromJson(Map<String, dynamic> json) {
    return NotificationSettingsModel(
      osPermissionGranted: json[ApiKeys.osPermissionGranted] as bool,
      expiryRemindersEnabled: json[ApiKeys.expiryRemindersEnabled] as bool,
      remindDaysBefore: json[ApiKeys.remindDaysBefore] as int,
      reminderTime: json[ApiKeys.reminderTime] as String,
      timezone: json[ApiKeys.timezone] as String,
      shoppingListUpdates: json[ApiKeys.shoppingListUpdates] as bool,
      householdActivity: json[ApiKeys.householdActivity] as bool,
      weeklyImpactRecap: json[ApiKeys.weeklyImpactRecap] as bool,
    );
  }

  NotificationSettingsEntity toEntity() {
    return NotificationSettingsEntity(
      osPermissionGranted: osPermissionGranted,
      expiryRemindersEnabled: expiryRemindersEnabled,
      remindDaysBefore: remindDaysBefore,
      reminderTime: reminderTime,
      timezone: timezone,
      shoppingListUpdates: shoppingListUpdates,
      householdActivity: householdActivity,
      weeklyImpactRecap: weeklyImpactRecap,
    );
  }
}
