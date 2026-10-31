import 'package:fridgy/core/network_services/api_keys.dart';
import 'package:fridgy/feature/more/domain/params/update_notification_settings_params.dart';

class NotificationSettingsRequestModel {
  const NotificationSettingsRequestModel(this.params);

  final UpdateNotificationSettingsParams params;

  Map<String, dynamic> toJson() {
    return {
      ApiKeys.expiryRemindersEnabled: params.expiryRemindersEnabled,
      ApiKeys.remindDaysBefore: params.remindDaysBefore,
      ApiKeys.reminderTime: params.reminderTime,
      ApiKeys.timezone: params.timezone,
      ApiKeys.shoppingListUpdates: params.shoppingListUpdates,
      ApiKeys.householdActivity: params.householdActivity,
      ApiKeys.weeklyImpactRecap: params.weeklyImpactRecap,
    };
  }
}
