import 'package:fridgy/core/helper/print_debug.dart';

enum NotificationType {
  expiryReminder,
  householdUpdate,
  mealPlan;

  static NotificationType? fromJson(String? value) {
    if (value == null) return null;
    switch (value) {
      case 'expiry_reminder':
        return NotificationType.expiryReminder;
      case 'household_update':
        return NotificationType.householdUpdate;
      case 'meal_plan':
        return NotificationType.mealPlan;
      default:
        printDebug(message: 'Unknown NotificationType: $value');
        return null;
    }
  }
}
