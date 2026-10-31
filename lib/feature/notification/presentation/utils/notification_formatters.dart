import 'package:easy_localization/easy_localization.dart';
import 'package:fridgy/core/constants/app_assets.dart';
import 'package:fridgy/core/constants/locale_keys.dart';
import 'package:fridgy/feature/notification/domain/entities/notification_type.dart';

abstract class NotificationFormatters {
  static String typeLabel(NotificationType? type) {
    switch (type) {
      case NotificationType.expiryReminder:
        return LocaleKeys.notifTypeExpiryReminder.tr();
      case NotificationType.householdUpdate:
        return LocaleKeys.notifTypeHouseholdUpdate.tr();
      case NotificationType.mealPlan:
        return LocaleKeys.notifTypeMealPlan.tr();
      case null:
        return '';
    }
  }

  /// Fallback icon shown when `image_url` is null (D/notifications).
  static String fallbackIcon(NotificationType? type) {
    switch (type) {
      case NotificationType.householdUpdate:
        return AppAssets.icUsers;
      case NotificationType.mealPlan:
        return AppAssets.icCalendarDays;
      case NotificationType.expiryReminder:
      case null:
        return AppAssets.icBell;
    }
  }
}
